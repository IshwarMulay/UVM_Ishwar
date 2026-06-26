`include "uvm_macros.svh"
import uvm_pkg::*;

class range extends uvm_object;

	`uvm_object_utils(range)

	function new (string name = "range");
		super.new(name);
	endfunction

	rand bit [3:0] num;

	constraint num_const {num inside {[5:10]}; }

endclass

module range_TB;

	range r;

	initial begin
		r = range::type_id::create("r");
		
		repeat(10) begin
		if(!r.randomize()) begin
			`uvm_error("RAND_FAIL", "Randomization Failed")		
		end
		else
			`uvm_info(r.get_name(), $sformatf("Num: %0d", r.num), UVM_LOW)
		end
	end
endmodule

