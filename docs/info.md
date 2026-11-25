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
- **Digital PI loop filter:** turns the stream of EARLY decisions into a 7-bit control code. The proportional gain (Kp) and integral gain (Ki) each have 4 settings, selected from input pins. The proportional kick is one-sided: the code is the integrator plus Kp when the VCO is late, and the integrator alone when it is early. The integrator resets to mid-code (64).
- **7-bit DAC:** converts the code to a control voltage between 0 V and 1.95 V (about 15.5 mV per code). A higher code gives a lower voltage.
- **Ring-oscillator VCO:** runs at 80 MHz when the loop is locked. Its frequency falls as the control voltage rises, so a higher code gives a faster VCO, about 1 MHz per DAC code.
- **Feedback divider:** divides the VCO clock by 8 and feeds it back to the phase detector. The divided clock is also brought out on `uo_out[0]`.

The phase detector's decision is synchronized on the falling edge of `clk` before the filter uses it. That protects against metastability without adding a cycle of loop delay.

A **frequency-acquisition helper** handles large frequency errors, which the phase detector can't see. Every 32 reference cycles it counts VCO cycles (256 expected at 80 MHz). If the count is more than about 2.3% off, it nudges the filter's integrator two codes (about 2.5%) in the right direction. Once the VCO is close, the bang-bang loop finishes the lock.

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
| DAC | 6-bit, 0.4–1.4 V, ~16 mV/code | 7-bit, 0–1.95 V, ~15.5 mV/code |
| Frequency step | ~1 MHz per code | ~1 MHz per code |
| Proportional kick | ±Kp | +Kp when late, 0 when early (one-sided) |

An earlier version used a 6-bit DAC over the same 0–1.95 V range (~31 mV, ~2 MHz per code) with a symmetric ±Kp kick.
Each locked dither jump was then 2 codes, about 4 MHz, which smeared the VCO spectrum into a ±4 MHz hump around 80 MHz.
The 7-bit DAC halves the step, and the one-sided kick halves the number of codes per jump, so each jump is now about
1 MHz. The one-sided kick is a parameter (`ONE_SIDED_KP` in `pi_filter` / `pll_digital`); 0 restores the symmetric kick.

### Note: loop gain and dither

A bang-bang loop never sits still. Every reference cycle it nudges the DAC code up or down by the proportional step Kp,
so the code always dithers around the locked value. The size of that dither is set by Kp. In behavioral simulation
(`test/tb_pll_closed_loop.v`, tt corner, Matthew's VCO table, one-sided kick) the locked behavior is:

| KP_SEL | Kp step | Code dither (max − min) | Within ±62 mV (old ±2-code spec) | CLK_OUT phase error (mean / max) |
|---|---|---|---|---|
| 0 | 1 code  | 2 (31 mV)  | yes | ~1.5 ns / ~3 ns |
| 1 | 2 codes | 3 (46 mV)  | yes | ~1.3 ns / ~3.4 ns |
| 2 | 4 codes | 5 (77 mV)  | yes | ~2 ns / ~5 ns |
| 3 | 8 codes | 9 (139 mV) | no  | ~5 ns / ~11 ns |

KP_SEL = 0 is the intended operating point. The larger settings are kept for experiments: they pull in from further away,
but dither more. Common ways to reduce dither further, such as gear shifting or a finer proportional tuning path, were
considered and not implemented.

### Frequency acquisition

The phase detector samples the feedback clock, so on its own it can't detect a frequency error. Without help, the loop only
pulled in when the VCO started within about −8% to +12% of 80 MHz. Outside that range it never locked, and the lock
detector falsely raised LOCK. The frequency-acquisition helper (`src/freq_acq.v`) fixes both. In simulation, KP_SEL 0–3 with
KI_SEL 0–2 lock at the tt, ss and ff corners (ss/ff are about −32% / +29% from tt) in under 900 reference cycles, with no
false LOCK. KI_SEL = 3 is too much integral gain for the small one-sided kick: at some corners it rings or never locks, so
it is for experiments only.

## External hardware

None. You need a 10 MHz clock source and an oscilloscope to observe CLK_OUT, LOCK and VCTRL.
