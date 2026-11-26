/*
 * Copyright (c) 2026 Mathew Hanson
 * SPDX-License-Identifier: Apache-2.0
 *
 * Analog project: behavioural black box for the TT harness.
 * The real circuit is the hardened macro in gds/ + lef/ (see info.yaml top_module).
 *
 * Analog pin map (ua[], met4, bottom edge of the 1x2 tile):
 *   ua[0] = vinp   amp non-inverting input
 *   ua[1] = vinn   amp inverting input
 *   ua[2] = voutp  amp non-inverting output
 *   ua[3] = voutn  amp inverting output
 *   ua[4] = i_trim  dedicated bias-current trim injection (final design; +1 pin)
 *   ua[5] = (unused)
 *
 * Note: final design adds 10 kOhm series resistors between ua[0]/ua[1] and the M1/M2 gates.
 *
 * Supply: VDPWR = 1.8 V, VGND = 0 V. The 1.2 V amplifier rail is produced
 * on-chip by the reference/LDO block; no VAPWR used.
 */

`default_nettype none

module tt_um_bomu_mthanson1 (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8v power supply
//    input  wire       VAPWR,    // 3.3v power supply (unused)
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

    // Purely analog block: drive all digital outputs to a defined state.
    assign uo_out  = 8'b0;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Silence unused-input warnings in the harness build.
    wire _unused = &{ena, clk, rst_n, ui_in, uio_in, VGND, VDPWR, 1'b0};

endmodule
