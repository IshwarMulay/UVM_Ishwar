module adder(input logic [3:0] a, b,
             output logic [4:0] sum);
  assign sum = a + b;
endmodule

interface adder_if;
  logic [3:0] a, b;
  logic [4:0] sum;
endinterface

class transaction;
 rand bit [3:0] a, b;
 bit [4:0] sum;
endclass

class generator;
  transaction tr;

  function transaction generate_1();
    tr = new();
    tr.randomize();   // automatic test generation
    return tr;
  endfunction
endclass

class driver;
  virtual adder_if vif;

  function new(virtual adder_if vif);
    this.vif = vif;
  endfunction

  task drive(transaction tr);
    vif.a = tr.a;
    vif.b = tr.b;
    #10;
  endtask
endclass

class monitor;
  virtual adder_if vif;

  function new(virtual adder_if vif);
    this.vif = vif;
  endfunction

  function transaction collect();
    transaction tr = new();
    tr.a = vif.a;
    tr.b = vif.b;
    tr.sum = vif.sum;
    return tr;
  endfunction
endclass

class scoreboard;

  function void check(transaction tr);
    if (tr.sum != (tr.a + tr.b))
      $display("ERROR: %0d + %0d != %0d", tr.a, tr.b, tr.sum);
    else
      $display("PASS: %0d + %0d = %0d", tr.a, tr.b, tr.sum);
  endfunction

endclass

module adder_tb;

  adder_if vif();
//DUT Instance 
  adder dut(.a(vif.a), .b(vif.b), .sum(vif.sum));
// components 
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sb;

  initial begin
    gen = new();
    drv = new(vif);
    mon = new(vif);
    sb  = new();

    repeat (5) begin
      transaction tr;

      tr = gen.generate_1();   // generate stimulus 
      drv.drive(tr);         // apply- drives to DUT
      tr = mon.collect();    // observe- monitor output 
      sb.check(tr);          // verify-  checks results
    end

    $finish;
  end

endmodule