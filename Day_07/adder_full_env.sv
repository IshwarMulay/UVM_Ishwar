`include "uvm_macros.svh"
import uvm_pkg::*;

//==================DUT Start==========================
module adder8 (
	input  logic [7:0] a,
	input  logic [7:0] b,
	output logic [8:0] sum   // 9 bits to hold carry-out
);
	assign sum = a + b;
endmodule
//==================DUT End=======================

//==================Interface Start==========================
interface adder_if;
	logic [7:0] a;
	logic [7:0] b;
	logic [8:0] sum;
endinterface
//==================Interface End=======================

//==================Seq_Item Start=====================
class seq_item extends uvm_sequence_item;
	rand bit [7:0] a;
	rand bit [7:0] b;
	     bit [8:0] sum;   // filled by monitor, not randomized

	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(a,   UVM_ALL_ON)
		`uvm_field_int(b,   UVM_ALL_ON)
		`uvm_field_int(sum, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction
endclass
//==================Seq_Item End=====================

//==================Sequence Start=======================
class my_sequence extends uvm_sequence #(seq_item);
	`uvm_object_utils(my_sequence)

	int num_txns = 10;

	function new (string name = "my_sequence");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW)

		repeat (num_txns) begin
			req = seq_item::type_id::create("req");
			start_item(req);
			if (!req.randomize()) begin
				`uvm_fatal("RAND_FAIL", "Randomization failed!")
			end
			finish_item(req);
		end
	endtask
endclass
//==================Sequence End=======================

//==================Sequencer Start==========================
class sequencer extends uvm_sequencer #(seq_item);
	`uvm_component_utils(sequencer)

	function new(string name = "sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass
//==================Sequencer End=======================

//==================Driver Start==========================
class driver extends uvm_driver #(seq_item);
	`uvm_component_utils(driver)

	virtual adder_if vif;

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db #(virtual adder_if)::get(this, "", "vif", vif))
			`uvm_fatal("NO_VIF", "Virtual interface not found for driver")
	endfunction

	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);

			vif.a = req.a;
			vif.b = req.b;
			#5; // allow combinational logic to settle

			`uvm_info(get_type_name(),
				$sformatf("Driver: a=%0d b=%0d", req.a, req.b), UVM_LOW)

			seq_item_port.item_done();
		end
	endtask
endclass
//==================Driver End=======================

//==================Monitor Start==========================
class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	virtual adder_if vif;
	uvm_analysis_port #(seq_item) ap;

	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap = new("ap", this);
		if (!uvm_config_db #(virtual adder_if)::get(this, "", "vif", vif))
			`uvm_fatal("NO_VIF", "Virtual interface not found for monitor")
	endfunction

	virtual task run_phase(uvm_phase phase);
		seq_item mon_item;

		forever begin
			#5; // sample after driver settles the combinational output
			mon_item = seq_item::type_id::create("mon_item");
			mon_item.a   = vif.a;
			mon_item.b   = vif.b;
			mon_item.sum = vif.sum;

			`uvm_info(get_type_name(),
				$sformatf("Monitor: a=%0d b=%0d sum=%0d", mon_item.a, mon_item.b, mon_item.sum),
				UVM_LOW)

			ap.write(mon_item);
		end
	endtask
endclass
//==================Monitor End=======================

//==================Agent Start==========================
class agent extends uvm_agent;
	`uvm_component_utils(agent)

	sequencer seqr;
	driver    drv;
	monitor   mon;

	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seqr = sequencer::type_id::create("seqr", this);
		drv  = driver::type_id::create("drv", this);
		mon  = monitor::type_id::create("mon", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass
//==================Agent End=======================

//==================Scoreboard Start==========================
class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp #(seq_item, scoreboard) imp;

	int num_checked = 0;
	int num_errors  = 0;

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		imp = new("imp", this);
	endfunction

	virtual function void write(seq_item t);
		bit [8:0] expected;
		expected = t.a + t.b;

		num_checked++;

		if (t.sum !== expected) begin
			num_errors++;
			`uvm_error(get_type_name(),
				$sformatf("MISMATCH: a=%0d b=%0d sum=%0d expected=%0d",
					t.a, t.b, t.sum, expected))
		end else begin
			`uvm_info(get_type_name(),
				$sformatf("MATCH: a=%0d b=%0d sum=%0d", t.a, t.b, t.sum), UVM_LOW)
		end
	endfunction

	virtual function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),
			$sformatf("Scoreboard: checked=%0d errors=%0d", num_checked, num_errors),
			UVM_LOW)
	endfunction
endclass
//==================Scoreboard End=======================

//==================Environment Start==========================
class env extends uvm_env;
	`uvm_component_utils(env)

	agent      agt;
	scoreboard sb;

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = agent::type_id::create("agt", this);
		sb  = scoreboard::type_id::create("sb", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agt.mon.ap.connect(sb.imp);
	endfunction
endclass
//==================Environment End=======================

//==================Test Start==========================
class test extends uvm_test;
	`uvm_component_utils(test)

	env         e;
	my_sequence seq;

	function new(string name = "test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e = env::type_id::create("e", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		seq = my_sequence::type_id::create("seq");
		seq.num_txns = 10;
		seq.start(e.agt.seqr);

		phase.drop_objection(this);
	endtask
endclass
//==================Test End=======================

//==================TB Top Start==========================
module tb_top;

	adder_if vif();

	adder8 u_dut (
		.a   (vif.a),
		.b   (vif.b),
		.sum (vif.sum)
	);

	initial begin
		uvm_config_db #(virtual adder_if)::set(null, "*", "vif", vif);
	end

	initial begin
		run_test("test");
	end

endmodule
//==================TB Top End=======================
