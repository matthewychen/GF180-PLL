`timescale 1ns/1ps
`default_nettype none

// pi-loop filter, turns PFD's 1 bit EARLY input to a 7-bit DAC code (dac7)
// clamped to 0..127.
// nudge_up / nudge_dn (from freq_acq) on top of the normal PI update, to pull in large frequency errors.
//
// ONE_SIDED_KP = 1: proportional kick only when late (early -> integrator + 0, late -> integrator + Kp),
// so the locked code zigzags over Kp codes instead of 2 x Kp. Equivalent to a half-size symmetric kick
// plus a +Kp/2 offset, which the integrator absorbs by settling Kp/2 codes lower.
// ONE_SIDED_KP = 0: symmetric kick (early -> integrator - Kp, late -> integrator + Kp).
module pi_filter #(
    parameter ONE_SIDED_KP = 1
) (
    input  wire clk,   // 10 MHz reference
    input  wire rst_n, // active-low reset
    input  wire early, // from PFD: 1 = VCO too fast, 0 = too slow
    input  wire [1:0] kp_sel, // ui_in[5:4]: Kp = 1, 2, 4, 8 codes (1 code = ~15.5 mV)
    input  wire [1:0] ki_sel, // ui_in[7:6]: Ki = 1/32, 1/16, 1/8, 1/4 code
    input  wire nudge_up,     // from freq_acq: integrator + 2 codes this cycle
    input  wire nudge_dn,     // from freq_acq: integrator - 2 codes this cycle
    output reg  [6:0] code,   // output 7 bit digital to DAC, unsigned, bit 6 = MSB
    output wire [6:0] integ   // integrator top 7 bits, for lock detector / testbenches
);

    // Integrator: 12 bits = 7 whole-code bits + 5 fraction bits.
    // Same accumulator as the 6-bit version; the code is read one bit lower (acc[11:5]),
    // so each accumulator LSB is the same voltage as before. Constants are in accumulator units.
    localparam [11:0] MID  = 12'd2048;   // code 64 (mid-scale)
    localparam [11:0] IMAX = 12'd4095;
    localparam [11:0] NUDGE = 12'd64;    // two codes (= one old 6-bit code, same MHz)

    reg  [11:0] acc; // integrator register
    reg  [11:0] acc_pi;   // integrator after the normal PI step
    reg  [11:0] acc_next; // integrator value for next cycle (PI step + nudge)
    reg  [7:0]  code_sum; // 8 bits so overflow or underflow shows in bit 7
    reg  [6:0]  code_next; // output code for next cycle

    wire [11:0] ki_step = 12'd1 << ki_sel; // 1, 2, 4, 8 thirty-seconds of a code
    wire [6:0]  kp_step = 7'd1  << kp_sel; // 1, 2, 4, 8 codes

     // Integral path: step down if early, up if late, stop at the ends
    always @(*) begin
        if (early)
            acc_pi = (acc >= ki_step) ? acc - ki_step : 12'd0;
        else
            acc_pi = (acc <= IMAX - ki_step) ? acc + ki_step : IMAX;
    end

    // Frequency-acquisition nudge: one old code (two new codes), also clamped at the ends
    always @(*) begin
        if (nudge_up && !nudge_dn)
            acc_next = (acc_pi <= IMAX - NUDGE) ? acc_pi + NUDGE : IMAX;
        else if (nudge_dn && !nudge_up)
            acc_next = (acc_pi >= NUDGE) ? acc_pi - NUDGE : 12'd0;
        else
            acc_next = acc_pi;
    end

    // Proportional path
    always @(*) begin
        if (early) begin
            if (ONE_SIDED_KP != 0)
                code_sum = {1'b0, acc_next[11:5]};
            else
                // Extend to 8 bits to catch underflow below 0
                code_sum = {1'b0, acc_next[11:5]} - {1'b0, kp_step};
            // If bit 7 is set, we underflowed below 0 -> clamp to 0
            code_next = code_sum[7] ? 7'd0 : code_sum[6:0];
        end else begin
            code_sum = {1'b0, acc_next[11:5]} + {1'b0, kp_step};
            // If bit 7 is set, we exceeded 127 -> clamp to 127
            code_next = code_sum[7] ? 7'd127 : code_sum[6:0];
        end
    end

    // Registers: update once per reference cycle, on the rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc  <= MID;
            code <= 7'd64;
        end else begin
            acc  <= acc_next;
            code <= code_next;
        end
    end

    assign integ = acc[11:5];

endmodule

`default_nettype wire
