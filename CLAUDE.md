# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenWLAN is an AI-powered MATLAB-to-HLS framework demonstrating automated transformation of WLAN 802.11 time and frequency synchronization algorithms. The code in `Synchronization/A2H_Coder/` was 100% AI-generated through a 7-phase transformation pipeline. The `Synchronization/HDL_Coder/` directory contains the original MathWorks HDL Coder reference implementation.

## Architecture

The synchronization pipeline consists of 5 streaming HLS modules connected in series:

```
Input -> module0_prefilter -> module1_packet_detect -> module2_coarse_cfo -> module3_fine_sync -> module4_fine_cfo_apply -> Output
```

- **module0_prefilter**: 51-tap FIR lowpass filter
- **module1_packet_detect**: L-STF autocorrelation packet detection
- **module2_coarse_cfo**: Coarse carrier frequency offset estimation + frequency correction + search buffer extraction
- **module3_fine_sync**: L-LTF cross-correlation fine timing
- **module4_fine_cfo_apply**: Fine CFO estimation + final frequency correction

The integrated system lives in `system_wlanSync_integrated/` with `system_top.cpp` as the top-level entry point.

Each module directory contains three MATLAB transformation stages (`*_flat.m`, `*_opt.m`) and the final HLS C++ implementation (`.cpp`, `.hpp`).

## Build Commands (Vitis HLS 2024.2)

All HLS builds use the canonical Makefile present in each module directory. **Never create new Makefiles** - copy from `.claude/tools/Makefile` if one is missing and edit only `DESIGN_NAME`, `FPGA_PART`, and `SRC_FILES`.

Run from any module directory (e.g., `Synchronization/A2H_Coder/module0_prefilter/`):

```bash
make csim          # C simulation - functional verification
make csynth        # C synthesis - generate RTL
make cosim         # C/RTL co-simulation
make export_ip     # Export as Vivado IP
make impl          # Vivado implementation (place & route)
make tb            # Standalone G++ testbench (no Vitis required)
make gui           # Launch Vitis Unified IDE
make gui-wave      # Open waveform viewer
make report        # Show synthesis resource/timing report
make clean         # Remove build artifacts
```

Fixed-point mode (Phase 6): append `HLS_CFLAGS=-DPHASE6` to any target.

Hardware target: Zynq-7020 (`xc7z020clg400-1`) at 100 MHz.

## MATLAB Testing

From `Synchronization/A2H_Coder/` in MATLAB:

```matlab
wlanSync_tb                % Original algorithm testbench
wlanSync_modular_tb        % Modular implementation testbench (validates module separation)
wlanSync_testdata_generator % Regenerate test vectors in test_vectors/
```

Per-module MATLAB testbenches are in each module directory: `module*_flat_tb.m`, `module*_opt_tb.m`.

## Key Files

- `module_registry.json` - Module metadata, phase status, and post-synthesis resource metrics
- `architecture_context.md` - System parameters, dependency graph, buffer sizing rationale, critical path analysis
- `phase*_handoff.json` - Framework phase transition records
- `test_vectors/` - Golden reference data: `system_input.txt` (input), `m*_output.txt` / `m*_*.txt` (per-module expected outputs)
- `common_types_opt.hpp` - Shared fixed-point type definitions used across all HLS modules
- `*.inc` files - Precomputed LUT data (NCO sin/cos, arctangent) included by HLS sources

## Conventions

- Each module has a `*_COMPLETE.txt` completion marker and optional `*_waiver.txt` for phase exceptions
- Test data files use space-separated real/imaginary pairs for complex samples
- Module interfaces are defined in JSON definition files at the A2H_Coder root level
- The HDL_Coder directory is a read-only reference - do not modify it
