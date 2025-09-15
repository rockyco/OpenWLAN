% Module 0: Pre-Filter [FIR lowpass] - Flattened
% @CSR: 1.0 (dense, every sample processed)
% @FSM: NO
% @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
% @FP-SYMCOEFF: Check coefficient symmetry in Phase 6
%
% Flattened: MATLAB FIR builtin replaced with explicit convolution loop
% Accuracy target: < 1e-10 vs original module

function [filtered_out, filteredLen] = module0_prefilter_flat(data_in, num_samples, filterCoeffs, numTaps)
%#codegen

    % Truncate input to remove filter tail artifacts
    filteredLen = num_samples - numTaps + 1;

    % FIR filter: y[n] = sum_{k=0}^{numTaps-1} h[k] * x[n-k]
    % Explicit sample-by-sample FIR computation
    filtered_out = complex(zeros(filteredLen, 1));

    for n = 1:filteredLen
        acc = complex(0, 0);
        for k = 1:numTaps
            idx = n - k + 1;
            if idx >= 1
                acc = acc + filterCoeffs(k) * data_in(idx);
            end
        end
        filtered_out(n) = acc;
    end

end
