`include "uvm_macros.svh"
import uvm_pkg::*;

module Enum_severty();
	initial begin
		`uvm_info("TB_TOP_1", "This is informative message", UVM_LOW);
		#10;
		`uvm_warning("TB_TOP_2", "This is warning");
		#10;
		`uvm_error("TB_TOP_3", "This is error");
		#10;
		`uvm_fatal("TB_TOP_4", "This is fatal error, stopping simulation");
		#10;
	end
endmodule
