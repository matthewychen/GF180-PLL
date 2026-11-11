# Layout (custom GDS)

This is an analog / mixed-signal Tiny Tapeout project, so the whole tile is a hand-made layout.
CI (`.github/workflows/gds.yaml`) picks it up from:

- `gds/tt_um_ding_dong_pll.gds`
- `lef/tt_um_ding_dong_pll.lef`

The GDS, precheck and viewer jobs are skipped until both files exist.

## Starting point

- Template: `tt_analog_1x2.def` from
  [tt-support-tools/tech/gf180mcuD/def/analog](https://github.com/TinyTapeout/tt-support-tools/tree/main/tech/gf180mcuD/def/analog).
  The tile size and `analog_pins` in `info.yaml` must match the template you use.
- PDK: `gf180mcuD`. VDPWR is 3.3 V. GF180 has no 1.8 V devices.
- Pins must match the port list in `src/project.v`. Tie unused digital outputs to VGND.
- Only connect metal to `ua[0]`, because `analog_pins: 1`. Precheck fails if `ua[1..5]` touch any metal.

## Exporting from Magic

```tcl
lef write ../lef/tt_um_ding_dong_pll.lef -pinonly
gds write ../gds/tt_um_ding_dong_pll.gds
```

Do not flatten the `.mag` file. Make sure your Magic version matches the PDK.
See the [Tiny Tapeout analog specs](https://tinytapeout.com/specs/analog/).
