% Module 1: Packet Detection (L-STF autocorrelation)
% @CSR: 1.0 (sliding autocorrelation on every sample)
% @FSM: NO (produces control output startOffset, does not consume async control)
% @FP-ASYNC7: Early control output - startOffset emitted inside loop when detected
%
% Interface: fixed-length input, passthrough data + control output
% FP-DECOMP1: data_in is num_samples length (fixed)
% FP-DECOMP2: startOffset is SEPARATE control output from data
% FP-DECOMP4: data_out length = num_samples (same as input, full passthrough)

function [data_out, startOffset] = module1_packet_detect(data_in, num_samples, lstfLen)
%#codegen

    % Packet detection parameters
    symbolLength = lstfLen;        % 16 samples per L-STF symbol
    threshold = 0.5;               % Detection threshold
    lenLSTF = symbolLength * 10;   % 160 total L-STF samples
    lenHalfLSTF = lenLSTF / 2;     % 80 samples

    % Autocorrelation-based detection (Heiskala & Terry algorithm)
    % C[n] = sum_{k=0}^{L-1} conj(x[n+k+L]) * x[n+k]  (delayed correlation)
    % P[n] = sum_{k=0}^{L-1} (|x[n+k+L]|^2 + |x[n+k]|^2) / 2  (power estimate)
    % M[n] = |C[n]|^2 / P[n]^2  (decision metric)
    %
    % Implemented as sliding window using filter() for running sum

    pNoise = eps;
    weights = ones(symbolLength, 1);

    % Shift data for correlation
    rxDelayed = data_in(symbolLength + 1 : num_samples);
    rx = data_in(1 : num_samples - symbolLength);

    % Running correlation (sliding sum of conjugate products)
    corrOutLen = num_samples - symbolLength;     % Length of filter output
    metricLen = corrOutLen - symbolLength + 1;   % Length after trim
    C = filter(weights, 1, conj(rxDelayed) .* rx);
    CS = C(symbolLength : symbolLength + metricLen - 1) ./ symbolLength;

    % Running power estimate
    P = filter(weights, 1, (abs(rxDelayed).^2 + abs(rx).^2) / 2) ./ symbolLength;
    PS = P(symbolLength : symbolLength + metricLen - 1) + pNoise;

    % Decision metric
    Mn = abs(CS).^2 ./ PS.^2;

    % Find first position where metric exceeds threshold for sustained period
    N = Mn > threshold;
    corrLen = lenLSTF - (symbolLength * 2) + 1;

    % Simple detection: find first sustained detection region
    startOffset = 0;
    sustainedCount = 0;
    requiredSustained = floor(symbolLength * 1.5);

    for n = 1:length(N)
        if N(n)
            sustainedCount = sustainedCount + 1;
            if sustainedCount >= requiredSustained
                startOffset = n - sustainedCount + 1 - 1;  % 0-indexed offset
                break;
            end
        else
            sustainedCount = 0;
        end
    end

    % Passthrough all data
    data_out = data_in(1:num_samples);

end
