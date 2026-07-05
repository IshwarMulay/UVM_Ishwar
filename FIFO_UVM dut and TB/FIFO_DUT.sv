`timescale 1ns/1ps

//================ Interface =================
interface fifo_if(input logic Clk);
  logic Rst;
  logic EN;
  logic RD;
  logic WR;
  logic [31:0] dataIn;
  logic [31:0] dataOut;
  logic EMPTY;
  logic FULL;
endinterface


//================ DUT =================
module FIFObuffer #(
  parameter int DEPTH = 8,
  parameter int DW = 32
)(
  input logic Clk,
  input logic Rst,
  input logic EN,
  input logic RD,
  input logic WR,
  input logic [DW-1:0] dataIn,
  output logic [DW-1:0] dataOut,
  output logic EMPTY,
  output logic FULL
);

  localparam int PTR_W = $clog2(DEPTH);

  logic [DW-1:0]    FIFO [0:DEPTH-1];
  logic [PTR_W-1:0] readPtr, writePtr;
  logic [PTR_W:0]   Count;

  assign EMPTY = (Count == 0);
  assign FULL = (Count == DEPTH);

  always_ff @(posedge Clk) begin
    if (Rst) begin
      readPtr <= '0;
      writePtr <= '0;
      Count <= '0;
      dataOut <= '0;
    end
    else if (EN) begin

      if (WR && !FULL) begin
        FIFO[writePtr] <= dataIn;
        writePtr <= writePtr + 1'b1;
      end

      if (RD && !EMPTY) begin
        dataOut <= FIFO[readPtr];
        readPtr <= readPtr + 1'b1;
      end

      case ({WR && !FULL, RD && !EMPTY})
        2'b10: Count <= Count + 1;
        2'b01: Count <= Count - 1;
        2'b11: Count <= Count;
        default: Count <= Count;
      endcase
    end
  end

endmodule