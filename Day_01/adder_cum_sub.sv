module adder_subtractor(
    input logic [3:0] a, b,
    input logic ctrl, // 0 = add, 1 = subtract
    output logic [4:0] result
);

    assign result = ctrl ? ({1'b0,a} - {1'b0,b}) :
                           ({1'b0,a} + {1'b0,b});

endmodule


interface adder_if;
    logic [3:0] a, b;
    logic ctrl;
    logic [4:0] result;
endinterface


class transaction;
    rand bit [3:0] a, b;
    rand bit ctrl;
    bit [4:0] result;
endclass


class generator;

    function transaction generate_1();
        transaction tr;
        tr = new();

        if(!tr.randomize())
            $fatal("Randomization failed");

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
        vif.ctrl = tr.ctrl;
        #10;
    endtask

endclass


class monitor;
    virtual adder_if vif;

    function new(virtual adder_if vif);
        this.vif = vif;
    endfunction

    function transaction collect();
        transaction tr;
        tr = new();

        tr.a = vif.a;
        tr.b = vif.b;
        tr.ctrl = vif.ctrl;
        tr.result = vif.result;

        return tr;
    endfunction

endclass


class scoreboard;

    function void check(transaction tr);
        logic [4:0] expected;

        if(tr.ctrl == 0)
            expected = {1'b0,tr.a} + {1'b0,tr.b};
        else
            expected = {1'b0,tr.a} - {1'b0,tr.b};

        if(tr.result == expected) begin
            if(tr.ctrl == 0)
                $display("PASS: a=%0d b=%0d ADD result=%0d", 
                          tr.a, tr.b, tr.result);
            else
                $display("PASS: a=%0d b=%0d SUB result=%0d", 
                          tr.a, tr.b, tr.result);
        end
        else begin
            $display("ERROR: a=%0d b=%0d ctrl=%0d expected=%0d got=%0d",
                     tr.a, tr.b, tr.ctrl, expected, tr.result);
        end
    endfunction

endclass


module tb;

    adder_if vif();

    adder_subtractor dut(
        .a (vif.a),
        .b (vif.b),
        .ctrl (vif.ctrl),
        .result (vif.result)
    );

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sb;

    task apply_case(input bit [3:0] a,
                input bit [3:0] b,
                input bit ctrl);
    transaction tr;

    tr = new();
    tr.a = a;
    tr.b = b;
    tr.ctrl = ctrl;

    drv.drive(tr);

    tr = mon.collect();
    sb.check(tr);
    endtask


    initial begin
    gen = new();
    drv = new(vif);
    mon = new(vif);
    sb = new();

    // -------------------------
    // Addition corner cases
    // ctrl = 0
    // -------------------------
    $display(" Addition corner cases");

    apply_case(4'd0, 4'd0, 1'b0); // 0 + 0
    apply_case(4'd15, 4'd0, 1'b0); // max + 0
    apply_case(4'd0, 4'd15, 1'b0); // 0 + max
    apply_case(4'd15, 4'd15, 1'b0); // max + max = 30
    apply_case(4'd8, 4'd7, 1'b0); // mid values
    apply_case(4'd1, 4'd14, 1'b0); // carry case

    // -------------------------
    // Subtraction corner cases
    // ctrl = 1
    // -------------------------
    $display(" Subtraction corner cases");

    apply_case(4'd0, 4'd0, 1'b1); // 0 - 0
    apply_case(4'd15, 4'd0, 1'b1); // max - 0
    apply_case(4'd0, 4'd15, 1'b1); // 0 - max
    apply_case(4'd15, 4'd15, 1'b1); // max - max
    apply_case(4'd8, 4'd7, 1'b1); // positive subtraction
    apply_case(4'd7, 4'd8, 1'b1); // negative subtraction

    // Random testing
    $display(" Random corner cases");

    repeat(20) begin
        transaction tr;

        tr = gen.generate_1();
        drv.drive(tr);

        tr = mon.collect();
        sb.check(tr);
    end

    $finish;
  end
endmodule
