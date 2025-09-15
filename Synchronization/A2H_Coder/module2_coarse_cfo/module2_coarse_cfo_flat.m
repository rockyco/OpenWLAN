% Module 2: Coarse CFO Estimation + Frequency Correction + Search Buffer Extraction - Flattened
% @CSR: 1.0 for passthrough/correction (CFO compute hidden behind EXTRACT)
% @FSM: YES (async startOffset control input)
% @FP-TOPO-OPT: Dual-output APPLY - emits search_buffer (pre-sliced for M3)
% @FP-ASYNC: Circular buffer + FSM for startOffset
%
% Flattened: vectorized exp() kept (will become NCO in Phase 4)
% Accuracy target: < 1e-10 vs original module

function [search_buffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo_flat(data_in, num_samples, startOffset, lstfLen, lltfLen, fs)
%#codegen

    % Parameters
    fftLen = 64;                      % FFT length for 20 MHz
    M = fftLen / 4;                   % Repetition period = 16
    GI = fftLen / 4;                  % Guard interval = 16
    S = GI * 9;                       % Useful L-STF samples = 144
    corrOffset = 0.75;                % Correlation offset fraction
    searchBufferLen = lstfLen * 10 + lltfLen * 3;  % 640

    % EXTRACT: Get rxWave1 = data_in(startOffset+1 : end)
    rxLen = num_samples - startOffset;

    % COMPUTE: Coarse CFO estimation
    offset = round(corrOffset * GI);  % = 12
    useLen = min(S, rxLen - offset);   % min(144, rxLen-12)

    % CFO estimate: autocorrelate with delay M, angle of sum
    unused_samples = mod(useLen, M);
    corrLen = useLen - M - unused_samples;

    % Dot product: C = sum(conj(cx[n]) * sx[n])
    C = complex(0, 0);
    for n = 1:corrLen
        cx_idx = startOffset + offset + n;        % use(n) = rxWave1(offset + n)
        sx_idx = startOffset + offset + M + n;    % use(M + n)
        C = C + conj(data_in(cx_idx)) * data_in(sx_idx);
    end
    coarseFreqOff = angle(C) / (2 * pi) * fs / M;

    % APPLY: Frequency correction + search buffer extraction
    search_buffer = complex(zeros(searchBufferLen, 1));
    for n = 1:searchBufferLen
        t = (n - 1) / fs;
        phase = 2 * pi * coarseFreqOff * t;
        correction = complex(cos(phase), sin(phase));
        search_buffer(n) = data_in(startOffset + n) * correction;
    end

end
