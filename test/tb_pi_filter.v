`timescale 1ns/1ps
`default_nettype none

// Testbench for pi_filter.
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
    wire [5:0] code;
    wire [5:0] integ;

    pi_filter dut (
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

    // 10 MHz reference: 100 ns period
    always #50 clk = ~clk;

    integer   errors = 0;
    integer   i;
    reg [5:0] prev;

    // Hold reset for 2 cycles, release on a falling edge
    task do_reset;
        begin
            @(negedge clk) rst_n = 1'b0;
            @(negedge clk);
            @(negedge clk) rst_n = 1'b1;
        end
    endtask

    task expect_code(input [5:0] want);
        begin
            if (code !== want) begin
                $display("FAIL at %0t ns: code = %0d, expected %0d", $time / 1000, code, want);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pi_filter);

        // Test 1: reset loads mid-code
        do_reset;
        expect_code(6'd32);

        // Test 2: one late decision gives 32 + Kp, for each Kp setting
        for (i = 0; i < 4; i = i + 1) begin
            kp_sel = i;
            ki_sel = 2'd0;
            early  = 1'b0;
            do_reset;
            @(negedge clk);
            expect_code(6'd32 + (6'd1 << i));
        end

        // Test 3: alternating decisions, like a locked loop.
        // Kp = 4, so the code should bounce between 36 and 28.
        kp_sel = 2'd2;
        ki_sel = 2'd0;
        do_reset;
        for (i = 0; i < 20; i = i + 1) begin
            early = i[0];
            @(negedge clk);
            expect_code(early ? 6'd28 : 6'd36);
        end

        // Test 4: always late, fastest Ki. Code must rise to 63,
        // never go down on the way, and never wrap to 0.
        kp_sel = 2'd0;
        ki_sel = 2'd3;
        early  = 1'b0;
        do_reset;
        prev = code;
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            if (code < prev) begin
                $display("FAIL at %0t ns: code fell from %0d to %0d while late", $time / 1000, prev, code);
                errors = errors + 1;
            end
            prev = code;
        end
        expect_code(6'd63);
        if (integ !== 6'd63) begin
            $display("FAIL: integrator did not saturate at 63, got %0d", integ);
            errors = errors + 1;
        end

        // Test 5: always early from the top. Code must fall to 0,
        // never go up on the way, and never wrap to 63.
        early = 1'b1;
        prev  = code;
        for (i = 0; i < 600; i = i + 1) begin
            @(negedge clk);
            if (code > prev) begin
                $display("FAIL at %0t ns: code rose from %0d to %0d while early", $time / 1000, prev, code);
                errors = errors + 1;
            end
            prev = code;
        end
        expect_code(6'd0);
        if (integ !== 6'd0) begin
            $display("FAIL: integrator did not saturate at 0, got %0d", integ);
            errors = errors + 1;
        end

        // Test 6: frequency-acquisition nudges move the integrator by one
        // whole code (64/64) on top of the normal PI step. Kp = 1, Ki = 1/64.
        kp_sel = 2'd0;
        ki_sel = 2'd0;

        // late + nudge_up: integrator 2048 + 1 + 64 = 2113 -> 33, code 33 + 1
        early = 1'b0;
        do_reset;
        nudge_up = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        expect_code(6'd34);
        if (integ !== 6'd33) begin
            $display("FAIL: nudge_up gave integrator %0d, expected 33", integ);
            errors = errors + 1;
        end

        // early + nudge_dn: integrator 2048 - 1 - 64 = 1983 -> 30, code 30 - 1
        early = 1'b1;
        do_reset;
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_dn = 1'b0;
        expect_code(6'd29);
        if (integ !== 6'd30) begin
            $display("FAIL: nudge_dn gave integrator %0d, expected 30", integ);
            errors = errors + 1;
        end

        // both at once: ignored, normal PI step only (2048 + 1 -> 32, code 33)
        early = 1'b0;
        do_reset;
        nudge_up = 1'b1;
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        nudge_dn = 1'b0;
        expect_code(6'd33);

        // nudge_up at the top must clamp, not wrap
        ki_sel = 2'd3;
        early  = 1'b0;
        do_reset;
        for (i = 0; i < 300; i = i + 1) @(negedge clk);
        nudge_up = 1'b1;
        @(negedge clk);
        nudge_up = 1'b0;
        if (integ !== 6'd63) begin
            $display("FAIL: nudge_up at the top wrapped the integrator to %0d", integ);
            errors = errors + 1;
        end

        // nudge_dn at the bottom must clamp, not wrap
        early = 1'b1;
        for (i = 0; i < 600; i = i + 1) @(negedge clk);
        nudge_dn = 1'b1;
        @(negedge clk);
        nudge_dn = 1'b0;
        if (integ !== 6'd0) begin
            $display("FAIL: nudge_dn at the bottom wrapped the integrator to %0d", integ);
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("All checks passed: reset, Kp steps, lock bounce, saturation and nudges");
            $display("PASS");
        end else
            $display("FAILED with %0d errors", errors);

        $finish;
    end

endmodule

`default_nettype wire