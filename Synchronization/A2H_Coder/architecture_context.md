# wlanSync Architecture Context

## Algorithm Overview

WLAN 802.11 time and frequency synchronization pipeline.
Input: received complex baseband waveform (num_samples ~ 26130 complex samples at 20 MHz).
Output: synchronized, frequency-corrected waveform + coarse/fine CFO estimates.

## System Parameters

| Parameter | Value | Source |
|-----------|-------|--------|
| lstfLen (per L-STF symbol) | 16 | wlanConfig.lstfLen |
| L-STF total | 160 | 10 * lstfLen |
| lltfLen (total L-LTF) | 160 | wlanConfig.lltfLen |
| FFTLen | 64 | 64 * Fs/20e6 |
| cpLength | 16 | FFTLen/4 |
| corrLen | 64 | wlanConfig.corrLen |
| Pre-filter taps | 51 | firpm design |
| L-LTF reference (fine sync) | 160 taps | wlan.internal.legacyLTF |
| Search buffer (fine sync) | 640 | lstfLen*10 + lltfLen*3 |
| LTF extract (fine CFO) | 320 | lltfLen*2 |
| Input waveform length | ~26130 | tx + timeOffset + filter padding |
| Filtered length | ~26080 | num_samples - numTaps + 1 |
| Coarse CFO S (useful L-STF) | 144 | cpLength * 9 |
| Coarse CFO M (repetition period) | 16 | fftLen/4 |
| Fine CFO M (repetition period) | 64 | fftLen |
| Sample rate | 20 MHz | wlanConfig.Fs |
| Target FPGA | xc7z020clg400-1 | Zynq-7020 |

## Module Decomposition

### Module 0: prefilter
- **Function**: FIR lowpass filter (51-tap) with input truncation
- **Input**: raw_in[num_samples] (complex)
- **Output**: filtered_out[filteredLen] (complex), filteredLen (control)
- **Control OUT**: filteredLen (output length)
- **CSR**: ~1 (every sample processed)
- **FSM**: NO (no async control input)
- **FP-CORR**: 51-tap FIR -> BLOCKING: must use hls::FIR IP (>16 taps)
- **FP-SYMCOEFF**: Check filter coefficient symmetry in Phase 6

### Module 1: packet_detect
- **Function**: L-STF autocorrelation-based packet detection
- **Input**: filtered_in[filteredLen] (complex)
- **Output**: filtered_out[filteredLen] (complex passthrough), startOffset (control)
- **Control OUT**: startOffset (integer, absolute position in stream)
- **CSR**: ~1 (sliding autocorrelation on every sample)
- **FSM**: NO (produces control, does not consume async control)

### Module 2: coarse_cfo
- **Function**: Coarse CFO estimation + frequency correction + search buffer extraction
- **Input**: filtered_in[filteredLen] (complex), startOffset (control)
- **Output**: search_buffer[640] (complex, fixed-length), coarseFreqOff (control), searchBufferLen (control)
- **Control IN**: startOffset (ASYNC from M1)
- **Control OUT**: coarseFreqOff (Hz), searchBufferLen
- **CSR**: ~1 for passthrough, high for CFO estimate (144 samples from full stream)
- **FSM**: YES (async startOffset input)
- **FP-TOPO-OPT**: Dual-output APPLY emits search_buffer (pre-sliced for M3)

### Module 3: fine_sync
- **Function**: L-LTF cross-correlation for fine symbol timing
- **Input**: search_buffer[640] (complex, fixed-length)
- **Output**: fineOffset (control)
- **Control OUT**: fineOffset (integer, relative to search buffer start)
- **CSR**: ~1 within search buffer (correlation at every position)
- **FSM**: NO (receives fixed-length stream, no async control input)
- **FP-CORR**: 160-tap cross-correlation with fixed L-LTF reference -> BLOCKING: must use hls::FIR IP

### Module 4: fine_cfo_apply
- **Function**: Re-extract at combined offset, estimate fine CFO, apply final correction
- **Input**: filtered_in[filteredLen] (complex, from splitter), startOffset (control), fineOffset (control)
- **Output**: corrected_out[outputLen] (complex), fineFreqOff (control)
- **Control IN**: startOffset (ASYNC from M1), fineOffset (ASYNC from M3)
- **Control OUT**: fineFreqOff (Hz)
- **CSR**: High (buffers ~26000 samples, processes from combined offset onward)
- **FSM**: YES (two async control inputs: startOffset and fineOffset)
- **FP-OFFSET-CHAIN**: combined_offset = startOffset + fineOffset (ABS + REL = ABS)

## Dependency Graph - Nodes

| Node | Module | CSR | FSM | Description |
|------|--------|-----|-----|-------------|
| M0 | module0_prefilter | ~1 | NO | FIR lowpass filter (51-tap) |
| M1 | module1_packet_detect | ~1 | NO | L-STF autocorrelation detection |
| M2 | module2_coarse_cfo | ~1 | YES | Coarse CFO + freq correction + search buffer |
| M3 | module3_fine_sync | ~1 | NO | L-LTF cross-correlation (160-tap) |
| M4 | module4_fine_cfo_apply | high | YES | Fine CFO + final correction |

## Dependency Graph - Edges

