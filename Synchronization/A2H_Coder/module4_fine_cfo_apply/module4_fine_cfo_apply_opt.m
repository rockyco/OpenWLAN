% Module 4: Fine CFO Estimation + Final Frequency Correction - Optimized
% @CSR: 1.0
% @FSM_REQUIRED: YES
% @FP-OFFSET-CHAIN: combined_offset = startOffset + fineOffset (ABS + REL = ABS)
% @OPTIMIZATIONS: FP-MATOPT3 phase accumulator for NCO
%
% Phase 4 optimizations applied:
% - FP-MATOPT3: Phase accumulator replaces per-sample cos/sin computation

function [corrected_out, fineFreqOff] = module4_fine_cfo_apply_opt(data_in, num_samples, startOffset, fineOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;
    M = fftLen;                       % 64 (L-LTF repetition)
    GI = fftLen / 2;                  % 32
    corrOffset = 0.75;

    % EXTRACT: Re-extract at combined offset
    combined_offset = startOffset + fineOffset;
    rxLen = num_samples - combined_offset;

    % EXTRACT: L-LTF portion for fine CFO
    ltfStart = 10 * lstfLen;  % 160
    ltfLen = lltfLen * 2;     % 320

    % COMPUTE: Fine CFO estimation (dot product - single pass, not nested)
    offset = round(corrOffset * GI);  % 24
    S = M * 2;                         % 128
    useLen = min(S, ltfLen - offset);
    unused_samples = mod(useLen, M);
    corrLen = useLen - M - unused_samples;

    C = complex(0, 0);
    for n = 1:corrLen
        cx_idx = combined_offset + ltfStart + offset + n;
        sx_idx = combined_offset + ltfStart + offset + M + n;
        C = C + conj(data_in(cx_idx)) * data_in(sx_idx);
    end
    fineFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: FP-MATOPT3 phase accumulator for final frequency correction
    phase_inc = 2 * pi * fineFreqOff / fs;
    phase = 0;

    corrected_out = complex(zeros(rxLen, 1));
    for n = 1:rxLen
        cos_val = cos(phase);
        sin_val = sin(phase);
        corrected_out(n) = data_in(combined_offset + n) * complex(cos_val, sin_val);
        phase = phase + phase_inc;
    end

end
