% Module 1: Packet Detection (L-STF autocorrelation) - Flattened
% @CSR: 1.0 (sliding autocorrelation on every sample)
% @FSM: NO (produces control output startOffset, does not consume async control)
% @FP-ASYNC7: Early control output - startOffset emitted inside loop when detected
%
% Flattened: MATLAB sliding-sum builtin replaced with explicit accumulation
% Accuracy target: < 1e-10 vs original module

function [data_out, startOffset] = module1_packet_detect_flat(data_in, num_samples, lstfLen)
%#codegen

    % Packet detection parameters
    symbolLength = lstfLen;        % 16 samples per L-STF symbol
    threshold = 0.5;               % Detection threshold
    lenLSTF = symbolLength * 10;   % 160 total L-STF samples
    pNoise = eps;

    % Shift data for correlation
    corrOutLen = num_samples - symbolLength;     % Length of delayed overlap
    metricLen = corrOutLen - symbolLength + 1;   % Length after running sum trim

    % Sliding window correlation and power (replaces two builtin calls)
    % C[n] = sum_{k=n-L+1}^{n} conj(rxDelayed[k]) * rx[k]  (running sum, window L)
    % P[n] = sum_{k=n-L+1}^{n} (|rxDelayed[k]|^2 + |rx[k]|^2)/2  (running sum, window L)

    % Compute element-wise products first
    conjProd = complex(zeros(corrOutLen, 1));
    powSum = zeros(corrOutLen, 1);

    for n = 1:corrOutLen
        rxD = data_in(symbolLength + n);  % rxDelayed[n]
        rx = data_in(n);                   % rx[n]
        conjProd(n) = conj(rxD) * rx;
        powSum(n) = (abs(rxD)^2 + abs(rx)^2) / 2;
    end

    % Running sum with sliding window of length symbolLength
    % Equivalent to running sum with window of symbolLength
    % Then trim to metricLen starting at index symbolLength

    % Initialize running sums
    corrSum = complex(0, 0);
    powSumAcc = 0;

    % Fill initial window (first symbolLength-1 samples)
    for k = 1:symbolLength - 1
        corrSum = corrSum + conjProd(k);
        powSumAcc = powSumAcc + powSum(k);
    end

    % Compute metric for each position in the metric window
    startOffset = 0;
    sustainedCount = 0;
    requiredSustained = floor(symbolLength * 1.5);
    detected = false;

    for n = 1:metricLen
        % Add new sample to window
        winIdx = n + symbolLength - 1;
        corrSum = corrSum + conjProd(winIdx);
        powSumAcc = powSumAcc + powSum(winIdx);

        % Normalized correlation and power
        CS = corrSum / symbolLength;
        PS = powSumAcc / symbolLength + pNoise;

        % Decision metric
        Mn = abs(CS)^2 / PS^2;

        % Sustained detection
        if ~detected
            if Mn > threshold
                sustainedCount = sustainedCount + 1;
                if sustainedCount >= requiredSustained
                    startOffset = n - sustainedCount + 1 - 1;  % 0-indexed offset
                    detected = true;
                end
            else
                sustainedCount = 0;
            end
        end

        % Remove oldest sample from window
        corrSum = corrSum - conjProd(n);
        powSumAcc = powSumAcc - powSum(n);
    end

    % Passthrough all data
    data_out = data_in(1:num_samples);

end
