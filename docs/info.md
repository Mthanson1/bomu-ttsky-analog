## How it works

**BoMu** is a single-stage differential amplifier: a resistively-loaded NMOS
source-coupled pair (`vinp`/`vinn` into the gates of M1/M2, tail current source
below, poly resistor loads `R_D` to the supply, differential output taken across
the drains at `voutp`/`voutn`). Devices are sized by a $g_m/I_D$ methodology on
sky130A, with $L = 0.15\,\mu m$. The signed-off operating point targets:

| Parameter | Target | Signed-off |
|-----------|--------|-----------|
| Differential DC gain $A_{v0}$ | 10 dB | ~10.1 dB |
| Small-signal bandwidth $f_{-3\mathrm{dB}}$ | 150 MHz | ~155 MHz |
| Differential output swing | 400 mV$_{pp}$ | met |
| Core supply $V_{DD}$ | 1.2 V | 1.2 V |

The amplifier core is specified at a **1.2 V** rail. Tiny Tapeout supplies only
`VGND` (0 V) and `VDPWR` (1.8 V), so the final design derives the 1.2 V rail
on-chip from the 1.8 V supply. *This revision is a geometric slot-secure pass:*
the signed-off `bomu` core is placed in a 1×2 analog tile with met4 `VPWR`/`VGND`
straps and the four `ua[*]` analog pins; the on-chip 1.2 V regulator and the
final signal/supply routing land in the follow-up revision.

## How to test

Purely analog block — the digital interface (`ui_in`, `uo_out`, `uio_*`, `clk`,
`rst_n`) is unused and driven to a defined state. Use the analog pins:

| Pin | Signal | Role |
|-----|--------|------|
| `ua[0]` | `vinp` | amp non-inverting input |
| `ua[1]` | `vinn` | amp inverting input |
| `ua[2]` | `voutp` | amp non-inverting output |
| `ua[3]` | `voutn` | amp inverting output |

1. Power the tile from the 1.8 V `VDPWR` / `VGND` supply.
2. Apply a differential small-signal input across `ua[0]`/`ua[1]` at a valid
   input common-mode (the gates draw no DC current, so the CM is set externally).
3. Measure the differential output across `ua[2]`/`ua[3]`; sweep frequency to
   observe the ~10 dB gain and bandwidth.

**Pad bandwidth caveat:** each analog pad has a series analog switch (<500 Ω)
plus ~5 pF, giving a ~64 MHz pole *at the external pin*. The 150 MHz bandwidth is
present on-die but band-limited when observed off-chip through the pad.

Full design writeup, PVT/Monte-Carlo analysis, and LVS/DRC sign-off are in the
source design repository (`bomu-ieee-sscs`).

## External hardware

None required. Bench setup only: a DC supply for `VDPWR`, a signal/function
generator (or network analyzer) for the differential input, and an oscilloscope
or network analyzer on the differential output.
