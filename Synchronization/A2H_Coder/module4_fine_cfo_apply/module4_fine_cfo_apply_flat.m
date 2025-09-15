% Module 4: Fine CFO Estimation + Final Frequency Correction - Flattened
% @CSR: 1.0 (stream-through with buffering, processes all samples from combined offset)
% @FSM: YES (two async control inputs: startOffset, fineOffset)
% @FP-ASYNC: Circular buffer + FSM for both control inputs
% @FP-OFFSET-CHAIN: combined_offset = startOffset + fineOffset (ABS + REL = ABS)
%
% Flattened: vectorized exp() replaced with cos/sin per sample
% Accuracy target: < 1e-10 vs original module

function [corrected_out, fineFreqOff] = module4_fine_cfo_apply_flat(data_in, num_samples, startOffset, fineOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;                      % FFT length for 20 MHz
    M = fftLen;                       % Repetition period = 64 (L-LTF)
    GI = fftLen / 2;                  % Guard interval = 32
    corrOffset = 0.75;                % Correlation offset fraction

    % EXTRACT: Re-extract at combined offset
    % @FP-OFFSET-CHAIN: fineOffset is RELATIVE to startOffset
    combined_offset = startOffset + fineOffset;
    rxLen = num_samples - combined_offset;

    % EXTRACT: Get L-LTF portion for fine CFO estimation
    ltfStart = 10 * lstfLen;  % = 160
    ltfLen = lltfLen * 2;     % = 320

    % COMPUTE: Fine CFO estimation
    offset = round(corrOffset * GI);  % = 24
    S = M * 2;                         % = 128 (useful part)
    useLen = min(S, ltfLen - offset);

    unused_samples = mod(useLen, M);
    corrLen = useLen - M - unused_samples;

    % Dot product: C = sum(conj(cx[n]) * sx[n])
    C = complex(0, 0);
    for n = 1:corrLen
        cx_idx = combined_offset + ltfStart + offset + n;
        sx_idx = combined_offset + ltfStart + offset + M + n;
        C = C + conj(data_in(cx_idx)) * data_in(sx_idx);
    end
    fineFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: Final frequency correction
    corrected_out = complex(zeros(rxLen, 1));
    for n = 1:rxLen
        t = (n - 1) / fs;
        phase = 2 * pi * fineFreqOff * t;
        correction = complex(cos(phase), sin(phase));
        corrected_out(n) = data_in(combined_offset + n) * correction;
    end

end
