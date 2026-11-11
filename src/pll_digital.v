`timescale 1ns/1ps
`default_nettype none

//   clk (10 MHz ref) ──► phase_detector ──► sync (negedge) ──► early ──┬──► pi_filter ──► code[5:0] ──► DAC
//                             ▲                                       └──► lock_detector ──► lock
//                             └── fb_clk ◄── fb_divider (/8) ◄── vco_clk (80 MHz) ◄── VCO
//
// Clock domains: everything runs on clk except fb_divider, which runs on vco_clk.

// The synchronizer is clocked on the FALLING edge of clk
module pll_digital (
    input  wire       clk,      // 10 MHz reference
    input  wire       rst_n,    // active-low reset
    input  wire [1:0] kp_sel,   // ui_in[5:4]
    input  wire [1:0] ki_sel,   // ui_in[7:6]
    input  wire       vco_clk,  // from VCO, 80 MHz when locked
    output wire [5:0] code,     // to DAC
    output wire       clk_out,  // VCO / 8, to uo_out[0]
    output wire       lock      // to uo_out[1]
);

    wire fb_clk;
    wire early_raw;
    wire early;

    fb_divider u_fb_divider (
        .vco_clk(vco_clk),
        .rst_n  (rst_n),
        .fb_clk (fb_clk)
    );

    phase_detector u_phase_detector (
        .clk   (clk),
        .fb_clk(fb_clk),
        .rst_n (rst_n),
        .early (early_raw)
    );

    // Falling-edge synchronizer (see header).
    reg early_sync;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            early_sync <= 1'b0;
        else
            early_sync <= early_raw;
    end
    assign early = early_sync;

    // verilator lint_off PINCONNECTEMPTY
    pi_filter u_pi_filter (
        .clk   (clk),
        .rst_n (rst_n),
        .early (early),
        .kp_sel(kp_sel),
        .ki_sel(ki_sel),
        .code  (code),
        .integ ()           // not used at the top level
    );
    /* verilator lint_on PINCONNECTEMPTY */

    lock_detector u_lock_detector (
        .clk  (clk),
        .rst_n(rst_n),
        .early(early),
        .lock (lock)
    );

    assign clk_out = fb_clk;

endmodule

`default_nettype wire
