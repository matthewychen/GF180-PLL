# Tests

Each block (lock detector, PFD, PI filter, divider, ...) has its own plain-Verilog
testbench. CI (`.github/workflows/unit.yaml`) runs all of them, plus a Verilator
lint of `src/`, on every push and pull request.

## Running them

From the repo root:

```sh
test/run_unit_tests.sh                 # every testbench
test/run_unit_tests.sh lock_detector   # just test/tb_lock_detector.v
test/lint.sh                           # Verilator -Wall on every file in src/
```

Logs go to `test/sim_build/unit/`. Waveforms are written to `test/`. Open them with:

```sh
cd test && gtkwave tb_lock_detector.vcd tb_lock_detector.gtkw
```

## Adding a testbench for your block

1. Put your design in `src/<block>.v`. Lint picks it up automatically.
2. Create `test/tb_<block>.v` (or `.sv` for SystemVerilog) whose top module is named `tb_<block>`, the same as the file name.
   It's compiled together with every file in `src/`, so it can instantiate any module there.
   Keep each module in `src/<module_name>.v`. Lint finds submodules by file name.
   CI uses Icarus Verilog, so stick to what it supports (for example, no `continue` / `break` in loops).
3. At the end of the test, print exactly `PASS` on success, and call `$fatal` on failure:

   ```verilog
   if (errors == 0) begin
       $display("PASS");
       $finish;
   end else begin
       $fatal(1, "FAILED with %0d errors", errors);
   end
   ```

4. Optional: dump a waveform with `$dumpfile("tb_<block>.vcd")` and save a GTKWave layout as `test/tb_<block>.gtkw`.
5. Run `test/run_unit_tests.sh <block>` locally, then push. Nothing else needs registering.

A testbench fails CI if it doesn't compile, exits non-zero, runs longer than 300 s, or never prints `PASS`.

## Closed-loop simulation (`tb_pll_closed_loop.v`)

`src/pll_digital.v` is the digital core that gets hardened with OpenLane: phase detector,
synchronizer, PI filter, feedback divider, frequency-acquisition helper and lock detector. `tb_pll_closed_loop.v` wraps it with a
behavioral DAC and VCO model and sweeps every `KP_SEL`/`KI_SEL` setting at the tt, ss and ff corners.
For each run it prints lock time, frequency error, code dither and CLK_OUT phase alignment.

```sh
test/run_unit_tests.sh pll_closed_loop
cat test/sim_build/unit/tb_pll_closed_loop.log     # the results table
```

The DAC and VCO model is in `pll_analog_model.vh`: DAC VCTRL = 1.95 V − 30.9 mV × code, and Matthew's
simulated 5-point frequency-vs-VCTRL table per corner (linear between points). 80 MHz lands at about code 34
(tt), 45 (ss) and 20 (ff).

A second sweep prints a **capture-range grid**: the tt table scaled by −34 % … +34 %, and whether the loop still
locks to 80 MHz. `o` = locks, `f` = locks but LOCK rose too early, `x` = never locks.

CI enforces every corner and a ±30 % capture range for KP_SEL 0–2 with KI_SEL 0–2: no false LOCK, settles on
80 MHz, and phase-aligned. (At −34 % the tt table can't reach 80 MHz at all, so ±34 % can't be required.)
Printed but not enforced:

- KP_SEL = 3 (about 16 MHz kicks): false LOCK at ff with KI_SEL = 0.
- KI_SEL = 3: never acquires at ss / ff, and capture shrinks to about −24 % … +22 %. The integrator
  overshoots and the loop gets stuck near a 2/3 or 4/3 subharmonic. Open issue.

## Demo of the digital core (`tb_pll_demo.v`)

One run that walks through everything the digital side has to handle, with a `phase` signal to follow
along in GTKWave: 0 reset → 1 acquire from a slow chip → 2 hold lock → 3 VCO frequency jumps +12 % and the
loop recovers → 4 VCO stops and restarts → 5 reset while locked. Each phase is also checked, so it runs in
CI as a regression test.

```sh
test/run_unit_tests.sh pll_demo
cd test && gtkwave tb_pll_demo.vcd tb_pll_demo.gtkw     # then Time -> Zoom -> Zoom Best Fit
```

## Waveforms for GTKWave (`tb_pll_waves.v`)

One acquisition per corner (tt, ss, ff; KP_SEL = 0, KI_SEL = 0), back to back in a single VCD, with a
ready-made layout. The `corner` signal (0/1/2) shows which run is on screen; each run is 1200 reference
cycles (120 µs).

```sh
test/run_unit_tests.sh pll_waves
cd test && gtkwave tb_pll_waves.vcd tb_pll_waves.gtkw     # then Time -> Zoom -> Zoom Best Fit
```

The layout shows the clocks, EARLY, the DAC code and integrator, VCTRL, the modelled VCO frequency, the
`freq_acq` nudges and `freq_ok`, LOCK, and the CLK_OUT-vs-reference phase error. The code, VCTRL and
frequency traces are drawn as analog steps. If a trace shows as a bus instead, right-click it →
Data Format → Analog → Step.

The DAC/VCO model used by all three closed-loop testbenches lives in `pll_analog_model.vh` (Matthew's
VCO table and Hugh's DAC transfer), so there is one place to update when the analog numbers change.

`src/project.v` is only the port stub for the custom GDS, so it isn't simulated.
