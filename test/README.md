# Sample testbench for a Tiny Tapeout project

This is a sample testbench for a Tiny Tapeout project. It uses [cocotb](https://docs.cocotb.org/en/stable/) to drive the DUT and check the outputs.
See below to get started or for more information, check the [website](https://tinytapeout.com/hdl/testing/).

## Setting up

1. Edit [Makefile](Makefile) and modify `PROJECT_SOURCES` to point to your Verilog files.
2. [tb.v](tb.v) instantiates the top module `tt_um_ding_dong_pll`. Keep it in sync if the top module is renamed.

## How to run

To run the RTL simulation:

```sh
make -B
```

To run gatelevel simulation, first harden your project and copy `../runs/wokwi/results/final/verilog/gl/{your_module_name}.v` to `gate_level_netlist.v`.

Then run:

```sh
make -B GATES=yes
```

If you wish to save the waveform in VCD format instead of FST format, edit tb.v to use `$dumpfile("tb.vcd");` and then run:

```sh
make -B FST=
```

This will generate `tb.vcd` instead of `tb.fst`.

## How to view the waveform file

Using GTKWave

```sh
gtkwave tb.fst tb.gtkw
```

Using Surfer

```sh
surfer tb.fst
```

# Block-level testbenches (unit tests)

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
`tb.v` is the cocotb top-level harness, and it's tested separately by `make` and the `test` workflow.

Add your design files to `source_files` in `info.yaml` and `PROJECT_SOURCES` in `test/Makefile` once
they're instantiated from the top module.
