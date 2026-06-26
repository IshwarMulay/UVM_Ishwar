`include "uvm_macros.svh"
import uvm_pkg::*;

class odd_no_gen extends uvm_object;
	
	`uvm_object_utils(odd_no_gen);

	function new(string name = "odd_no_gen");
		super.new(name);
	endfunction

	rand bit [3:0] odd_no;

	constraint e_const {(odd_no%2) != 0; }

endclass

module odd_no_TB;
	
	odd_no_gen o;
	
	initial begin
		o = odd_no_gen::type_id::create("o");
		repeat(10) begin
			if(!o.randomize())begin
				$sformatf("Randomization Faild");	
			end
			else
				`uvm_info(o.get_name(), $sformatf("Odd no: %0d",o.odd_no), UVM_LOW);
		end

	end	

endmodule
