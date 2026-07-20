//============================================================
// File: fa_assertions_constraints.sv
// Description:
//   - Full-adder design-under-test (DUT) reference model/module
//   - SystemVerilog assertions (SVA) to verify full-adder correctness
//   - Constraint class to generate (a,b,cin) combinations
//============================================================

`timescale 1ns/1ps

//-------------------------------
// 1) Full adder (reference)
//-------------------------------
module full_adder (
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic sum,
  output logic cout
);

  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

//----------------------------------------------------------------------
// 2) Assertions: bind this module to any FA instance you want to check
//----------------------------------------------------------------------
interface fa_if (input logic clk);
  logic a, b, cin;
  logic sum;
  logic cout;
endinterface

module fa_sva (
  input logic clk,
  input logic a,
  input logic b,
  input logic cin,
  input logic sum,
  input logic cout
);

  // sum must equal XOR of inputs
  property p_sum_correct;
    @(posedge clk) 1'b1 |-> (sum == (a ^ b ^ cin));
  endproperty
  a_sum_correct: assert property (p_sum_correct)
    else $error("FA SUM mismatch: a=%0b b=%0b cin=%0b expected=%0b got=%0b",
                a, b, cin, (a ^ b ^ cin), sum);

  // cout must match majority function
  property p_cout_correct;
    @(posedge clk) 1'b1 |-> (cout == ((a & b) | (b & cin) | (a & cin)));
  endproperty
  a_cout_correct: assert property (p_cout_correct)
    else $error("FA COUT mismatch: a=%0b b=%0b cin=%0b expected=%0b got=%0b",
                a, b, cin, ((a & b) | (b & cin) | (a & cin)), cout);

  // Covers (optional): observe that all input combos occur
  covergroup cg_fa_inputs @(posedge clk);
    coverpoint {a,b,cin};
  endgroup

  cg_fa_inputs cg = new();

endmodule

//-------------------------------------------------------------------------
// 3) Constraint class to generate stimulus combinations of (a,b,cin)
//-------------------------------------------------------------------------
class fa_stim_constraints;
  // rand inputs for a full adder
  rand bit a;
  rand bit b;
  rand bit cin;

  // Optional: bias towards exhaustive patterns or random.
  // As written, this is uniform random over all 8 combinations.
  constraint c_uniform {
    a   dist {0 := 50, 1 := 50};
    b   dist {0 := 50, 1 := 50};
    cin dist {0 := 50, 1 := 50};
  }

  // Optional convenience constraints (uncomment if you need specific cases)
  // constraint c_only_carries { (a+b+cin) >= 1; } // at least one asserted input

endclass

//============================================================
// Optional usage example (commented out):
//
// - Instantiate your FA as: full_adder u_fa(...);
// - Drive a,b,cin each cycle.
// - Instantiate fa_sva with the same signals:
//     fa_sva u_fa_sva(.clk(clk), .a(u_fa.a), .b(u_fa.b), .cin(u_fa.cin),
//                    .sum(u_fa.sum), .cout(u_fa.cout));
//============================================================

