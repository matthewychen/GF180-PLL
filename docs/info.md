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
- **6-bit DAC:** converts the code to a control voltage between about 0.4 V and 1.4 V (about 16 mV per code).
- **Ring-oscillator VCO:** runs at 80 MHz when the loop is locked. Its tuning range is about 50 to 110 MHz, roughly 1 MHz per code.
- **Feedback divider:** divides the VCO clock by 8 and feeds it back to the phase detector. The divided clock is also brought out on `uo_out[0]`.

A **lock detector** watches the EARLY stream. While the loop is acquiring frequency, the phase detector makes long runs of identical decisions. Once the loop is locked, the decisions dither back and forth. LOCK goes high after 256 consecutive reference cycles in which no run of identical decisions was longer than 8. It drops again as soon as a longer run appears.

## How to test

1. Apply a 10 MHz clock to `clk` and pulse `rst_n` low, then release it.
2. Set the loop gains with `ui_in[5:4]` (KP_SEL) and `ui_in[7:6]` (KI_SEL).
3. Watch `uo_out[1]` (LOCK). It should go high within about 1000 reference cycles (100 µs).
4. Once locked, `uo_out[0]` (CLK_OUT) is a 10 MHz clock that is phase-aligned with `clk`. Compare the two on an oscilloscope to check alignment and jitter.
5. Try different KP_SEL and KI_SEL settings and compare lock time and jitter.
6. Probe `ua[0]` (VCTRL, the DAC output that tunes the VCO) with a high-impedance probe. When the loop is locked it should settle to a near-constant voltage, with a small dither.

## External hardware

None. You need a 10 MHz clock source and an oscilloscope to observe CLK_OUT, LOCK and VCTRL.
