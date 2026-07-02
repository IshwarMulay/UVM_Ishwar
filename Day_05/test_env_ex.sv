`include "uvm_macros.svh"
import uvm_pkg::*;


//========================================
//Driver
//========================================

class driver extends uvm_driver;
	`uvm_component_utils(driver)

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "class Driver....", UVM_LOW);
	endfunction

	task reset_phase(uvm_phase phase);
		super.reset_phase(phase);
		
		phase.raise_objection(this);
		`uvm_info(get_type_name(), "reset Phase from driver started....", UVM_LOW);
		#100;
		`uvm_info(get_type_name(), "reset phase from driver finished....", UVM_LOW);
		phase.drop_objection(this);
	endtask

	task main_phase(uvm_phase phase);
		super.main_phase(phase);

		phase.raise_objection(this);
		`uvm_info(get_type_name(), "main phase from driver started....", UVM_LOW);
		#100;
		`uvm_info(get_type_name(), "main phase from driver finished....", UVM_LOW);
		phase.drop_objection(this);
	endtask

endclass


//========================================
//Monitor
//========================================
class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "class Monitor....", UVM_LOW);
	endfunction

	task reset_phase(uvm_phase phase);
		super.reset_phase(phase);
		
		phase.raise_objection(this);
		`uvm_info(get_type_name(), "reset Phase from monitor started....", UVM_LOW);
		#300;
		`uvm_info(get_type_name(), "reset phase from monitor finished....", UVM_LOW);
		phase.drop_objection(this);
	endtask

	task main_phase(uvm_phase phase);
		super.main_phase(phase);

		phase.raise_objection(this);
		`uvm_info(get_type_name(), "main phase from monitor started....", UVM_LOW);
		#400;
		`uvm_info(get_type_name(), "main phase from monitor finished....", UVM_LOW);
		phase.drop_objection(this);
	endtask

endclass


//=====================================================
//Environment
//=====================================================

class environment extends uvm_env;
	`uvm_component_utils(environment)
n    n
		driver d;
		monitor m;

	function new(string name = "environment", uvm_component parent = null);
	super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "Class Environment....", UVM_LOW);
		
		d = driver::type_id::create("d", this);
		m = monitor::type_id::create("m", this);
	endfunction


	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);

		uvm_top.print_topology();
	endfunction

endclass


module env_TB;
	initial begin
		run_test("environment");
	end
endmodule
