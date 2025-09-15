% Module 0: Pre-Filter [FIR lowpass] - Optimized
% @CSR: 1.0
% @FSM_REQUIRED: NO
% @FP-CORR: 51-tap FIR -> hls::FIR IP required (>16 taps)
% @OPTIMIZATIONS: FIR inherent O(N*L), waivered for hls::FIR IP in Phase 5
%
% Phase 4: No incremental optimization possible for general FIR convolution.
% The nested loop structure is inherent to the algorithm and maps directly
% to hls::FIR IP in Phase 5. See module0_prefilter_p4_waiver.txt.

function [filtered_out, filteredLen] = module0_prefilter_opt(data_in, num_samples, filterCoeffs, numTaps)
%#codegen

    % Truncate input to remove tail artifacts
    filteredLen = num_samples - numTaps + 1;

    % FIR convolution: y[n] = sum_{k=0}^{numTaps-1} h[k] * x[n-k]
    % Inherent O(N*L) - maps to hls::FIR IP in Phase 5
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
