`include "uvm_macros.svh"
import uvm_pkg::*;

//---------Interface----------
interface xor_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [3:0] c;
    logic [3:0] y;
endinterface


//---------XOR--------------
module xor_gate(
    input  logic [3:0] a, 
    input  logic [3:0] b,
    input  logic [3:0] c,
    output logic [3:0] y
);
    assign y = a ^ b ^ c;
endmodule


//----------TB Environment------------

// Driver
class driver extends uvm_driver;
    `uvm_component_utils(driver)
    virtual xor_if xif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual xor_if)::get(this, "", "xif", xif))
            `uvm_error("driver", "Unable to access Interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this); 
        for(int i=0; i<10; i++) begin
            xif.a = $urandom;
            xif.b = $urandom;
	    xif.c = $urandom;
            #10;
        end
        phase.drop_objection(this);
    endtask
endclass

// Agent
class agent extends uvm_agent;
    `uvm_component_utils(agent) 

    driver d;

    function new(string name = "agent", uvm_component parent = null); 
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Fixed typo 'buld_phase'
        d = driver::type_id::create("d", this);
    endfunction
endclass

// Environment
class env extends uvm_env;
    `uvm_component_utils(env)

    agent a;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        a = agent::type_id::create("a", this);
    endfunction
endclass

// Test
class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        e = env::type_id::create("e", this); 
    endfunction
endclass


// Top Module
module xor_TB;
    xor_if xif();

    xor_gate DUT (
        .a(xif.a), 
        .b(xif.b),
        .c(xif.c),	
        .y(xif.y)
    );

    initial begin
        // Using "uvm_test_top.*" safely matches the actual hierarchy ("uvm_test_top.e.a.d")
        uvm_config_db #(virtual xor_if)::set(null, "uvm_test_top.*", "xif", xif);
        run_test("test");
    end
endmodule
