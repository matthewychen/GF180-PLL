`timescale 1ns/1ps
`default_nettype none

// Testbench for fb_divider.
// Drives an 80 MHz clock, checks fb_clk is 10 MHz (100 ns period)
// with a 50 ns high time, and that it stays low during reset.
module tb_fb_divider;

    reg  vco_clk = 1'b0;
    reg  rst_n   = 1'b0;
    wire fb_clk;

    fb_divider dut (
        .vco_clk(vco_clk),
        .rst_n  (rst_n),
        .fb_clk (fb_clk)
    );

    // 80 MHz: 12.5 ns period, toggle every 6.25 ns
    always #6.25 vco_clk = ~vco_clk;

    realtime t_rise, t_prev, t_fall;
    integer  edges  = 0;
    integer  errors = 0;

    // Check the period on every rising edge of fb_clk
    always @(posedge fb_clk) begin
        t_rise = $realtime;
        if (edges > 0 && ((t_rise - t_prev) < 99.9 || (t_rise - t_prev) > 100.1)) begin
            $display("FAIL: period %0.2f ns, expected 100 ns", t_rise - t_prev);
            errors = errors + 1;
        end
        t_prev = t_rise;
        edges  = edges + 1;
    end

    // Check the high time on every falling edge of fb_clk
    always @(negedge fb_clk) begin
        t_fall = $realtime;
        if (edges > 0 && ((t_fall - t_rise) < 49.9 || (t_fall - t_rise) > 50.1)) begin
            $display("FAIL: high time %0.2f ns, expected 50 ns", t_fall - t_rise);
            errors = errors + 1;
        end
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fb_divider);

        // Hold reset for 20 ns
        #20;
        if (fb_clk !== 1'b0) begin
            $display("FAIL: fb_clk not low during reset");
            errors = errors + 1;
        end

        // Release reset and run for 20 output periods
        rst_n = 1'b1;
        #2000;

        if (edges < 15) begin
            $display("FAIL: only %0d rising edges seen", edges);
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: fb_clk is 10 MHz with 50%% duty cycle");
            $display("PASS");
        end else
            $display("FAILED with %0d errors", errors);

        $finish;
    end

endmodule

`default_nettype wire
