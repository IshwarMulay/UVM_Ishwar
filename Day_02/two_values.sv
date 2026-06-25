import uvm_pkg::*;
`include "uvm_macros.svh"

module test;
	int a = 5;
	int b = 7;

	initial begin
		`uvm_info("VALUES", $sformatf("a = %0d | b = %0d",a,b),UVM_LOW)
	end
endmodule

