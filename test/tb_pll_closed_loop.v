`timescale 1ns/1ps
`default_nettype none

// Closed-loop sim: real pll_digital RTL + behavioral dac7 (1.95 V - 15.45 mV x 7-bit code) and VCO (Matthew's 5-point
// freq-vs-VCTRL table per corner, linear between points; freq FALLS as VCTRL rises, so code up = freq up).
// Sweep 1: corners x KP/KI table. Sweep 2: capture grid (o = locks, f = false LOCK, x = no lock). CI enforces KP_SEL 0-2, KI_SEL 0-2.
// ONE_SIDED_KP (default 1) matches pll_digital; -P tb_pll_closed_loop.ONE_SIDED_KP=0 runs the symmetric kick.
// Run: test/run_unit_tests.sh pll_closed_loop   Results: test/sim_build/unit/tb_pll_closed_loop.log
module tb_pll_closed_loop #(
    parameter ONE_SIDED_KP = 1   // override with iverilog -P tb_pll_closed_loop.ONE_SIDED_KP=0 for the symmetric kick
);

    // ------------------------------------------------------------------
    // Model and test parameters
    // ------------------------------------------------------------------
    localparam real F_REF     = 10.0e6;
    localparam real F_TARGET  = 80.0e6;

    localparam integer RUN_CYCLES = 3000;
    localparam integer WINDOW     = 500;   // steady-state measurement window
    localparam integer LOCK_SPEC  = 1000;  // lock time spec, reference cycles

    localparam integer N_CORNERS  = 3;
    localparam integer STRICT_CORNERS = 1;     // 1 = ss / ff must pass too
    localparam integer MAX_ENFORCED_KP = 2;    // KP_SEL 3 (8 codes = ~8 MHz kicks) is reported only
    localparam integer MAX_ENFORCED_KI = 2;    // KI_SEL 3 rings / never acquires at some corners: open issue, see README
    localparam real    FALSE_LOCK_TOL = 0.05;  // ~4 DAC codes (1 code = ~1.25 % of 80 MHz)
    localparam real    SETTLE_TOL     = 0.0025;
    localparam real    PHASE_TOL_NS   = 25.0;  // mean |CLK_OUT - ref| edge offset
    localparam real    DITHER_MAX_MV  = 124.0; // locked code swing, peak to peak (old spec +/-2 6-bit codes = +/-62 mV)
    localparam real    INTEG_PP_MAX   = 2.0;   // integrator swing after lock, codes p-p: larger = slow ringing

    localparam integer CAP_MAX_PCT  = 34;      // capture sweep: -34 % .. +34 % (real corners sit at ~-32 % / +29 %)
    localparam integer CAP_STEP_PCT = 2;
    localparam integer CAP_MIN_PCT  = 30;      // enforced KP_SEL rows must capture +/-30 % (tt scaled by -34 % cannot reach 80 MHz)

    // ------------------------------------------------------------------
    // DUT and analog model
    // ------------------------------------------------------------------
    reg        clk     = 1'b0;
    reg        rst_n   = 1'b0;
    reg  [1:0] kp_sel  = 2'd0;
    reg  [1:0] ki_sel  = 2'd0;
    reg        vco_clk = 1'b0;
    wire [6:0] code;
    wire       clk_out;
    wire       lock;

    `ifdef GLS
        `define DUT_PARAMS
    `else
        `define DUT_PARAMS #(.ONE_SIDED_KP(ONE_SIDED_KP))
    `endif

        pll_digital `DUT_PARAMS dut (
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

    function real fvco_of(input [6:0] c);
        fvco_of = f_of_code(c);
    endfunction

`ifdef GLS
    // Gate-level netlist is flattened: dut.u_pi_filter.acc doesn't exist.
    // Track the mean DAC code with a slow running average instead. With the
    // one-sided kick, the mean code already includes the +Kp/2 offset.
    real code_ema = 64.0;
    always @(posedge clk) code_ema = code_ema + (code - code_ema) / 64.0;

    function real favg_now(input dummy);
        favg_now = f_of_code(code_ema);
    endfunction
    `define INTEG_NOW (code_ema)
`else
    // Average VCO frequency, from the PI filter's integrator (12-bit, 5
    // fractional bits). The output code also carries the proportional kick,
    // so it swings +/-Kp codes every cycle even when the loop is locked.
    // With the one-sided kick the mean code sits Kp/2 above the integrator
    // (code = integrator + Kp/2 +/- Kp/2), so add that back.
    function real favg_now(input dummy);
        favg_now = f_of_code(dut.u_pi_filter.acc / ACC_PER_CODE
                             + (ONE_SIDED_KP ? (1 << kp_sel) / 2.0 : 0.0));
    endfunction
    `define INTEG_NOW (dut.u_pi_filter.acc / ACC_PER_CODE)
`endif

    // Reference: 10 MHz
    always #50 clk = ~clk;

    // VCO: half period recomputed from the current DAC code every half cycle
    always begin
        #(0.5e9 / fvco_of(code));
        vco_clk = ~vco_clk;
    end

    // ------------------------------------------------------------------
    // Per-run measurement (sampled once per reference cycle)
    // ------------------------------------------------------------------
    integer cycle;
    integer lock_at;
    real    ferr_at_lock;
    real    ferr_sum;
    integer code_min, code_max;
    real    integ_min, integ_max, integ_now;
    integer drops;
    realtime t_fb_rise = 0;
    real    phase_ns;          // ref edge minus CLK_OUT edge, wrapped to +/-50 ns
    real    phase_abs_sum, phase_maxabs;

    always @(posedge clk_out) t_fb_rise = $realtime;

    always @(posedge clk) begin
        if (rst_n) begin
            cycle = cycle + 1;
            if (lock && lock_at < 0) begin
                lock_at      = cycle;
                ferr_at_lock = (favg_now(1'b0) - F_TARGET) / F_TARGET;
            end
            if (cycle > RUN_CYCLES - WINDOW) begin
                ferr_sum = ferr_sum + (fvco_of(code) - F_TARGET) / F_TARGET;
                if (code < code_min) code_min = code;
                if (code > code_max) code_max = code;
integ_now = `INTEG_NOW;
                if (integ_now < integ_min) integ_min = integ_now;
                if (integ_now > integ_max) integ_max = integ_now;
                if (!lock) drops = drops + 1;
                phase_ns = $realtime - t_fb_rise;
                if (phase_ns > 50.0) phase_ns = phase_ns - 100.0;
                phase_abs_sum = phase_abs_sum + ((phase_ns < 0.0) ? -phase_ns : phase_ns);
                if (phase_ns > phase_maxabs)  phase_maxabs = phase_ns;
                if (-phase_ns > phase_maxabs) phase_maxabs = -phase_ns;
            end
        end
    end

    // ------------------------------------------------------------------
    // One run: reset at mid-code with a random VCO / reference phase, run
    // RUN_CYCLES reference cycles at the current corner, then classify.
    // ------------------------------------------------------------------
    integer k;
    integer seed = 1;
    real    ferr_end;
    reg     ok, settled, false_lock, dropped, misaligned, acquired, ringing;

    task do_run(input integer kp_v, input integer ki_v);
        begin
            rst_n  = 1'b0;
            kp_sel = kp_v;
            ki_sel = ki_v;
            #($urandom(seed) % 100);
            seed = seed + 1;
            repeat (3) @(negedge clk);

            cycle         = 0;
            lock_at       = -1;
            ferr_at_lock  = 0.0;
            ferr_sum      = 0.0;
            code_min      = 127;
            code_max      = 0;
            integ_min     = 1.0e9;
            integ_max     = -1.0e9;
            drops         = 0;
            phase_abs_sum = 0.0;
            phase_maxabs  = 0.0;
            rst_n         = 1'b1;

            for (k = 0; k < RUN_CYCLES; k = k + 1)
                @(negedge clk);

            ferr_end   = ferr_sum / WINDOW;
            settled    = (ferr_end < SETTLE_TOL) && (ferr_end > -SETTLE_TOL);
            false_lock = (lock_at > 0) && (ferr_at_lock > FALSE_LOCK_TOL
                                           || ferr_at_lock < -FALSE_LOCK_TOL);
            dropped    = settled && (drops != 0);
            misaligned = settled && (phase_abs_sum / WINDOW > PHASE_TOL_NS);
            acquired   = settled && !misaligned;
            ringing    = settled && (integ_max - integ_min > INTEG_PP_MAX);

            // full spec: lock < 1000 cycles, settles, dither within +/-62 mV
            // (old +/-2 6-bit codes), stays locked
            ok = (lock_at > 0) && (lock_at < LOCK_SPEC) && settled
                 && ((code_max - code_min) * V_LSB * 1000.0 <= DITHER_MAX_MV) && (drops == 0);
        end
    endtask

    // ------------------------------------------------------------------
    // Sweeps
    // ------------------------------------------------------------------
    integer c, kp, ki, ki_idx, off;
    integer errors = 0;
    integer false_locks = 0;
    integer known = 0;
    integer cap_lo, cap_hi;
    reg     below_ok, above_ok;
    reg     enforce;
    reg [8*2-1:0]   cname;
    reg [8*7-1:0]   lock_str;
    reg [8*48-1:0]  flag_str;
    reg [8*160-1:0] grid;   // 4 chars per cell, up to 40 cells
    reg [8*4-1:0]   gcell;

    initial begin
        $dumpfile("tb_pll_closed_loop.vcd");
        $dumpvars(0, tb_pll_closed_loop);
        $dumpoff;   // full sweep is long; flip to $dumpon to look at one run

        // ---------------- Sweep 1: corners x all gain settings ----------------
        $display("");
        if (ONE_SIDED_KP) $display("Proportional kick: one-sided (late only)");
        else              $display("Proportional kick: symmetric (+/-Kp)");
        $display("Sweep 1: corners x KP_SEL x KI_SEL");
        $display("corner | f@mid  | KP KI | lock_at | ferr@lock | ferr_end | dither  mV | integ p-p | drops | |phase| avg/max ns | spec");
        $display("-------+--------+-------+---------+-----------+----------+------------+-----------+-------+----------------------+-----");

        for (c = 0; c < N_CORNERS; c = c + 1) begin
            tab_idx = c;
            scale   = 1.0;
            case (c)
                0: cname = "tt";
                1: cname = "ss";
                2: cname = "ff";
            endcase
            for (kp = 0; kp < 4; kp = kp + 1) begin
                for (ki = 0; ki < 4; ki = ki + 1) begin
                    enforce = ((c == 0) || (STRICT_CORNERS != 0)) && (kp <= MAX_ENFORCED_KP) && (ki <= MAX_ENFORCED_KI);
                    do_run(kp, ki);

                    if (false_lock) false_locks = false_locks + 1;

                    flag_str = "";
                    if (!settled || false_lock || dropped || misaligned || ringing) begin
                        if (enforce) begin
                            errors = errors + 1;
                            flag_str = "  <-- ERROR:";
                        end else begin
                            known = known + 1;
                            flag_str = "  KNOWN ISSUE:";
                        end
                        if (!settled)   flag_str = {flag_str, " no-acquire"};
                        if (false_lock) flag_str = {flag_str, " false-lock"};
                        if (dropped)    flag_str = {flag_str, " lock-drop"};
                        if (misaligned) flag_str = {flag_str, " phase"};
                        if (ringing)    flag_str = {flag_str, " ringing"};
                    end

                    if (lock_at > 0) $sformat(lock_str, "%0d", lock_at);
                    else             lock_str = "never";

                    $display("  %s   | %5.1f  |  %0d  %0d | %7s | %+8.2f%% | %+7.3f%% | %3d %5.0f  | %9.2f | %5d |    %5.1f / %5.1f    | %s%0s",
                             cname, fvco_of(7'd64) / 1e6, kp, ki, lock_str,
                             ferr_at_lock * 100.0, ferr_end * 100.0,
                             code_max - code_min, (code_max - code_min) * V_LSB * 1000.0,
                             integ_max - integ_min, drops,
                             phase_abs_sum / WINDOW, phase_maxabs,
                             ok ? "ok" : "--", flag_str);
                end
            end
        end

        // ---------------- Sweep 2: capture range ----------------
        $display("");
        $display("Sweep 2: capture range (tt table scaled by the given %%; real ss/ff mid-code offsets are ~-32 %% / +29 %%)");
        tab_idx = 0;
        $display("  o = acquired   f = acquired, but LOCK rose early (false lock)   x = never acquired");
        grid = "";
        for (off = -CAP_MAX_PCT; off <= CAP_MAX_PCT; off = off + CAP_STEP_PCT) begin
            $sformat(gcell, "%4d", off);
            grid = {grid, gcell};
        end
        $display("KP KI |%0s | capture", grid);

        for (kp = 0; kp < 4; kp = kp + 1) begin
            for (ki_idx = 0; ki_idx < 2; ki_idx = ki_idx + 1) begin
                ki     = ki_idx * 3;          // KI_SEL 0 and 3
                grid   = "";
                cap_lo = 0;
                cap_hi = 0;
                below_ok = 1'b1;
                above_ok = 1'b1;

                // one run per offset, left to right; one character per cell
                for (off = -CAP_MAX_PCT; off <= CAP_MAX_PCT; off = off + CAP_STEP_PCT) begin
                    scale = 1.0 + off / 100.0;
                    do_run(kp, ki);
                    if (!acquired)       gcell = "   x";
                    else if (false_lock) gcell = "   f";
                    else                 gcell = "   o";
                    grid = {grid, gcell};
                end

                // contiguous capture range around 0 %, read back from the grid
                for (off = 0; off <= CAP_MAX_PCT; off = off + CAP_STEP_PCT) begin
                    // grid gcell for +off and -off: index from the right end
                    if (above_ok && grid[8*((CAP_MAX_PCT - off) / CAP_STEP_PCT * 4) +: 8] != "x")
                        cap_hi = off;
                    else
                        above_ok = 1'b0;
                    if (below_ok && grid[8*((CAP_MAX_PCT + off) / CAP_STEP_PCT * 4) +: 8] != "x")
                        cap_lo = -off;
                    else
                        below_ok = 1'b0;
                end

                // enforced rows: full capture range, and no false lock anywhere
                flag_str = "";
                if (kp <= MAX_ENFORCED_KP && ki <= MAX_ENFORCED_KI) begin
                    if (cap_lo > -CAP_MIN_PCT || cap_hi < CAP_MIN_PCT) begin
                        errors = errors + 1;
                        flag_str = {flag_str, "  <-- ERROR: capture below +/-CAP_MIN_PCT"};
                    end
                    for (off = 0; off <= 2 * CAP_MAX_PCT / CAP_STEP_PCT; off = off + 1)
                        if (grid[8*(off * 4) +: 8] == "f") begin
                            errors = errors + 1;
                            flag_str = {flag_str, "  <-- ERROR: false lock"};
                        end
                end else begin
                    flag_str = "  (reported only)";
                end

                $display(" %0d  %0d |%0s | %+0d%% .. %+0d%%%0s", kp, ki, grid, cap_lo, cap_hi, flag_str);
            end
        end
        scale = 1.0;

        $display("");
        $display("false locks (sweep 1): %0d   known issues (not enforced): %0d   errors: %0d",
                 false_locks, known, errors);
        if (errors == 0) begin
            $display("PASS");
            $finish;
        end else begin
            $fatal(1, "FAILED with %0d errors", errors);
        end
    end

endmodule

`default_nettype wire
