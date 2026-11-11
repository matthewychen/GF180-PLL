<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a bang-bang phase-locked loop (PLL) that multiplies the 10 MHz reference clock on `clk` up to 80 MHz (N = 8).

The loop is made of five blocks:

- **Bang-bang phase-frequency detector:** once per reference cycle, it compares the reference clock with the divided-down VCO clock. It outputs a single bit, EARLY, which says whether the VCO edge arrived early (VCO too fast) or late (VCO too slow).
- **Digital PI loop filter:** turns the stream of EARLY decisions into a 6-bit control code. The proportional gain (Kp) and integral gain (Ki) each have 4 settings, selected from input pins. The integrator resets to mid-code (32).
- **6-bit DAC:** converts the code to a control voltage between 0 V and 2 V (about 31.7 mV per code).
- **Ring-oscillator VCO:** runs at 80 MHz when the loop is locked. Its gain is about 63 MHz/V, which works out to roughly 2 MHz per DAC code.
- **Feedback divider:** divides the VCO clock by 8 and feeds it back to the phase detector. The divided clock is also brought out on `uo_out[0]`.

The phase detector's decision is synchronized on the falling edge of `clk` before the filter uses it. That protects against metastability without adding a cycle of loop delay.

A **frequency-acquisition helper** handles large frequency errors, which the phase detector can't see. Every 32 reference cycles it counts VCO cycles (256 expected at 80 MHz). If the count is more than about 4% off, it nudges the filter's integrator one code in the right direction. Once the VCO is close, the bang-bang loop finishes the lock.

A **lock detector** watches the EARLY stream. While the loop is acquiring frequency, the phase detector makes long runs of identical decisions. Once the loop is locked, the decisions dither back and forth. LOCK goes high after 256 consecutive reference cycles in which no run of identical decisions was longer than 8 **and** the VCO count stayed within about 2% of 256. It drops as soon as either check fails. The count check stops LOCK from rising when the loop is far off frequency. In that case the beat between the two clocks also gives short runs.

## How to test

1. Apply a 10 MHz clock to `clk` and pulse `rst_n` low, then release it.
2. Set the loop gains with `ui_in[5:4]` (KP_SEL) and `ui_in[7:6]` (KI_SEL). **Use KP_SEL = 0 for normal operation.** It has the smallest dither and phase error (see the note below).
3. Watch `uo_out[1]` (LOCK). It should go high within about 1000 reference cycles (100 µs).
4. Once locked, `uo_out[0]` (CLK_OUT) is a 10 MHz clock that is phase-aligned with `clk`. Compare the two on an oscilloscope to check alignment and jitter.
5. Try different KP_SEL and KI_SEL settings and compare lock time and jitter. Larger KP_SEL settings lock in fewer cycles but dither more.
6. Probe `ua[0]` (VCTRL, the DAC output that tunes the VCO) with a high-impedance probe. When the loop is locked it should settle to a near-constant voltage, with a small dither.

### Design decisions (changes from the proposal)

| | Proposal | Now |
|---|---|---|
| Supply | 1.8 V | 3.3 V (GF180 has no 1.8 V devices) |
| DAC output | 0.4–1.4 V, ~16 mV/code | 0–2 V, ~31.7 mV/code |
| Frequency step | ~1 MHz per code | ~2 MHz per code (VCO gain × the wider DAC step) |

**The frequency step per code is about twice as coarse, so locked dither is coarser.** One DAC code is now about 2.5% of
80 MHz instead of about 1.2%. At KP_SEL = 0, the code dithers by about ±1 code around the locked value, so the VCO wanders
by about ±2 MHz from cycle to cycle. This was accepted to get the wider DAC range at 3.3 V.

### Note: loop gain and dither

A bang-bang loop never sits still. Every reference cycle it nudges the DAC code up or down by the proportional step Kp,
so the code always dithers around the locked value. The size of that dither is set by Kp. In behavioral simulation
(`test/tb_pll_closed_loop.v`, tt corner, ~2 MHz/code model) the locked behavior is:

| KP_SEL | Kp step | Code dither (max − min) | Meets ±2-code spec | CLK_OUT phase error (mean / max) |
|---|---|---|---|---|
| 0 | 1 code  | 2–3 | yes | ~2 ns / ~7 ns |
| 1 | 2 codes | 4   | yes | ~4.5 ns / ~8 ns |
| 2 | 4 codes | 8   | no  | ~9 ns / ~16 ns |
| 3 | 8 codes | 16  | no  | ~17.5 ns / ~29 ns |

KP_SEL = 0 is the intended operating point. The larger settings are kept for experiments: they pull in from further away,
but dither more. Common ways to reduce dither further, such as gear shifting or a finer proportional tuning path, were
considered and not implemented.

### Frequency acquisition

The phase detector samples the feedback clock, so on its own it can't detect a frequency error. Without help, the loop only
pulled in when the VCO started within about −8% to +12% of 80 MHz. Outside that range it never locked, and the lock
detector falsely raised LOCK. The frequency-acquisition helper (`src/freq_acq.v`) fixes both. In simulation, KP_SEL 0–2
now lock from anywhere in ±20%, with no false LOCK, in about 400–650 reference cycles at the ±20% corners. KP_SEL = 3
(8-code, ~16 MHz kicks) still fails occasionally and is for experiments only.

## External hardware

None. You need a 10 MHz clock source and an oscilloscope to observe CLK_OUT, LOCK and VCTRL.
