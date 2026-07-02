`include "uvm_macros.svh"
import uvm_pkg::*;

class my_obj extends uvm_object;
	`uvm_object_utils(my_obj)

	function new(string name = "my_obj");
		super.new(name);
	endfunction

	bit [3:0] a = 4;

	virtual function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("a", a, $bits(a), UVM_HEX);
	endfunction

endclass

module do_print_tb;
	my_obj obj;

	initial begin
		obj = my_obj::type_id::create("obj");

		obj.print();
	end
endmodule
