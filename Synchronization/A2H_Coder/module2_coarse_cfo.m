% Module 2: Coarse CFO Estimation + Frequency Correction + Search Buffer Extraction
% @CSR: 1.0 for passthrough/correction (CFO compute hidden behind EXTRACT)
% @FSM: YES (async startOffset control input)
% @FP-TOPO-OPT: Dual-output APPLY - emits search_buffer (pre-sliced for M3)
% @FP-ASYNC: Circular buffer + FSM for startOffset
%
% Interface: fixed-length data input, async control input, dual output
% FP-DECOMP1: data_in is num_samples length (fixed), search_buffer is searchBufferLen (fixed)
% FP-DECOMP2: startOffset is SEPARATE control input, coarseFreqOff is SEPARATE control output
% FP-DECOMP4: searchBufferLen emitted as control (variable output length indicator)

function [search_buffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo(data_in, num_samples, startOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;                      % FFT length for 20 MHz
    M = fftLen / 4;                   % Repetition period = 16
    GI = fftLen / 4;                  % Guard interval = 16
    S = GI * 9;                       % Useful L-STF samples = 144
    corrOffset = 0.75;                % Correlation offset fraction
    searchBufferLen = lstfLen * 10 + lltfLen * 3;  % 640

    % EXTRACT: Get rxWave1 = data_in(startOffset+1 : end)
    rxWave1 = data_in(startOffset + 1 : num_samples);
    rxLen = num_samples - startOffset;

    % COMPUTE: Coarse CFO estimation
    % Extract L-STF portion with correlation offset
    offset = round(corrOffset * GI);  % = 12
    useLen = min(S, rxLen - offset);   % min(144, rxLen-12)
    use = rxWave1(offset + (1:useLen));

    % CFO estimate: autocorrelate with delay M, angle of sum
    % C = sum(conj(use[n+M]) * use[n])
    unused_samples = mod(useLen, M);
    cx = use(1 : useLen - M - unused_samples);
    sx = use(M + 1 : useLen - unused_samples);
    C = cx' * sx;  % Dot product (conjugate transpose for complex)
    coarseFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: Frequency correction to rxWave1
    t = (0 : rxLen - 1).' / fs;
    rxWave2 = rxWave1 .* exp(1i * 2 * pi * coarseFreqOff * t);

    % APPLY (dual output): Extract search buffer for M3
    % search_buffer = rxWave2(1 : searchBufferLen)
    search_buffer = rxWave2(1 : searchBufferLen);

end
