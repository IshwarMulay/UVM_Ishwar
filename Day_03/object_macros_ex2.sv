`include "uvm_macros.svh"
import uvm_pkg::*;

class my_obj extends uvm_object;

	typedef enum bit [1:0] {s0, s1, s2, s3} state_type;

	rand state_type state;
	real temp = 2.32;
	string str = "CDAC";
	
	function new(string name = "my_obj");
		super.new(name);
	endfunction

	
	`uvm_object_utils_begin(my_obj)

		`uvm_field_enum (state_type,state, UVM_DEFAULT)
		`uvm_field_string (str, UVM_DEFAULT)
  		`uvm_field_real (temp, UVM_DEFAULT)
				
	`uvm_object_utils_end

endclass

module tb;
	my_obj m;

	initial begin
		m = my_obj::type_id::create("m");

		if (!m.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		m.print(uvm_default_table_printer);
		m.print();
	end

endmodule
