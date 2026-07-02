`include "uvm_macros.svh"
import uvm_pkg::*;

class phase_ex extends uvm_component;

	`uvm_component_utils(phase_ex)

	function new(string name = "phase_ex", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "1. Build phase Exicuted", UVM_LOW);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_type_name(), "2.Connect phase exicuted", UVM_LOW);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info(get_type_name(), "3.end of elaboration phase exicuted", UVM_LOW);
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		`uvm_info(get_type_name(), "4.Start of simulation phase exicuted", UVM_LOW);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(), "5.run phase exicuted", UVM_LOW);
	endtask

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		`uvm_info(get_type_name(), "6.Extract phase exicuted", UVM_LOW);
	endfunction

	function void check_phase(uvm_phase phase);
		super.check_phase(phase);
		`uvm_info(get_type_name(), "7.Check phase exicuted", UVM_LOW);
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "8. Reporth phase exicuted", UVM_LOW);
	endfunction

	function void final_phase(uvm_phase phase);
		super.final_phase(phase);
		`uvm_info(get_type_name(), "9. Final phase exicuted", UVM_LOW);
	endfunction


endclass


module uvm_phase_ex_TB;
	//phase_ex p;

	initial begin
		//p = phases::type_id::create("p");

		run_test("phase_ex");
	end
endmodule
