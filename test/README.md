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

The DAC and VCO numbers at the top of the testbench are the updated design values: DAC 0–2 V and about
2 MHz per code. The VCO's absolute frequency is an assumption (code 32 = 80 MHz). Replace it with
Matthew's measured frequency-vs-VCTRL curve once it exists.

A second sweep prints a **capture-range grid**: how far the VCO can start from 80 MHz and still lock, for each
KP_SEL. `o` = locks, `f` = locks but LOCK rose too early, `x` = never locks.

CI enforces every corner and the full ±20% capture range for KP_SEL 0–2: no false LOCK, settles on 80 MHz, and
phase-aligned. KP_SEL = 3 (about 16 MHz kicks) is printed but not enforced.

`src/project.v` is only the port stub for the custom GDS, so it isn't simulated.
