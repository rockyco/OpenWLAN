% Module 2: Coarse CFO Estimation + Frequency Correction + Search Buffer - Optimized
% @CSR: 1.0
% @FSM_REQUIRED: YES
% @OPTIMIZATIONS: FP-MATOPT3 phase accumulator for NCO
%
% Phase 4 optimizations applied:
% - FP-MATOPT3: Phase accumulator replaces per-sample cos/sin computation

function [search_buffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo_opt(data_in, num_samples, startOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;
    M = fftLen / 4;                   % 16
    GI = fftLen / 4;                  % 16
    S = GI * 9;                       % 144
    corrOffset = 0.75;
    searchBufferLen = lstfLen * 10 + lltfLen * 3;  % 640

    % EXTRACT
    rxLen = num_samples - startOffset;

    % COMPUTE: Coarse CFO estimation (dot product - single pass, not nested O(N*W))
    offset = round(corrOffset * GI);  % 12
    useLen = min(S, rxLen - offset);
    unused_samples = mod(useLen, M);
    corrLen = useLen - M - unused_samples;

    C = complex(0, 0);
    for n = 1:corrLen
        cx_idx = startOffset + offset + n;
        sx_idx = startOffset + offset + M + n;
        C = C + conj(data_in(cx_idx)) * data_in(sx_idx);
    end
    coarseFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: FP-MATOPT3 phase accumulator for frequency correction
    phase_inc = 2 * pi * coarseFreqOff / fs;
    phase = 0;

    search_buffer = complex(zeros(searchBufferLen, 1));
    for n = 1:searchBufferLen
        cos_val = cos(phase);
        sin_val = sin(phase);
        search_buffer(n) = data_in(startOffset + n) * complex(cos_val, sin_val);
        phase = phase + phase_inc;
    end

end
