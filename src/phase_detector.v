`timescale 1ns/1ps

module phase_detector_deadband #(
    parameter DEADBAND = 2,
    parameter CNT_W = 8
    )(
    input sample_clk, // fast sampling clock
    input clk, // reference signal
    input fb_clk, // feedback signal
    input rst_n,
    output reg early, // signal designating a mismatch
    output reg late
);
    reg [2:0] ref_s, fb_s;

    // 2ff sync
    always @(posedge sample_clk or negedge rst_n)
        if (!rst_n) begin
            ref_s <= 0;
            fb_s  <= 0;
        end else begin
            ref_s <= {ref_s[1:0], clk};
            fb_s  <= {fb_s[1:0],  fb_clk};
        end
 
    wire ref_e = ref_s[1] & ~ref_s[2];
    wire fb_e  = fb_s[1]  & ~fb_s[2];
 
    // pfd with deadband
    reg ref_first, fb_first;
    reg [CNT_W-1: 0] cnt; // counter to count diff between posedge fb and ref
    wire got_ref = ref_first | ref_e;
    wire got_fb  = fb_first  | fb_e;
 
    always @(posedge sample_clk or negedge rst_n) begin
        if (!rst_n) begin
            ref_first <= 0;
            fb_first <= 0;
            cnt <= 0;
            early <= 0;
            late <= 0;
        end else if (got_ref & got_fb) begin
            // if both posedges detected, reset
            late <= ref_first & (cnt > DEADBAND);
            early <= fb_first & (cnt > DEADBAND);
            ref_first <= 0;
            fb_first <= 0;
            cnt <= 0;
        end else begin
            // after first one is found, start ticking the counter
            ref_first <= got_ref;
            fb_first <= got_fb;
            if ((got_ref | got_fb) && ~&cnt) cnt <= cnt + 1;
        end
    end
 
endmodule

module phase_detector(
    input clk, // reference signal
    input fb_clk, // feedback signal
    input rst_n,
    output reg early
);
// SOLUTION WITHOUT DEADBAND

    always @(posedge clk or negedge rst_n)
        if (!rst_n) early <= 0;
        else early <= fb_clk;

endmodule