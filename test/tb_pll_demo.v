`timescale 1ns/1ps
`default_nettype none

// Demo of the whole digital core (pll_digital) in one GTKWave run. The `phase` signal says what is happening:
//   0 reset held            integrator at 64, LOCK low
//   1 acquire               slow-chip (ss) VCO starts at 54.6 MHz; freq_acq nudges the code up, loop locks
//   2 hold lock             300 cycles of steady state: code dithers by Kp (one-sided kick), LOCK stays high
//   3 frequency step        VCO jumps +12 % (like a temperature/supply change): LOCK drops, loop re-locks
//   4 VCO stops / restarts  no vco_clk: EARLY freezes so LOCK drops, watchdog clears freq_ok; VCO back: re-locks
//   5 reset while locked    rst_n low: LOCK clears at once, integrator back to 64
// Every phase is also checked, so this doubles as a regression test.
// Run:  test/run_unit_tests.sh pll_demo      View: cd test && gtkwave tb_pll_demo.vcd tb_pll_demo.gtkw
module tb_pll_demo;

    localparam real    F_TARGET = 80.0e6;

    reg        clk     = 1'b0;
    reg        rst_n   = 1'b0;
    reg  [1:0] kp_sel  = 2'd0;
    reg  [1:0] ki_sel  = 2'd0;
    reg        vco_clk = 1'b0;
    wire [6:0] code;
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

    reg vco_run = 1'b1;
    always #50 clk = ~clk;
    always begin
        #(0.5e9 / f_of_code(code));
        if (vco_run) vco_clk = ~vco_clk;
    end

    // ---- observation signals for the waveform ----
    integer  phase = 0;
    integer  cycle = 0;
    real     vctrl_v, fvco_mhz, phase_ns;
    realtime t_fb_rise = 0;
    always @(posedge clk_out) t_fb_rise = $realtime;
    always @(posedge clk) begin
        cycle    = rst_n ? cycle + 1 : 0;
        vctrl_v  = vctrl_of_r(code);
        fvco_mhz = vco_run ? f_of_code(code) / 1e6 : 0.0;
        phase_ns = $realtime - t_fb_rise;
        if (phase_ns > 50.0) phase_ns = phase_ns - 100.0;
    end

    // ---- helpers ----
    integer errors = 0;
    integer n, t_lock;

    task fail(input [8*64-1:0] msg);
        begin
            $display("  FAIL in phase %0d at cycle %0d: %0s", phase, cycle, msg);
            errors = errors + 1;
        end
    endtask

    // wait up to max_cycles for lock == want; returns cycles taken in t_lock (-1 = timed out)
    task wait_lock(input want, input integer max_cycles);
        begin
            t_lock = -1;
            for (n = 0; n < max_cycles && t_lock < 0; n = n + 1) begin
                @(negedge clk);
                if (lock == want) t_lock = n + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_pll_demo.vcd");
        $dumpvars(0, tb_pll_demo);

        tab_idx = 1;     // ss corner: the longest acquisition, so the nudges are easy to see
        scale   = 1.0;

        // ---- 0: reset held ----
        phase = 0;
        repeat (20) @(negedge clk);
        if (lock !== 1'b0)                      fail("LOCK high in reset");
        if (dut.u_pi_filter.integ !== 7'd64)    fail("integrator not at mid-code in reset");
        $display("[0] reset: LOCK=%b, integrator=%0d", lock, dut.u_pi_filter.integ);

        // ---- 1: acquire from a slow chip ----
        phase = 1;
        rst_n = 1'b1;
        wait_lock(1'b1, 1000);
        if (t_lock < 0) fail("did not lock within 1000 cycles");
        $display("[1] acquire: start %.1f MHz, LOCK after %0d cycles, integrator=%0d, VCO %.1f MHz",
                 f_of_code(CODE_MID) / 1e6, t_lock, dut.u_pi_filter.integ, f_of_code(dut.u_pi_filter.acc / ACC_PER_CODE) / 1e6);

        // ---- 2: hold lock ----
        phase = 2;
        for (n = 0; n < 300; n = n + 1) begin
            @(negedge clk);
            if (!lock) fail("LOCK dropped in steady state");
        end
        $display("[2] hold: LOCK stayed high for 300 cycles, code dithering around %0d", dut.u_pi_filter.integ);

        // ---- 3: VCO frequency steps +12 % ----
        phase = 3;
        scale = 1.12;
        wait_lock(1'b0, 100);
        if (t_lock < 0) fail("LOCK did not drop after the frequency step");
        $display("[3] step: VCO jumped to %.1f MHz, LOCK dropped after %0d cycles", f_of_code(dut.u_pi_filter.acc / ACC_PER_CODE) / 1e6, t_lock);
        wait_lock(1'b1, 1000);
        if (t_lock < 0) fail("did not re-lock after the frequency step");
        $display("          re-locked after %0d cycles, integrator now %0d", t_lock, dut.u_pi_filter.integ);

        // ---- 4: VCO stops, then restarts ----
        phase = 4;
        vco_run = 1'b0;
        wait_lock(1'b0, 300);
        if (t_lock < 0) fail("LOCK did not drop with the VCO stopped");
        $display("[4] VCO stopped: LOCK dropped after %0d cycles (EARLY freezes -> run-length check; freq_ok watchdog follows)", t_lock);
        repeat (100) @(negedge clk);
        vco_run = 1'b1;
        wait_lock(1'b1, 1000);
        if (t_lock < 0) fail("did not re-lock after the VCO restarted");
        $display("          VCO restarted: re-locked after %0d cycles", t_lock);

        // ---- 5: reset while locked ----
        phase = 5;
        #10 rst_n = 1'b0;
        #1;
        if (lock !== 1'b0) fail("LOCK not cleared by reset");
        @(negedge clk);
        if (dut.u_pi_filter.integ !== 7'd64) fail("integrator not reloaded to mid-code");
        $display("[5] reset: LOCK=%b, integrator=%0d", lock, dut.u_pi_filter.integ);
        repeat (20) @(negedge clk);

        if (errors == 0) begin
            $display("PASS");
            $finish;
        end else begin
            $fatal(1, "FAILED with %0d errors", errors);
        end
    end

endmodule

`default_nettype wire
