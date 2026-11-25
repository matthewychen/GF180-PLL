`timescale 1ns/1ps
`default_nettype none

// Waveform run for GTKWave: one acquisition per corner (tt, ss, ff; KP_SEL 0, KI_SEL 0), back to back
// in one VCD, with the same analog model as tb_pll_closed_loop.v. `corner` (0/1/2) marks which run is on screen.
// Run:  test/run_unit_tests.sh pll_waves
// View: cd test && gtkwave tb_pll_waves.vcd tb_pll_waves.gtkw
module tb_pll_waves;

    localparam real    F_TARGET = 80.0e6;
    localparam integer RUN_CYCLES = 1200;

    reg        clk     = 1'b0;
    reg        rst_n   = 1'b0;
    reg  [1:0] kp_sel  = 2'd0;
    reg  [1:0] ki_sel  = 2'd0;
    reg        vco_clk = 1'b0;
    wire [5:0] code;
    wire       clk_out;
    wire       lock;

    pll_digital dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .kp_sel (kp_sel),
        .ki_sel (ki_sel),
        .vco_clk(vco_clk),
        .code   (code),
        .clk_out(clk_out),
        .lock   (lock)
    );

    `include "pll_analog_model.vh"

    always #50 clk = ~clk;
    always begin
        #(0.5e9 / f_of_code(code));
        vco_clk = ~vco_clk;
    end

    // ---- per-cycle observation (for the waveform) ----
    real     vctrl_v, fvco_mhz, favg_mhz, phase_ns;
    realtime t_fb_rise = 0;
    integer  cycle  = 0;
    integer  corner = 0;   // 0 = tt, 1 = ss, 2 = ff
    real     f_sum  = 0;   // mean VCO frequency over the last 200 cycles of each run

    always @(posedge clk_out) t_fb_rise = $realtime;

    always @(posedge clk) begin
        if (rst_n) begin
            cycle    = cycle + 1;
            vctrl_v  = V_FS - code * V_LSB;
            fvco_mhz = f_of_code(code) / 1e6;
            favg_mhz = f_of_code(dut.u_pi_filter.acc / 64.0) / 1e6;
            phase_ns = $realtime - t_fb_rise;
            if (phase_ns > 50.0) phase_ns = phase_ns - 100.0;
            if (cycle > RUN_CYCLES - 200) f_sum = f_sum + fvco_mhz;
        end
    end

    integer c, k, errors = 0, lock_at;
    reg [8*2-1:0] cname;

    initial begin
        $dumpfile("tb_pll_waves.vcd");
        $dumpvars(0, tb_pll_waves);

        for (c = 0; c < 3; c = c + 1) begin
            tab_idx = c;
            corner  = c;
            case (c)
                0: cname = "tt";
                1: cname = "ss";
                2: cname = "ff";
            endcase

            rst_n = 1'b0;
            repeat (3) @(negedge clk);
            cycle = 0;
            f_sum = 0;
            rst_n = 1'b1;
            lock_at = -1;
            for (k = 0; k < RUN_CYCLES; k = k + 1) begin
                @(negedge clk);
                if (lock && lock_at < 0) lock_at = cycle;
            end

            $display("%0s: start %.1f MHz (code 32), LOCK at cycle %0d, mean of last 200 cycles %.2f MHz, integrator code %.1f",
                     cname, f_of_code(32.0) / 1e6, lock_at, f_sum / 200.0, dut.u_pi_filter.acc / 64.0);
            if (lock_at < 0 || lock_at > 1000) errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS");
            $finish;
        end else begin
            $fatal(1, "FAILED with %0d errors", errors);
        end
    end

endmodule

`default_nettype wire
