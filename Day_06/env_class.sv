`include "uvm_macros.svh"
import uvm_pkg::*;

//--------- Producer ----------
class producer extends uvm_component;
    `uvm_component_utils(producer)

    int data = 12;
    uvm_blocking_put_port #(int) send;

    function new (input string path = "producer", uvm_component parent = null);
        super.new(path, parent);
        send = new("send", this);
    endfunction

    // Added run_phase to actually send the data
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("PRODUCER", $sformatf("Sending data: %0d", data), UVM_LOW)
        send.put(data); // TLM put call
        phase.drop_objection(this);
    endtask
endclass : producer


//--------- Consumer ----------
class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    uvm_blocking_put_export #(int) receive;
    uvm_blocking_put_imp #(int, consumer) imp;

    function new (input string path = "consumer", uvm_component parent = null); // Fixed typo 'uvm_componet'
        super.new(path, parent);
        receive = new("receive", this);
        imp = new("imp" , this);
    endfunction

    // FIXED: Internal connection from export to IMP
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        receive.connect(imp); 
    endfunction

    // FIXED: Mandatory task required by uvm_blocking_put_imp
    virtual task put(int t);
        `uvm_info("CONSUMER", $sformatf("Received data: %0d", t), UVM_LOW)
    endtask
endclass


//--------- Environment ----------
class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer c;

    function new(input string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);
        c = consumer::type_id::create("c", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.send.connect(c.receive); // Connects Port to Export
    endfunction
endclass : env


//--------- Test ----------
class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(input string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    // FIXED: Added build_phase to instantiate the environment
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction
endclass: test


//--------- Top module ----------
module tb;
    initial begin
        run_test("test");
    end
endmodule
