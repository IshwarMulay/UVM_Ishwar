`include "uvm_macros.svh"
import uvm_pkg::*;

class Factory_ex extends uvm_object;

    // Factory registration
    `uvm_object_utils(Factory_ex)

    function new (string name = "Factory_ex");
        super.new(name);
    endfunction

    rand bit [7:0] a;

endclass

module uvm_factory_ex();
    Factory_ex f;

    initial begin
        // CORRECT WAY: Allocate object using the UVM factory
        f = Factory_ex::type_id::create("f");
        
        repeat(10) begin
            if (!f.randomize()) begin
                `uvm_error("RAND_FAIL", "Randomization failed")
            end
            
            // Using f.get_name() will now return "f" instead of the hardcoded string
            `uvm_info(f.get_name(), $sformatf("A: %0d", f.a), UVM_LOW)
        end
    end
endmodule
