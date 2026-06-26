`include "uvm_macros.svh"
import uvm_pkg::*;

class parent extends uvm_object;
	
	function new(string name = "parent");
		super.new(name);
	endfunction

	rand bit [3:0] data;

	
	`uvm_object_utils_begin(parent)
		`uvm_field_int(data, UVM_DEFAULT)			
	`uvm_object_utils_end

endclass

class child extends uvm_object;

	parent p;
	
	function new(string name = "child");
		super.new(name);
		p = new("parent");
	endfunction

	`uvm_object_utils_begin(child)
		`uvm_field_object(p, UVM_DEFAULT)			
	`uvm_object_utils_end

endclass


module tb_ex3;
	child c;

	initial begin
		c = child::type_id::create("c");

		if (!c.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		//c.print(uvm_default_table_printer);
		c.print();
	end

endmodule
