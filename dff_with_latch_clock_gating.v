
//===========================================================
// Project      : D Flip-Flop with Latch-Based Clock Gating		      =
// Author       : Tran Nhat Hai					      =
// Description  : Implements a D flip-flop using latch-based		      =	
//                clock gating for power optimization.			      =
//===========================================================

module dff_with_latch_clock_gating (
    input  logic clk,       // Global clock
    input  logic en,        // Clock enable
    input  logic d,         // Data input
    output logic q          // Output
);

    logic en_latched;
    logic gated_clk;

    // Latch the enable signal when clk is low
    always_comb begin
        if (clk)
            en_latched <= en;
    end

    // Generate gated clock
    assign gated_clk = clk & en_latched;

    // Flip-flop triggered by gated clock
    always_ff @(posedge gated_clk) begin
        q <= d;
    end

endmodule

