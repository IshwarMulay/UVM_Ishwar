`include "uvm_macros.svh"
import uvm_pkg::*;


//================ Sequence Item =================
class seq_item extends uvm_sequence_item;

  rand bit EN;
  rand bit RD;
  rand bit WR;
       bit Rst;
  rand bit [31:0] dataIn;

  bit [31:0] dataOut;
  bit EMPTY;
  bit FULL;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(EN, UVM_ALL_ON)
    `uvm_field_int(RD, UVM_ALL_ON)
    `uvm_field_int(WR, UVM_ALL_ON)
    `uvm_field_int(Rst, UVM_ALL_ON)
    `uvm_field_int(dataIn, UVM_ALL_ON)
    `uvm_field_int(dataOut, UVM_ALL_ON)
    `uvm_field_int(EMPTY, UVM_ALL_ON)
    `uvm_field_int(FULL, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "seq_item");
    super.new(name);
  endfunction

endclass


//================ Sequence =================
class my_sequence extends uvm_sequence #(seq_item);

  `uvm_object_utils(my_sequence)

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task body();
    seq_item item;

    // Reset for 3 clocks
    repeat (3) begin
      item = seq_item::type_id::create("reset_item");
      start_item(item);
      item.Rst = 1;
      item.EN = 0;
      item.RD = 0;
      item.WR = 0;
      item.dataIn = 0;
      finish_item(item);
    end

    // Deassert reset
    item = seq_item::type_id::create("idle_item");
    start_item(item);
    item.Rst = 0;
    item.EN = 0;
    item.RD = 0;
    item.WR = 0;
    item.dataIn = 0;
    finish_item(item);

    // Write 4 values
    repeat (4) begin
      item = seq_item::type_id::create("write_item");
      start_item(item);
      item.Rst = 0;
      item.EN = 1;
      item.WR = 1;
      item.RD = 0;
      item.dataIn = $urandom_range(1, 100);
      finish_item(item);
    end

    // Read 4 values
    repeat (4) begin
      item = seq_item::type_id::create("read_item");
      start_item(item);
      item.Rst = 0;
      item.EN = 1;
      item.WR = 0;
      item.RD = 1;
      item.dataIn = 0;
      finish_item(item);
    end

    // Random testing
    repeat (50) begin
      item = seq_item::type_id::create("random_item");
      start_item(item);
      item.Rst = 0;
      assert(item.randomize() with {
        EN dist {1 := 8, 0 := 2};
        WR dist {1 := 5, 0 := 5};
        RD dist {1 := 5, 0 := 5};
      });
      finish_item(item);
    end
  endtask

endclass


//================ Sequencer =================
class my_sequencer extends uvm_sequencer #(seq_item);

  `uvm_component_utils(my_sequencer)

  function new(string name = "my_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass


//================ Driver =================
class driver extends uvm_driver #(seq_item);

  virtual fifo_if vif;

  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    seq_item item;

    vif.Rst <= 1;
    vif.EN <= 0;
    vif.RD <= 0;
    vif.WR <= 0;
    vif.dataIn <= 0;

    forever begin
      seq_item_port.get_next_item(item);

      @(negedge vif.Clk);
      vif.Rst <= item.Rst;
      vif.EN <= item.EN;
      vif.RD <= item.RD;
      vif.WR <= item.WR;
      vif.dataIn <= item.dataIn;

      seq_item_port.item_done();
    end
  endtask

endclass


//================ Monitor =================
class monitor extends uvm_monitor;

  virtual fifo_if vif;
  uvm_analysis_port #(seq_item) ap;

  `uvm_component_utils(monitor)

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ap = new("ap", this);

    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    seq_item item;

    forever begin
      @(posedge vif.Clk);
      #1;

      item = seq_item::type_id::create("item");

      item.Rst = vif.Rst;
      item.EN = vif.EN;
      item.RD = vif.RD;
      item.WR = vif.WR;
      item.dataIn = vif.dataIn;
      item.dataOut = vif.dataOut;
      item.EMPTY = vif.EMPTY;
      item.FULL = vif.FULL;

      ap.write(item);
    end
  endtask

endclass


//================ Scoreboard =================
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_analysis_imp #(seq_item, scoreboard) imp;

  bit [31:0] ref_queue[$];
  bit [31:0] expected_data;

  int pass_count;
  int fail_count;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp = new("imp", this);
  endfunction

  function void write(seq_item item);

    bit model_empty;
    bit model_full;
    bit do_write;
    bit do_read;

    if (item.Rst) begin
      ref_queue.delete();

      if (item.EMPTY !== 1) begin
        `uvm_error(get_type_name(), "EMPTY should be 1 during reset")
        fail_count++;
      end

      if (item.FULL !== 0) begin
        `uvm_error(get_type_name(), "FULL should be 0 during reset")
        fail_count++;
      end

      return;
    end

    if (!item.EN)
      return;

    model_empty = (ref_queue.size() == 0);
    model_full = (ref_queue.size() == 8);

    do_write = item.WR && !model_full;
    do_read = item.RD && !model_empty;

    if (do_read) begin
      expected_data = ref_queue.pop_front();

      if (item.dataOut === expected_data) begin
        `uvm_info(get_type_name(),
          $sformatf("PASS: dataOut expected=%0d got=%0d",
                    expected_data, item.dataOut),
          UVM_LOW)
        pass_count++;
      end
      else begin
        `uvm_error(get_type_name(),
          $sformatf("FAIL: dataOut expected=%0d got=%0d",
                    expected_data, item.dataOut))
        fail_count++;
      end
    end

    if (do_write) begin
      ref_queue.push_back(item.dataIn);
    end

    if (item.EMPTY !== (ref_queue.size() == 0)) begin
      `uvm_error(get_type_name(),
        $sformatf("FAIL: EMPTY mismatch model=%0d dut=%0d",
                  (ref_queue.size() == 0), item.EMPTY))
      fail_count++;
    end

    if (item.FULL !== (ref_queue.size() == 8)) begin
      `uvm_error(get_type_name(),
        $sformatf("FAIL: FULL mismatch model=%0d dut=%0d",
                  (ref_queue.size() == 8), item.FULL))
      fail_count++;
    end

  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("Scoreboard Summary: PASS=%0d FAIL=%0d",
                pass_count, fail_count),
      UVM_LOW)
  endfunction

endclass


//================ Agent =================
class agent extends uvm_agent;

  my_sequencer sqr;
  driver drv;
  monitor mon;

  `uvm_component_utils(agent)

  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    sqr = my_sequencer::type_id::create("sqr", this);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass


//================ Environment =================
class env extends uvm_env;

  agent agt;
  scoreboard scr;

  `uvm_component_utils(env)

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = agent::type_id::create("agt", this);
    scr = scoreboard::type_id::create("scr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.mon.ap.connect(scr.imp);
  endfunction

endclass


//================ Test =================
class test extends uvm_test;

  env e;
  my_sequence seq;

  `uvm_component_utils(test)

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    e = env::type_id::create("e", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = my_sequence::type_id::create("seq");
    seq.start(e.agt.sqr);

    repeat (5) @(posedge FIFO_TB_Top.clk);

    phase.drop_objection(this);
  endtask

endclass


//================ Top =================
module FIFO_TB_Top;

  bit clk = 0;

  always #5 clk = ~clk;

  fifo_if vif(clk);

  FIFObuffer DUT(
    .Clk (clk),
    .Rst (vif.Rst),
    .EN (vif.EN),
    .RD (vif.RD),
    .WR (vif.WR),
    .dataIn (vif.dataIn),
    .dataOut (vif.dataOut),
    .EMPTY (vif.EMPTY),
    .FULL (vif.FULL)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("test");
  end

endmodule