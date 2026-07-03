`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
	rand bit [3:0] value1;
	rand bit [3:0] value2;

	`uvm_object_utils(seq_item)

	function new(string name = "seq_item");
		super.new(name);
	endfunction
endclass

class producer extends uvm_component;
	uvm_put_port#(seq_item) tlm_put;
	seq_item req;

	`uvm_component_utils(producer)

	function new(string name = "producer", uvm_component parent = null);
		super.new(name, parent);
		tlm_put = new("tlm_put", this);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		req = seq_item::type_id::create("req");

		if(!req.randomize()) begin
			`uvm_info(get_type_name(), $sformatf("Randomization Failed.."), UVM_LOW);
		end
		else begin
			`uvm_info(get_type_name(), $sformatf("Send Values:: Value1= %0d | value2: %0d", req.value1, req.value2), UVM_LOW);
		end
		tlm_put.put(req);

		assert(req.randomize());
    		`uvm_info(get_type_name(), $sformatf("For try_put: Send values:: Value1= %0d | value2= %0d", req.value1, req.value2), UVM_NONE);
   		 tlm_put.try_put(req);
   		 tlm_put.can_put();
	endtask

endclass


class consumer extends uvm_component;
	uvm_put_imp #(seq_item, consumer) tlm_imp;

	`uvm_component_utils(consumer);

	function new(string name = "consumer", uvm_component parent = null);
		super.new(name, parent);
		tlm_imp = new("tlm_imp", this);
	endfunction

	task put(seq_item trans);
		`uvm_info(get_type_name(), $sformatf("Received Values:: Value1= %0d | Value2= %0d", trans.value1, trans.value2), UVM_LOW);
	endtask

	virtual function bit try_put(seq_item trans);
    		`uvm_info(get_type_name(), $sformatf("Received try_put Values:: Value1= %0d | Value2= %0d", trans.value1, trans.value2), UVM_LOW);
   	 	return 1;
 	 endfunction
  
  	virtual function bit can_put();
    		`uvm_info(get_type_name(), "inside can_put", UVM_NONE);
   		 return 1;
  	endfunction
endclass


class env extends uvm_env;
	`uvm_component_utils(env)

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	producer p;
	consumer c;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		p = producer::type_id::create("p",this);
		c = consumer::type_id::create("c",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		p.tlm_put.connect(c.tlm_imp);
	endfunction

endclass

class test extends uvm_test;

	env e;

	`uvm_component_utils(test);

	function new(string name = "test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		e = env::type_id::create("e", this);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		#50;
		phase.drop_objection(this);
	endtask
endclass

module tb_top;
	initial begin
		run_test("test");
	end
endmodule

