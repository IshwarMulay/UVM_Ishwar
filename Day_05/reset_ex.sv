`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
	`uvm_component_utils(comp)

	function new(string name = "comp", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	task reset_phase(uvm_phase phase);
		phase.raise_objection(this);

		`uvm_info("comp", "Reset started", UVM_NONE);
		#10;
		`uvm_info("comp", "Reset completed", UVM_NONE);

		phase.drop_objection(this);
	endtask
endclass

module reset_TB;
	
	initial begin
		run_test("comp");
	end

endmodule

