`include "uvm_macros.svh"
import uvm_pkg::*;

class d extends uvm_component;
    `uvm_component_utils(d);
    function new(string path="d",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"CLass d executed",UVM_LOW);
    endfunction

endclass :d

class g extends uvm_component;
    `uvm_component_utils(g);
    function new(string path="g",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"CLass g executed",UVM_LOW);
    endfunction

endclass :g

class h extends uvm_component;
    `uvm_component_utils(h);
    function new(string path="h",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"CLass h executed",UVM_LOW);
    endfunction

endclass :h

class k extends uvm_component;
    `uvm_component_utils(k);
    function new(string path="k",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"CLass k executed",UVM_LOW);
    endfunction

endclass :k

class l extends uvm_component;
    `uvm_component_utils(l);
    function new(string path="l",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"CLass l executed",UVM_LOW);
    endfunction

endclass :l 

class n extends uvm_component;
  `uvm_component_utils(n);
  function new(string path="n",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      `uvm_info(get_type_name(),"CLass n executed",UVM_LOW);
    endfunction

endclass :n

class c extends uvm_component;
    `uvm_component_utils(c);
    d dobj;

    function new(string path="c",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        dobj=d::type_id::create("d",this);

        `uvm_info(get_type_name(),"CLass c executed",UVM_LOW);
    endfunction

endclass :c

class f extends uvm_component;
    `uvm_component_utils(f);
    g gobj;
    h hobj;

    function new(string path="f",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gobj=g::type_id::create("g",this);
        hobj=h::type_id::create("h",this);
        `uvm_info(get_type_name(),"CLass f executed",UVM_LOW);
    endfunction

endclass :f 

class j extends uvm_component;
    `uvm_component_utils(j);
    k kobj;
    l lobj;

    function new(string path="j",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        kobj=k::type_id::create("k",this);
        lobj=l::type_id::create("l",this);
        `uvm_info(get_type_name(),"CLass j executed",UVM_LOW);
    endfunction

endclass :j 

class m extends uvm_component;
    `uvm_component_utils(m);
    n nobj;

    function new(string path="m",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        nobj=n::type_id::create("n",this);
        `uvm_info(get_type_name(),"CLass m executed",UVM_LOW);
    endfunction

endclass :m

class b extends uvm_component;
    `uvm_component_utils(b);
    c cobj;


    function new(string path="b",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cobj=c::type_id::create("c",this);
        `uvm_info(get_type_name(),"CLass b executed",UVM_LOW);
    endfunction

endclass :b 

class a extends uvm_component;
    `uvm_component_utils(a);
    b bobj;
    function new(string path="a",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            bobj=b::type_id::create("b",this);
        `uvm_info(get_type_name(),"CLass a executed",UVM_LOW);
    endfunction

endclass :a

class e extends uvm_component;
    `uvm_component_utils(e);
    f fobj;
    j jobj;

    function new(string path="e",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fobj=f::type_id::create("f",this);
        jobj=j::type_id::create("j",this);
        `uvm_info(get_type_name(),"CLass e executed",UVM_LOW);
    endfunction

endclass :e 

class x extends uvm_component;
    `uvm_component_utils(x);
    a aobj;
    e eobj;
    m mobj;

    function new(string path="x",uvm_component parent=null);
      super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aobj=a::type_id::create("a",this);
        eobj=e::type_id::create("e",this);
        mobj=m::type_id::create("m",this);
        `uvm_info(get_type_name(),"CLass x executed",UVM_LOW);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass :x 


module tb;
    initial begin
        run_test("x");
    end
endmodule


