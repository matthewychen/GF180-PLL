`timescale 1ns/1ps
`default_nettype none

// Frequency acquisition: counts vco_clk cycles per 32 ref cycles (256 = on target).
// Off by > TOL_ACQ: nudge the PI integrator 1 code toward target. Within TOL_LOCK: freq_ok (gates LOCK).
// Count crosses vco_clk -> clk via toggle handshake; cnt_snap is a false path for STA.

module freq_acq #(
    parameter N_DIV    = 8,    // feedback divide ratio
    parameter WINDOW   = 32,   // reference cycles per measurement
    parameter TOL_ACQ  = 10,   // counts (~4 % of 256): outside this, steer
    parameter TOL_LOCK = 6     // counts (~2.3 % of 256): inside this, freq_ok. Allows
                               // for phase wander at high Kp (KP_SEL = 3 swings ~+/-5 counts)
) (
    input  wire clk,       // 10 MHz reference
    input  wire rst_n,     // active-low reset
    input  wire vco_clk,   // from VCO
    output reg  nudge_up,  // one clk-cycle pulse: raise integrator by 1 code
    output reg  nudge_dn,  // one clk-cycle pulse: lower integrator by 1 code
    output reg  freq_ok    // last window was within TOL_LOCK
);

    localparam integer EXPECTED = N_DIV * WINDOW;
    localparam integer CNT_W    = $clog2(2 * EXPECTED + 1);   // room for 2x too fast
    localparam [CNT_W-1:0] CNT_MAX = {CNT_W{1'b1}};
    localparam integer WIN_W    = $clog2(WINDOW);
    localparam integer WIN_LAST_I = WINDOW - 1;
    localparam [WIN_W-1:0] WIN_LAST = WIN_LAST_I[WIN_W-1:0];
    localparam signed [CNT_W+1:0] EXP_S      = EXPECTED[CNT_W+1:0];
    localparam signed [CNT_W+1:0] TOL_ACQ_S  = TOL_ACQ;
    localparam signed [CNT_W+1:0] TOL_LOCK_S = TOL_LOCK;

    // ---------------- clk domain: window timer ----------------
    reg [WIN_W-1:0] win_cnt;
    reg             win_tog;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            win_cnt <= 0;
            win_tog <= 1'b0;
        end else begin
            win_cnt <= win_cnt + 1'b1;          // wraps every WINDOW cycles
            if (win_cnt == WIN_LAST)
                win_tog <= ~win_tog;
        end
    end

    // ---------------- vco domain: cycle counter ----------------
    reg [2:0]       win_sync;     // [1:0] synchronizer, [2] edge detect
    reg [CNT_W-1:0] vco_cnt;
    reg [CNT_W-1:0] cnt_snap;
    reg             snap_tog;

    wire win_edge = win_sync[2] ^ win_sync[1];

    always @(posedge vco_clk or negedge rst_n) begin
        if (!rst_n) begin
            win_sync <= 3'b000;
            vco_cnt  <= 0;
            cnt_snap <= 0;
            snap_tog <= 1'b0;
        end else begin
            win_sync <= {win_sync[1:0], win_tog};
            if (win_edge) begin
                cnt_snap <= vco_cnt;
                vco_cnt  <= 1;                  // this cycle is the first of the next window
                snap_tog <= ~snap_tog;
            end else if (vco_cnt != CNT_MAX) begin
                vco_cnt  <= vco_cnt + 1'b1;     // saturate rather than wrap
            end
        end
    end

    // ---------------- clk domain: decision ----------------
    reg [2:0] snap_sync;          // [1:0] synchronizer, [2] edge detect
    reg       primed;             // first window after reset is partial: skip it
    reg [WIN_W+1:0] since_snap;   // watchdog: clk cycles since the last result
    localparam [WIN_W+1:0] STALE = {(WIN_W+2){1'b1}};   // ~4 windows

    wire snap_edge = snap_sync[2] ^ snap_sync[1];
    wire signed [CNT_W+1:0] err = $signed({2'b00, cnt_snap}) - EXP_S;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            snap_sync <= 3'b000;
            primed    <= 1'b0;
            nudge_up  <= 1'b0;
            nudge_dn  <= 1'b0;
            freq_ok   <= 1'b0;
            since_snap <= 0;
        end else begin
            snap_sync <= {snap_sync[1:0], snap_tog};
            nudge_up  <= 1'b0;
            nudge_dn  <= 1'b0;

            // If the VCO stops (e.g. ena low) no results arrive: don't let a
            // stale freq_ok keep LOCK high.
            if (snap_edge)
                since_snap <= 0;
            else if (since_snap != STALE)
                since_snap <= since_snap + 1'b1;
            else
                freq_ok <= 1'b0;

            if (snap_edge) begin
                if (!primed) begin
                    primed <= 1'b1;
                end else begin
                    nudge_up <= (err < -TOL_ACQ_S);
                    nudge_dn <= (err >  TOL_ACQ_S);
                    freq_ok  <= (err >= -TOL_LOCK_S) && (err <= TOL_LOCK_S);
                end
            end
        end
    end

endmodule

`default_nettype wire
