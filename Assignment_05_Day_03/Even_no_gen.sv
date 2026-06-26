`include "uvm_macros.svh"
import uvm_pkg::*;

class even_no_gen extends uvm_object;
	
	`uvm_object_utils(even_no_gen);

	function new(string name = "even_no_gen");
		super.new(name);
	endfunction

	rand bit [3:0] even_no;

	//constraint e_const {even_no inside {2, 4, 6, 8, 10, 12, 14};}
	constraint e_const {(even_no%2) == 0; }

endclass

module even_no_TB;
	
	even_no_gen e;
	
	initial begin
		e = even_no_gen::type_id::create("e");
		repeat(10) begin
			if(!e.randomize())begin
				$sformatf("Randomization Faild");	
			end
			else
				`uvm_info(e.get_name(), $sformatf("Even no: %0d",e.even_no), UVM_LOW);
		end

	end	

endmodule
