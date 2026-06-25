import uvm_pkg ::*;
`include "uvm_macros.svh"

module print_value;
	int i;
	int a;
	initial begin
	for(i=0; i<11; i++)
		`uvm_info("VALUES",$sformatf("Value :%0d",i),UVM_LOW);
	end
endmodule
