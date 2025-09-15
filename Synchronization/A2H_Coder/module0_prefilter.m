% Module 0: Pre-filter (FIR lowpass)
% @CSR: 1.0 (dense, every sample processed)
% @FSM: NO
% @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
% @FP-SYMCOEFF: Check coefficient symmetry in Phase 6
%
% Interface: fixed-length input/output, no async control signals
% FP-DECOMP1: data_in is num_samples length (fixed), output is filteredLen (fixed)
% FP-DECOMP2: filteredLen is SEPARATE control output (output length)

function [filtered_out, filteredLen] = module0_prefilter(data_in, num_samples, filterCoeffs, numTaps)
%#codegen

    % Truncate input to remove filter tail artifacts
    % Original: inputWaveformRef = inputWaveform(1:end-numTaps+1)
    filteredLen = num_samples - numTaps + 1;
    truncated = data_in(1:filteredLen);

    % FIR filter: y[n] = sum_{k=0}^{numTaps-1} h[k] * x[n-k]
    filtered_out = filter(filterCoeffs, 1, truncated);

end
