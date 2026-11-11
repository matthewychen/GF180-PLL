`timescale 1ns/1ps
`default_nettype none

// Testbench for lock_detector.
// Run (from repo root):
//   test/run_unit_tests.sh lock_detector
// View waveforms (from test/):
//   gtkwave tb_lock_detector.vcd tb_lock_detector.gtkw
//
// Timing convention: early changes on the falling edge, the DUT samples it on
// the rising edge, and lock is checked 1 ns after that rising edge. One call
// to send() = one PFD decision = one sample.
module tb_lock_detector;

    localparam MAX_RUN     = 8;
    localparam LOCK_CYCLES = 256;

    reg  clk   = 1'b0;
    reg  rst_n = 1'b0;
    reg  early = 1'b0;
    wire lock;

    integer errors = 0;
    integer i, k;

    lock_detector #(
        .MAX_RUN    (MAX_RUN),
        .LOCK_CYCLES(LOCK_CYCLES)
    ) dut (
        .clk  (clk),
        .rst_n(rst_n),
        .early(early),
        .lock (lock)
    );

    // 10 MHz: 100 ns period
    always #50 clk = ~clk;

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    // Hold reset for a few cycles, release it on a falling edge so the next
    // rising edge is the first real sample. DUT resets last_bit to 0.
    task do_reset;
        begin
            rst_n = 1'b0;
            early = 1'b0;
            repeat (3) @(negedge clk);
            rst_n = 1'b1;
        end
    endtask

    // Drive one decision and wait until the DUT has sampled it.
    task send(input b);
        begin
            early = b;
            @(posedge clk);
            #1;
            @(negedge clk);
        end
    endtask

    task expect_lock(input exp, input [8*48-1:0] msg);
        begin
            if (lock !== exp) begin
                $display("  ERROR @%0t: %0s: lock=%b, expected %b", $time, msg, lock, exp);
                errors = errors + 1;
            end
        end
    endtask

    // Checks lock never rises if never_lock is set.
    task send_runs(input integer run_len, input integer n, input never_lock);
        integer c;
        reg b;
        begin
            b = ~early;
            c = 0;
            for (k = 0; k < n; k = k + 1) begin
                if (c == run_len) begin
                    b = ~b;
                    c = 0;
                end
                send(b);
                c = c + 1;
                if (never_lock) expect_lock(1'b0, "lock rose on a bad pattern");
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Tests
    // ------------------------------------------------------------------
    initial begin
        $dumpfile("tb_lock_detector.vcd");
        $dumpvars(0, tb_lock_detector);

        // 1. Reset state ------------------------------------------------
        $display("[1] reset state");
        do_reset;
        expect_lock(1'b0, "lock high out of reset");

        // 2. Alternating: lock on exactly the 256th sample, then stays -----
        $display("[2] alternating 1010...: lock at sample %0d", LOCK_CYCLES);
        do_reset;
        send_runs(1, LOCK_CYCLES - 1, 1'b1);
        expect_lock(1'b0, "lock early (alternating, sample 255)");
        send_runs(1, 1, 1'b0);
        expect_lock(1'b1, "no lock at sample 256 (alternating)");
        // keep going well past where an 8/9-bit counter would wrap
        for (i = 0; i < 1000; i = i + 1) begin
            send_runs(1, 1, 1'b0);
            expect_lock(1'b1, "lock dropped while alternating");
        end

        // 3. Runs of exactly MAX_RUN are allowed -----------------------
        $display("[3] runs of %0d: still locks at sample %0d", MAX_RUN, LOCK_CYCLES);
        do_reset;
        send_runs(MAX_RUN, LOCK_CYCLES - 1, 1'b1);
        expect_lock(1'b0, "lock early (runs of 8)");
        send_runs(MAX_RUN, 1, 1'b0);
        expect_lock(1'b1, "no lock with runs of 8");

        // 4. Runs of MAX_RUN+1 never lock ------------------------------
        $display("[4] runs of %0d: never locks", MAX_RUN + 1);
        do_reset;
        send_runs(MAX_RUN + 1, 2000, 1'b1);

        // 5/6. Constant input (railed loop) never locks -----------------
        $display("[5] constant 1: never locks");
        do_reset;
        for (i = 0; i < 2000; i = i + 1) begin
            send(1'b1);
            expect_lock(1'b0, "lock with constant 1");
        end

        $display("[6] constant 0: never locks");
        do_reset;
        for (i = 0; i < 2000; i = i + 1) begin
            send(1'b0);
            expect_lock(1'b0, "lock with constant 0");
        end

        // 7. Lock, a run of 8 keeps lock, the 9th identical drops it -----
        $display("[7] locked, then run of 8 (keep) / 9 (drop), then re-acquire");
        do_reset;
        send_runs(1, LOCK_CYCLES, 1'b0);
        expect_lock(1'b1, "setup: not locked");
        // last sample sent is the 1st of a run; MAX_RUN-1 more makes MAX_RUN
        for (i = 0; i < MAX_RUN - 1; i = i + 1) begin
            send(early);
            expect_lock(1'b1, "lock dropped on run <= 8");
        end
        send(early);  // run of MAX_RUN+1
        expect_lock(1'b0, "lock kept after run of 9");
        // re-acquire: needs another full LOCK_CYCLES good samples
        send_runs(1, LOCK_CYCLES - 1, 1'b1);
        expect_lock(1'b0, "re-lock too early");
        send_runs(1, 1, 1'b0);
        expect_lock(1'b1, "no re-lock after 256 good samples");

        // 8. Bad run every 200 samples never lets lock assert -----------
        $display("[8] 9-run every ~200 samples: never locks");
        do_reset;
        for (i = 0; i < 10; i = i + 1) begin
            send_runs(1, 200, 1'b1);
            send_runs(MAX_RUN + 1, MAX_RUN + 1, 1'b1);
        end

        // 9. Async reset clears lock with no clock edge ------------------
        $display("[9] async reset while locked");
        do_reset;
        send_runs(1, LOCK_CYCLES, 1'b0);
        expect_lock(1'b1, "setup: not locked");
        #10 rst_n = 1'b0;
        #1  expect_lock(1'b0, "lock not cleared by async reset");
        rst_n = 1'b1;

        // ------------------------------------------------------------------
        // run_unit_tests.sh needs a line that is exactly "PASS", and a
        // non-zero exit ($fatal) on failure so CI goes red.
        if (errors == 0) begin
            $display("PASS");
            $finish;
        end else begin
            $fatal(1, "FAILED with %0d errors", errors);
        end
    end

endmodule

`default_nettype wire
