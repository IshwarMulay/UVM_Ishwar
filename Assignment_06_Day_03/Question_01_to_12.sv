`include "uvm_macros.svh"
import uvm_pkg::*;

class my_obj extends uvm_object;
	
	function new(string name = "my_obj");
		super.new(name);
	endfunction

	rand bit [3:0] x;
	rand bit [3:0] y;

	rand bit [3:0] a;
	rand bit [3:0] b;


	`uvm_object_utils_begin(my_obj)
		//Question 1
		//`uvm_field_int(x, UVM_NOPRINT | UVM_BIN)
		//`uvm_field_int(y, UVM_DEFAULT | UVM_DEC)
		
		//Question 2
		//`uvm_field_int(x, UVM_BIN)
		//`uvm_field_int(y, UVM_DEFAULT | UVM_DEC)
		
		//Question 3
		//`uvm_field_int(a, UVM_BIN)
		//`uvm_field_int(b, UVM_BIN)

		//Question 4
		//`uvm_field_int(a, UVM_DEC)
		//`uvm_field_int(b, UVM_DEC)

		//Question 5
		//`uvm_field_int(a, UVM_HEX)
		//`uvm_field_int(b, UVM_HEX)
		
		//Question 6
		//`uvm_field_int(a, UVM_BIN)
		//`uvm_field_int(b, UVM_HEX)
		
				
	`uvm_object_utils_end

endclass

module tb;
	my_obj m;
	my_obj m1;
	my_obj m2;

	initial begin
		m = my_obj::type_id::create("m");
		m1 = my_obj::type_id::create("m1");
		m2 = my_obj::type_id::create("m2");


		repeat(5) begin
		if (!m.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		else
			`uvm_info("Values", $sformatf("X: %0d Y:%0d A: %0d B: %0d", m.x, m.y, m.a, m.b), UVM_LOW);
		end

		repeat(5) begin
		if (!m1.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		else
			`uvm_info("Values", $sformatf("X: %0d Y:%0d A: %0d B: %0d", m1.x, m1.y, m1.a, m1.b), UVM_LOW);
		end
		
		repeat(5) begin
		if (!m2.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization failed")
		end
		else
			`uvm_info("Values", $sformatf("X: %0d Y:%0d A: %0d B: %0d", m2.x, m2.y, m2.a, m2.b), UVM_LOW);
		end

		
		m.print();
		m1.print();
		m2.print();
		//Question 8
		//m.print(uvm_default_table_printer);
		//m.print(uvm_default_tree_printer);
		//m.print(uvm_default_line_printer);
	end

endmodule
