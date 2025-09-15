% Module 1: Packet Detection (L-STF autocorrelation) - Optimized
% @CSR: 1.0
% @FSM_REQUIRED: NO
% @OPTIMIZATIONS: FP-MATOPT1 sliding window, FP-MATOPT2 division avoidance
%
% Phase 4 optimizations applied:
% - FP-MATOPT1: Sliding window O(N) instead of recomputing window sum each position
% - FP-MATOPT2: Division avoidance in metric comparison via cross-multiplication

function [data_out, startOffset] = module1_packet_detect_opt(data_in, num_samples, lstfLen)
%#codegen

    % Packet detection parameters
    symbolLength = lstfLen;        % 16 samples per L-STF symbol
    threshold = 0.5;               % Detection threshold
    pNoise = eps;

    % Dimension calculations
    corrOutLen = num_samples - symbolLength;
    metricLen = corrOutLen - symbolLength + 1;

    % Pre-compute element-wise products
    conjProd = complex(zeros(corrOutLen, 1));
    powSum = zeros(corrOutLen, 1);

    for n = 1:corrOutLen
        rxD = data_in(symbolLength + n);
        rx = data_in(n);
        conjProd(n) = conj(rxD) * rx;
        powSum(n) = (abs(rxD)^2 + abs(rx)^2) / 2;
    end

    % FP-MATOPT1: Sliding window running sums (incremental add/remove)
    corrSum = complex(0, 0);
    powSumAcc = 0;

    % Fill initial window (first symbolLength-1 samples)
    for k = 1:symbolLength - 1
        corrSum = corrSum + conjProd(k);
        powSumAcc = powSumAcc + powSum(k);
    end

    % Detection loop with sliding window
    startOffset = 0;
    sustainedCount = 0;
    requiredSustained = floor(symbolLength * 1.5);
    detected = false;

    for n = 1:metricLen
        % Sliding window: add new sample
        winIdx = n + symbolLength - 1;
        corrSum = corrSum + conjProd(winIdx);
        powSumAcc = powSumAcc + powSum(winIdx);

        % Normalized values
        CS_abs2 = abs(corrSum)^2;
        PS_scaled = (powSumAcc + pNoise * symbolLength)^2;

        % FP-MATOPT2: Division avoidance
        % Original: abs(CS/L)^2 / (PS/L + pNoise)^2 > threshold
        % Optimized: CS_abs2 > threshold * PS_scaled
        % (both sides multiplied by symbolLength^4 to eliminate division)
        if ~detected
            if CS_abs2 > threshold * PS_scaled
                sustainedCount = sustainedCount + 1;
                if sustainedCount >= requiredSustained
                    startOffset = n - sustainedCount + 1 - 1;
                    detected = true;
                end
            else
                sustainedCount = 0;
            end
        end

        % Sliding window: remove oldest sample
        corrSum = corrSum - conjProd(n);
        powSumAcc = powSumAcc - powSum(n);
    end

    % Passthrough all data
    data_out = data_in(1:num_samples);

end
