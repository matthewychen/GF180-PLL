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
2. Create `test/tb_<block>.v` whose top module is named `tb_<block>`, the same as the file name.
   It's compiled together with every file in `src/`, so it can instantiate any module there.
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

## Top-level / closed-loop simulation

This is a custom-GDS (analog) project. `src/project.v` is only a port stub, so there's no top-level
RTL to simulate yet. The template's cocotb harness was removed for that reason. The planned
closed-loop test wraps the digital core (PFD, PI filter, divider, lock detector) with a behavioral
DAC and VCO model, and goes here as `test/tb_<name>.v` (or a cocotb test) once the core exists.
`requirements.txt` keeps cocotb available for it.
