import uvm_pkg ::*;
`include "uvm_macros.svh"

module same_msg;
	int i;
	initial begin
	for(i=0; i<6; i++)
		`uvm_info($sformatf("SAME MESSAGE");
	end
endmodule
