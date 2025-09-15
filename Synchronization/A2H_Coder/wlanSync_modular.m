% wlanSync Modular Decomposition
% R5: Orchestrator has ONLY module calls, parameter extraction, splitter copies
%
% @ARCHITECTURE: 5 modules, 2 FSMs (M2, M4)
% @FP-TOPO-OPT: FSM count = 2 (minimum achievable)
% @FP-DECOMP: All streams fixed-length, control separated

function [correctedWaveform, coarseFreqOff, fineFreqOff] = wlanSync_modular(inputWaveform, num_samples, filterCoeffs, numTaps, lstfLen, lltfLen, fs)
%#codegen

    % Module 0: Pre-filter (51-tap FIR lowpass)
    % @CSR: ~1 (dense, every sample)
    % @FSM: NO
    % @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
    [filteredWaveform, filteredLen] = module0_prefilter(inputWaveform, num_samples, filterCoeffs, numTaps);

    % Module 1: Packet Detection (L-STF autocorrelation)
    % @CSR: ~1 (sliding window on every sample)
    % @FSM: NO (produces startOffset, does not consume async control)
    [m1_data_out, startOffset] = module1_packet_detect(filteredWaveform, filteredLen, lstfLen);

    % @SPLITTER: m1_data_out -> [m2_data_in, m4_data_in]
    % FP-SPLIT: Same data to 2 consumers, inline copy
    m2_data_in = m1_data_out;
    m4_data_in = m1_data_out;

    % Module 2: Coarse CFO Estimation + Frequency Correction + Search Buffer Extraction
    % @CSR: ~1 passthrough, high for CFO compute (144 from full stream)
    % @FSM: YES (async startOffset input)
    % @FP-TOPO-OPT: Dual-output APPLY emits search_buffer (pre-sliced for M3)
    [searchBuffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo(m2_data_in, filteredLen, startOffset, lstfLen, lltfLen, fs);

    % Module 3: Fine Symbol Timing (L-LTF cross-correlation)
    % @CSR: ~1 within fixed-length search buffer
    % @FSM: NO (receives fixed-length stream from M2 dual-output)
    % @FP-CORR: 160-tap cross-correlation -> hls::FIR IP required (>16 taps)
    fineOffset = module3_fine_sync(searchBuffer, searchBufferLen, lltfLen);

    % Module 4: Fine CFO Estimation + Final Frequency Correction
    % @CSR: High (buffers ~26000 samples, extracts at combined offset)
    % @FSM: YES (async startOffset + fineOffset inputs)
    [correctedWaveform, fineFreqOff] = module4_fine_cfo_apply(m4_data_in, filteredLen, startOffset, fineOffset, lstfLen, lltfLen, fs);

end
