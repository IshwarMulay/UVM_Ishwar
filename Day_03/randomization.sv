`include "uvm_macros.svh"
import uvm_pkg::*;

class randomize_class;
	rand bit [7:0] a;
	rand bit [7:0] b;
endclass

module Random_TB;
	
	randomize_class r;

	initial begin
		r = new();
		repeat(10)begin
			if (!r.randomize()) begin
                		`uvm_error("RAND_FAIL", "Randomization failed!");
			end
			else
			`uvm_info("Values", $sformatf("A: %0d | B: %0d",r.a, r.b),UVM_MEDIUM);
		end
	end

endmodule

