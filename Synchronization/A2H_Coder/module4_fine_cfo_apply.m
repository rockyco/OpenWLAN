% Module 4: Fine CFO Estimation + Final Frequency Correction
% @CSR: 1.0 (stream-through with buffering, processes all samples from combined offset)
% @FSM: YES (two async control inputs: startOffset, fineOffset)
% @FP-ASYNC: Circular buffer + FSM for both control inputs
% @FP-OFFSET-CHAIN: combined_offset = startOffset + fineOffset (ABS + REL = ABS)
%
% Interface: fixed-length data input, two async control inputs, data + control outputs
% FP-DECOMP1: data_in is num_samples length (fixed)
% FP-DECOMP2: Control signals are SEPARATE
% FP-DECOMP4: output length derived from combined offset

function [corrected_out, fineFreqOff] = module4_fine_cfo_apply(data_in, num_samples, startOffset, fineOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;                      % FFT length for 20 MHz
    M = fftLen;                       % Repetition period = 64 (L-LTF)
    GI = fftLen / 2;                  % Guard interval = 32
    corrOffset = 0.75;                % Correlation offset fraction

    % EXTRACT: Re-extract at combined offset
    % @FP-OFFSET-CHAIN: fineOffset is RELATIVE to startOffset
    combined_offset = startOffset + fineOffset;
    rxWave3 = data_in(combined_offset + 1 : num_samples);
    rxLen = num_samples - combined_offset;

    % EXTRACT: Get L-LTF portion for fine CFO estimation
    % LTFs = rxWave3(10*lstfLen + (1 : lltfLen*2))
    ltfStart = 10 * lstfLen;  % = 160
    ltfLen = lltfLen * 2;     % = 320
    LTFs = rxWave3(ltfStart + (1 : ltfLen));

    % COMPUTE: Fine CFO estimation
    % Autocorrelate with delay M=64 (one L-LTF OFDM symbol)
    offset = round(corrOffset * GI);  % = 24
    S = M * 2;                         % = 128 (useful part)
    useLen = min(S, ltfLen - offset);
    use = LTFs(offset + (1:useLen));

    unused_samples = mod(useLen, M);
    cx = use(1 : useLen - M - unused_samples);
    sx = use(M + 1 : useLen - unused_samples);
    C = cx' * sx;
    fineFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: Final frequency correction to rxWave3
    t = (0 : rxLen - 1).' / fs;
    corrected_out = rxWave3 .* exp(1i * 2 * pi * fineFreqOff * t);

end
