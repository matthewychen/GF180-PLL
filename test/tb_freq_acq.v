`timescale 1ns/1ps
`default_nettype none

// Testbench for freq_acq: drive vco_clk at a fixed frequency, count nudge
// pulses over several windows and check freq_ok. Expected count is 256 per
// 32-cycle window at 80 MHz; TOL_ACQ = 10 counts, TOL_LOCK = 6 counts.
module tb_freq_acq;

    reg  clk     = 1'b0;
    reg  rst_n   = 1'b0;
    reg  vco_clk = 1'b0;
    wire nudge_up, nudge_dn, freq_ok;

    freq_acq dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .vco_clk (vco_clk),
        .nudge_up(nudge_up),
        .nudge_dn(nudge_dn),
        .freq_ok (freq_ok)
    );

    always #50 clk = ~clk;          // 10 MHz reference

    real f_vco   = 80.0e6;
    reg  vco_run = 1'b1;
    always begin
        #(0.5e9 / f_vco);
        if (vco_run) vco_clk = ~vco_clk;
    end

    integer errors = 0;
    integer n_up, n_dn, ok_cycles, cycles, i;
    reg     prev_up = 1'b0, prev_dn = 1'b0;

    // count rising edges of the nudge pulses and check they are 1 cycle wide
    always @(posedge clk) begin
        if (nudge_up && prev_up) begin
            $display("FAIL: nudge_up longer than one cycle");
            errors = errors + 1;
        end
        if (nudge_dn && prev_dn) begin
            $display("FAIL: nudge_dn longer than one cycle");
            errors = errors + 1;
        end
        if (nudge_up && nudge_dn) begin
            $display("FAIL: nudge_up and nudge_dn at the same time");
            errors = errors + 1;
        end
        prev_up = nudge_up;
        prev_dn = nudge_dn;
    end

    // reset, run 3 windows to settle (first window is skipped, plus handshake
    // latency), then measure over 10 windows
    task run_at(input real f_hz);
        begin
            f_vco = f_hz;
            rst_n = 1'b0;
            repeat (3) @(negedge clk);
            if (nudge_up || nudge_dn || freq_ok) begin
                $display("FAIL: outputs not cleared by reset");
                errors = errors + 1;
            end
            rst_n = 1'b1;
            repeat (3 * 32) @(negedge clk);
            n_up = 0; n_dn = 0; ok_cycles = 0; cycles = 10 * 32;
            for (i = 0; i < cycles; i = i + 1) begin
                @(negedge clk);
                if (nudge_up) n_up = n_up + 1;
                if (nudge_dn) n_dn = n_dn + 1;
                if (freq_ok)  ok_cycles = ok_cycles + 1;
            end
            $display("  %5.1f MHz: nudge_up %0d, nudge_dn %0d, freq_ok %0d / %0d cycles",
                     f_hz / 1e6, n_up, n_dn, ok_cycles, cycles);
        end
    endtask

    task check(input integer up_min, input integer up_max,
               input integer dn_min, input integer dn_max,
               input integer ok_expected);   // 1 = always, 0 = never
        begin
            if (n_up < up_min || n_up > up_max || n_dn < dn_min || n_dn > dn_max) begin
                $display("FAIL: nudges up=%0d dn=%0d, expected up %0d..%0d dn %0d..%0d",
                         n_up, n_dn, up_min, up_max, dn_min, dn_max);
                errors = errors + 1;
            end
            if (ok_expected && ok_cycles != cycles) begin
                $display("FAIL: freq_ok dropped on target");
                errors = errors + 1;
            end
            if (!ok_expected && ok_cycles != 0) begin
                $display("FAIL: freq_ok high off target");
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_freq_acq.vcd");
        $dumpvars(0, tb_freq_acq);

        $display("[1] on target: no nudges, freq_ok");
        run_at(80.0e6);   check(0, 0, 0, 0, 1);

        $display("[2] small error (-1.25 %%, ~-3 counts): bang-bang's job, freq_ok");
        run_at(79.0e6);   check(0, 0, 0, 0, 1);

        $display("[3] between tolerances (~-8 counts): no nudge, not freq_ok");
        run_at(77.5e6);   check(0, 0, 0, 0, 0);

        $display("[4] VCO 10 %% slow: nudge_up once per window");
        run_at(72.0e6);   check(9, 11, 0, 0, 0);

        $display("[5] VCO 10 %% fast: nudge_dn once per window");
        run_at(88.0e6);   check(0, 0, 9, 11, 0);

        $display("[6] VCO 25 %% slow / fast: still the right direction");
        run_at(60.0e6);   check(9, 11, 0, 0, 0);
        run_at(100.0e6);  check(0, 0, 9, 11, 0);

        $display("[7] VCO stops while on target: freq_ok must drop");
        run_at(80.0e6);
        vco_run = 1'b0;
        repeat (6 * 32) @(negedge clk);
        if (freq_ok) begin
            $display("FAIL: freq_ok still high with the VCO stopped");
            errors = errors + 1;
        end
        if (nudge_up || nudge_dn) begin
            $display("FAIL: nudging with the VCO stopped");
            errors = errors + 1;
        end
        vco_run = 1'b1;

        if (errors == 0) begin
            $display("PASS");
            $finish;
        end else begin
            $fatal(1, "FAILED with %0d errors", errors);
        end
    end

endmodule

`default_nettype wire
