`include "uvm_macros.svh"
import uvm_pkg::*;

class my_obj extends uvm_object;
	
	function new(string name = "my_obj");
		super.new(name);
	endfunction

	rand bit [3:0] x;
	rand bit [3:0] y;

	`uvm_object_utils_begin(my_obj)
		`uvm_field_int(x, UVM_NOPRINT | UVM_BIN)
		`uvm_field_int(y, UVM_DEFAULT | UVM_DEC)              
	`uvm_object_utils_end

endclass

module tb;
	my_obj m;

	initial begin
		m = my_obj::type_id::create("m");
		repeat(10) begin
		if (!m.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		else
			`uvm_info("Values", $sformatf("X: %0d Y:%0d", m.x, m.y), UVM_LOW);
		end
		

		m.print(uvm_default_table_printer);
	end

endmodule
