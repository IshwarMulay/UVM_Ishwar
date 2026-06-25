`include "uvm_macros.svh"
import uvm_pkg::*;


module tb;
    initial begin
        $display("Hello world  : $display @ %t", $time);
        `uvm_info("TB_TOP", "Hello World", UVM_MEDIUM); //id, msg, verbosity
    end
endmodule