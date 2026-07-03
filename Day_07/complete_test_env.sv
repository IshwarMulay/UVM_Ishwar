`include "uvm_macros.svh"
import uvm_pkg::*;

//==================Seq_Item Start=====================
class seq_item extends uvm_sequence_item;
	// Data and control fields

	`uvm_object_utils_begin(seq_item)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction
	//Constraints if required
endclass
//==================Seq_Item End=====================

//==================Sequence Start=======================
class my_sequence extends uvm_sequence #(seq_item);
	`uvm_object_utils(my_sequence)

	function new (string name = "my_sequence");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);

		req = seq_item::type_id::create("req");
		start_item(req);
		if (!req.randomize()) begin
			`uvm_fatal("RAND_FAIL", "Randomization failed!")
		end
		finish_item(req);
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

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			`uvm_info(get_type_name(), "Driver: Got item from sequencer", UVM_LOW);

			// Drive the item onto the interface here

			seq_item_port.item_done();
		end
	endtask
endclass
//==================Driver End=======================

//==================Monitor Start==========================
class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	uvm_analysis_port #(seq_item) ap;

	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ap = new("ap", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		seq_item mon_item;

		forever begin
			mon_item = seq_item::type_id::create("mon_item");

			// Sample the interface into mon_item here

			`uvm_info(get_type_name(), "Monitor: Observed item", UVM_LOW);
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

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		imp = new("imp", this);
	endfunction

	// Called automatically whenever monitor's ap.write() fires
	virtual function void write(seq_item t);
		`uvm_info(get_type_name(), "Scoreboard: Received item from monitor", UVM_LOW);

		// Add checking / comparison logic here
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

	env      e;
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
		seq.start(e.agt.seqr);

		phase.drop_objection(this);
	endtask
endclass
//==================Test End=======================