| Edge | From | To | Type | Signal | Depth |
|------|------|----|------|--------|-------|
| E0 | M0 | M1 | DATA | filtered_out[filteredLen] | 64 |
| E1 | M1 | M2 | DATA | filtered_out[filteredLen] | 64 |
| E2 | M2 | M4 | DATA | passthrough_out[filteredLen] | 2048 |
| E3 | M1 | M2 | CTRL | startOffset | 4 |
| E4 | M2 | M4 | CTRL | startOffset_fwd | 4 |
| E5 | M2 | M3 | DATA | search_buffer[640] | 1024 |
| E6 | M3 | M4 | CTRL | fineOffset | 4 |
| E7 | M2 | OUT | CTRL | coarseFreqOff | 4 |
| E8 | M4 | OUT | DATA | corrected_out[outputLen] | N/A |
| E9 | M4 | OUT | CTRL | fineFreqOff | 4 |

## Test Vector Files

| Edge ID | Filename | Samples | Format | Direction |
|---------|----------|---------|--------|-----------|
| E0 | system_input.txt | 26155 | complex | IN |
| E1 | m0_output.txt | 26105 | complex | DATA |
| E2 | m1_data_out.txt | 26105 | complex | DATA |
| E3 | m1_startOffset.txt | 1 | integer | CTRL |
| E4 | m2_search_buffer.txt | 640 | complex | DATA |
| E5 | m2_coarseFreqOff.txt | 1 | float | CTRL |
| E6 | m3_fineOffset.txt | 1 | integer | CTRL |
| E7 | m4_corrected_out.txt | 26030 | complex | DATA |
| E8 | m4_fineFreqOff.txt | 1 | float | CTRL |
| E9 | filter_coeffs.txt | 51 | float | CFG |
| E10 | lltf_fir_coeffs.txt | 160 | complex | CFG |

## Topology: M2-Hub (no splitter)

M2 acts as data hub: receives data from M1, passes through to M4 at II=1, and extracts search buffer for M3. No splitter needed. M2 also forwards startOffset to M4.

## FP-TOPO-OPT Analysis

- **FSM count**: 2 (M2 receives startOffset async, M4 receives startOffset + fineOffset async)
- **Minimum achievable**: 2 (M4 fundamentally needs to buffer raw data until combined offset is known)
- **M2 dual-output APPLY**: Emits search_buffer (pre-sliced 640 samples) for M3, eliminating M3's need for FSM

## Offset Semantics (FP-OFFSET-CHAIN)

| Signal | Producer | Consumer | Type | Meaning |
|--------|----------|----------|------|---------|
| startOffset | M1 | M2, M4 | ABSOLUTE | Position in filtered stream where L-STF detected |
| coarseFreqOff | M2 | System output | VALUE | Coarse CFO estimate in Hz |
| fineOffset | M3 | M4 | RELATIVE | Offset within search buffer to L-LTF start |
| fineFreqOff | M4 | System output | VALUE | Fine CFO estimate in Hz |

**Combined offset in M4**: `combined_offset = startOffset + fineOffset` (ABSOLUTE + RELATIVE = ABSOLUTE)

## Resource Estimates

| Module | DSP Driver | BRAM Driver | Key Optimization |
|--------|-----------|-------------|------------------|
| M0 | 51-tap FIR (hls::FIR IP) | Coefficient storage | FP-SYMCOEFF if symmetric |
| M1 | Autocorrelation (multiply-accumulate) | Circular buffer (~160 samples) | FP-SPLITACC, FP-PIPEREG |
| M2 | CFO accumulation + NCO | Early buffer (2048 samples) | FP-NCOQUARTER for NCO, passthrough hub |
| M3 | 160-tap FIR (hls::FIR IP) | Coefficient storage | FP-CORR (3-FIR Karatsuba) |
| M4 | CFO accumulation + NCO | Circular buffer (8192 samples) | FP-NCOQUARTER for NCO |

## Phase 4 Optimizations

| Module | Optimization | FP Rule | Description |
|--------|-------------|---------|-------------|
| M0 | Waiver (FIR IP) | FP-CORR | 51-tap FIR inherent O(N*L), maps to hls::FIR IP |
| M1 | Sliding window | FP-MATOPT1 | Incremental add/remove replaces recomputation |
| M1 | Division avoidance | FP-MATOPT2 | abs(CS)^2 > T * PS^2 instead of Mn = abs(CS)^2/PS^2 > T |
| M2 | Phase accumulator | FP-MATOPT3 | NCO replaces per-sample cos/sin |
| M3 | Waiver (FIR IP) | FP-CORR | 160-tap cross-correlation inherent O(N*L), maps to hls::FIR IP |
| M4 | Phase accumulator | FP-MATOPT3 | NCO replaces per-sample cos/sin |

## Buffer Justifications (FP-STREAM)

| Entry | Buffer | Justification |
|-------|--------|---------------|
| buffer_justified: module4_fine_cfo_apply | 8192 | fineOffset arrives during data reception (~cycle 7200) with M2 inline CFO. M4 buffers until fineOffset received (gap ~7100 < 8192), then APPLY reads from buffer while draining remaining data_in. Streaming APPLY eliminates 2-pass overhead. |

## Critical Path Analysis

The critical integration path is: M0 -> M1 -> M2(hub) -> [M3, M4].
M2 passes through data to M4 at II=1 while extracting search buffer for M3.
M4 buffers in a circular buffer (8192) until fineOffset arrives (~cycle 7200),
then reads from buffer while draining remaining data_in (streaming APPLY).
