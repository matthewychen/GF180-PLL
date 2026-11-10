/*
 * Copyright (c) 2026 Benjamin Dong, Gabe Hoh, Hugh Ding, Matthew Chen
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// Top-level port stub for the custom (analog) GDS.
//
// This is an analog / mixed-signal project: the real design is the hand-made
// layout in gds/tt_um_ding_dong_pll.gds. This file only declares the ports so
// Tiny Tapeout can wire the macro into the chip. It must stay an empty module
// whose ports match the layout's LEF pins.
//
// The digital blocks (PFD, PI filter, divider, lock detector) live in their
// own files in src/, are hardened separately with OpenLane, and are placed
// next to the DAC and VCO in the layout.
//
// Pinout (see info.yaml):
//   ui_in[5:4] KP_SEL   ui_in[7:6] KI_SEL
//   uo_out[0]  CLK_OUT  uo_out[1]  LOCK
//   ua[0]      VCTRL    (only ua[5:0] can be used)
// Unused outputs must be tied to VGND in the layout.

/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */
module tt_um_ding_dong_pll (
    input  wire       VGND,
    input  wire       VDPWR,    // 3.3v core power supply
//    input  wire       VAPWR,    // second analog power supply (VAA)
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

endmodule
/* verilator lint_on UNDRIVEN */
/* verilator lint_on UNUSED */
