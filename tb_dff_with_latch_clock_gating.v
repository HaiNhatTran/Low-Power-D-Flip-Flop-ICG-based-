
//===========================================================
// Project      : D Flip-Flop with Latch-Based Clock Gating		      =
// Author       : Tran Nhat Hai					      =
// Description  : Implements a D flip-flop using latch-based		      =	
//                clock gating for power optimization.			      =
//===========================================================


`timescale 1ns/1ps

module tb_dff_with_latch_clock_gating;

    // Testbench signals
    logic clk;
    logic en;
    logic d;
    logic q;
    logic q_prev;

    // DUT instantiation
    dff_with_latch_clock_gating dut (
        .clk(clk),
        .en(en),
        .d(d),
        .q(q)
    );

    // Clock generation (10ns period = 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Display header
    initial begin
        $display("===============================================================");
        $display("| Time(ns) | clk | en |  d |  q | Event                     |");
        $display("===============================================================");
    end
    
     string event_str;

    // Monitor changes
    always @(posedge clk) begin
       
        if (en) begin
            if (q !== q_prev)
                event_str = "✔️  Q updated (clock gated ON)";
            else
                event_str = "⚠️  No change (D same)";
        end else begin
            if (q !== q_prev)
                event_str = "❌ ERROR: Q changed with en=0!";
            else
                event_str = "🔒 Q held (clock gated OFF)";
        end
        $display("| %8t |  %0b  | %0b  | %0b | %0b | %s", $time, clk, en, d, q, event_str);
        q_prev = q;
    end

    // Stimulus
    initial begin
        en = 0;
        d  = 0;
        q_prev = 0;

        #12;       // Wait a bit before starting

        // Case 1: Enable = 1, D changes => Q should follow D
        en = 1; d = 1;
        #10;
        d = 0;
        #10;
        d = 1;
        #10;

        // Case 2: Disable enable => Q should hold
        en = 0;
        d  = 0;
        #20;

        // Case 3: Re-enable
        en = 1;
        d  = 1;
        #10;
        d = 0;
        #10;

        $display("===============================================================");
        $finish;
    end

    // Dump waveform
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_dff_with_latch_clock_gating);
    end

endmodule

