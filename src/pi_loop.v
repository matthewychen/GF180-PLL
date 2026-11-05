`timescale 1ns/1ps
`default_nettype none

// pi-loop filter, turns PFD's 1 bit EARLY input to a 6-bit DAC code
// clamped to 0..63.
module pi_filter (
    input  wire clk,   // 10 MHz reference
    input  wire rst_n, // active-low reset
    input  wire early, // from PFD: 1 = VCO too fast, 0 = too slow
    input  wire [1:0] kp_sel, // ui_in[5:4]: Kp = 1, 2, 4, 8 codes
    input  wire [1:0] ki_sel, // ui_in[7:6]: Ki = 1/64, 1/32, 1/16, 1/8 code
    output reg  [5:0] code,   // output 6 bit digital to DAC, unsigned, bit 5 = MSB
    output wire [5:0] integ   // integrator top 6 bits, for lock detector
);

    // Integrator: 12 bits = 6 whole-code bits + 6 fraction bits
    localparam [11:0] MID  = 12'd2048; 
    localparam [11:0] IMAX = 12'd4095; 

    reg  [11:0] acc;        // integrator register
    reg  [11:0] acc_next;   // integrator value for next cycle
    reg  [6:0]  sum;        // 7 bits so overflow above 63 is visible
    reg  [5:0]  code_next;  // output code for next cycle

    wire [11:0] ki_step = 12'd1 << ki_sel;  // 1, 2, 4, 8 sixty-fourths of a code
    wire [5:0]  kp_step = 6'd1  << kp_sel;  // 1, 2, 4, 8 codes

    // Integral path: step down if early, up if late, stop at the ends
    always @(*) begin
        if (early)
            acc_next = (acc >= ki_step) ? acc - ki_step : 12'd0;
        else
            acc_next = (acc <= IMAX - ki_step) ? acc + ki_step : IMAX;
    end

    // Proportional path: kick the whole-code part by Kp, clamp to +-0.63
    always @(*) begin
        if (early) begin
            sum = 7'd0;
            code_next = (acc_next[11:6] >= kp_step) ? acc_next[11:6] - kp_step : 6'd0;
        end else begin
            sum = {1'b0, acc_next[11:6]} + {1'b0, kp_step};
            code_next = sum[6] ? 6'd63 : sum[5:0];
        end
    end

    // NEED TO ASSIGN OUTPUT WITH APPROPRIATE 6 BIT NUMBER ACCORDING TO INTEGRATOR VALUE AND PROPORTIONAL VALUE

endmodule

`default_nettype wire