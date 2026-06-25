import uvm_pkg::*;
`include "uvm_macros.svh"

module pos_num;
	int num = -10;
	initial begin
		if(num > 0) begin
			`uvm_info("VALUES", $sformatf("%0d is positive",num), UVM_LOW);
		end
		else begin
			`uvm_info("VALUES", $sformatf("%0d is negative",num), UVM_LOW);
		end

	end
endmodule

