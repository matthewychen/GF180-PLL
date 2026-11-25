`timescale 1ns/1ps
`default_nettype none

// Testbench for pi_filter (7-bit code, 12-bit accumulator read as acc[11:5]).
// Two DUTs share the inputs: dut_os has the one-sided kick (ONE_SIDED_KP = 1, the default),
// dut_sym the symmetric +/-Kp kick. Both have the same integrator; only the early-cycle code differs.
// Inputs change on falling clock edges; outputs are checked on the
// next falling edge, after the filter has updated on the rising edge.
module tb_pi_filter;

    reg        clk    = 1'b0;
    reg        rst_n  = 1'b0;
    reg        early  = 1'b0;
    reg  [1:0] kp_sel = 2'd0;
    reg  [1:0] ki_sel = 2'd0;
    reg        nudge_up = 1'b0;
    reg        nudge_dn = 1'b0;
    wire [6:0] code, code_sym;
    wire [6:0] integ, integ_sym;

    pi_filter #(.ONE_SIDED_KP(1)) dut_os (
        .clk   (clk),
        .rst_n (rst_n),
        .early (early),
        .kp_sel(kp_sel),
        .ki_sel(ki_sel),
        .nudge_up(nudge_up),
        .nudge_dn(nudge_dn),
        .code  (code),
        .integ (integ)
    );

    pi_filter #(.ONE_SIDED_KP(0)) dut_sym (
        .clk   (clk),
        .rst_n (rst_n),
        .early (early),
        .kp_sel(kp_sel),
        .ki_sel(ki_sel),
        .nudge_up(nudge_up),
        .nudge_dn(nudge_dn),
        .code  (code_sym),
        .integ (integ_sym)
    );

    // 10 MHz reference: 100 ns period
    always #50 clk = ~clk;

    integer   errors = 0;
    integer   i;
    reg [6:0] prev, prev_sym;

    // Hold reset for 2 cycles, release on a falling edge
    task do_reset;
        begin
            @(negedge clk) rst_n = 1'b0;
            @(negedge clk);
            @(negedge clk) rst_n = 1'b1;
        end
    endtask

    // want_os: one-sided DUT, want_sym: symmetric DUT
    task expect_code(input [6:0] want_os, input [6:0] want_sym);
        begin
            if (code !== want_os) begin
                $display("FAIL at %0t ns: one-sided code = %0d, expected %0d", $time / 1000, code, want_os);
                errors = errors + 1;
            end
            if (code_sym !== want_sym) begin
                $display("FAIL at %0t ns: symmetric code = %0d, expected %0d", $time / 1000, code_sym, want_sym);
                errors = errors + 1;
            end
        end
    endtask

    task expect_integ(input [6:0] want, input [8*40-1:0] what);
        begin
            if (integ !== want || integ_sym !== want) begin
                $display("FAIL: %0s: integrator %0d / %0d, expected %0d", what, integ, integ_sym, want);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pi_filter);

        // Test 1: reset loads mid-code (accumulator 2048 = code 64, same voltage as 6-bit code 32)
        do_reset;
        expect_code(7'd64, 7'd64);
        expect_integ(7'd64, "reset");

        // Test 2: one late decision gives 64 + Kp in both modes, for each Kp setting
        for (i = 0; i < 4; i = i + 1) begin
            kp_sel = i;
            ki_sel = 2'd0;
            early  = 1'b0;
            do_reset;
            @(negedge clk);
            expect_code(7'd64 + (7'd1 << i), 7'd64 + (7'd1 << i));
        end

        // Test 3: one early decision: accumulator 2047 -> integrator 63.
        // One-sided: code = integrator (63). Symmetric: 63 - Kp.
        for (i = 0; i < 4; i = i + 1) begin
            kp_sel = i;
            ki_sel = 2'd0;
            early  = 1'b1;
            do_reset;
            @(negedge clk);
            expect_code(7'd63, 7'd63 - (7'd1 << i));
        end

        // Test 4: alternating decisions, like a locked loop, Kp = 4.
        // Accumulator bounces 2049 / 2048 -> integrator 64.
        // Symmetric: 68 <-> 60 (2 x Kp). One-sided: 68 <-> 64 (1 x Kp).
        kp_sel = 2'd2;
        ki_sel = 2'd0;
        do_reset;
        for (i = 0; i < 20; i = i + 1) begin
            early = i[0];
            @(negedge clk);
            expect_code(early ? 7'd64 : 7'd68, early ? 7'd60 : 7'd68);
        end

        // Test 5: always late, fastest Ki. Code must rise to 127,
        // never go down on the way, and never wrap to 0.
        kp_sel = 2'd0;
        ki_sel = 2'd3;
        early  = 1'b0;
        do_reset;
        prev = code;
        prev_sym = code_sym;
        for (i = 0; i < 600; i = i + 1) begin
            @(negedge clk);
            if (code < prev || code_sym < prev_sym) begin
                $display("FAIL at %0t ns: code fell while late (%0d -> %0d, sym %0d -> %0d)",
                         $time / 1000, prev, code, prev_sym, code_sym);
                errors = errors + 1;
            end
            prev = code;
            prev_sym = code_sym;
        end
        expect_code(7'd127, 7'd127);
        expect_integ(7'd127, "saturate high");

        // Test 6: always early from the top. Code must fall to 0,
        // never go up on the way, and never wrap to 127.
        early = 1'b1;
        prev  = code;
        prev_sym = code_sym;
        for (i = 0; i < 1200; i = i + 1) begin
            @(negedge clk);
            if (code > prev || code_sym > prev_sym) begin
                $display("FAIL at %0t ns: code rose while early (%0d -> %0d, sym %0d -> %0d)",
                         $time / 1000, prev, code, prev_sym, code_sym);
                errors = errors + 1;
            end
            prev = code;
            prev_sym = code_sym;
        end
        expect_code(7'd0, 7'd0);
        expect_integ(7'd0, "saturate low");

        // Test 7: frequency-acquisition nudges move the accumulator by 64 LSB
        // (two 7-bit codes = one old 6-bit code) on top of the normal PI step. Kp = 1, Ki = 1/32 code.
        kp_sel = 2'd0;
        ki_sel = 2'd0;

        // late + nudge_up: accumulator 2048 + 1 + 64 = 2113 -> 66, code 66 + 1
        early = 1'b0;
        do_reset;
        nudge_up = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        expect_code(7'd67, 7'd67);
        expect_integ(7'd66, "nudge_up");

        // early + nudge_dn: accumulator 2048 - 1 - 64 = 1983 -> 61, code 61 (one-sided) / 60 (symmetric)
        early = 1'b1;
        do_reset;
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_dn = 1'b0;
        expect_code(7'd61, 7'd60);
        expect_integ(7'd61, "nudge_dn");

        // both at once: ignored, normal PI step only (2048 + 1 -> 64, code 65)
        early = 1'b0;
        do_reset;
        nudge_up = 1'b1;
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        nudge_dn = 1'b0;
        expect_code(7'd65, 7'd65);

        // nudge_up at the top must clamp, not wrap
        ki_sel = 2'd3;
        early  = 1'b0;
        do_reset;
        for (i = 0; i < 600; i = i + 1) @(negedge clk);
        nudge_up = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        expect_integ(7'd127, "nudge_up at the top");

        // nudge_dn at the bottom must clamp, not wrap
        early = 1'b1;
        for (i = 0; i < 1200; i = i + 1) @(negedge clk);
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_dn = 1'b0;
        expect_integ(7'd0, "nudge_dn at the bottom");

        if (errors == 0) begin
            $display("All checks passed (one-sided and symmetric kick): reset, Kp steps, lock bounce, saturation and nudges");
            $display("PASS");
        end else
            $display("FAILED with %0d errors", errors);

        $finish;
    end

endmodule

`default_nettype wire
