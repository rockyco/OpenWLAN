% Module 3: Fine Symbol Timing Estimation (L-LTF cross-correlation)
% @CSR: 1.0 within fixed-length search buffer
% @FSM: NO (receives fixed-length stream, no async control input)
% @FP-CORR: 160-tap cross-correlation with fixed L-LTF ref -> hls::FIR IP (>16 taps)
% @FP-CORR: 3-FIR Karatsuba decomposition for complex correlation
%
% Interface: fixed-length input, control output only
% FP-DECOMP1: search_buffer is searchBufferLen length (fixed)
% FP-DECOMP2: fineOffset is SEPARATE control output

function fineOffset = module3_fine_sync(search_buffer, searchBufferLen, lltfLen)
%#codegen

    % Generate L-LTF reference for cross-correlation
    % In HLS this will be a constant coefficient array
    cfg = wlanVHTConfig('ChannelBandwidth', 'CBW20');
    LLTF = wlan.internal.legacyLTF('CBW20', 1, 1);  % 160-sample complex reference
    L = length(LLTF);  % 160

    % Cross-correlation: equivalent to FIR filter with h[k] = conj(LLTF[L-1-k])
    % corr[n] = sum_{k=0}^{L-1} conj(LLTF[L-1-k]) * search_buffer[n-k]
    % = filter(conj(flipud(LLTF)), 1, search_buffer)
    corr = filter(conj(flipud(LLTF(:,1))), 1, search_buffer);

    % Decision metric: |corr|^2, find peak from L onwards
    metricLen = searchBufferLen - L + 1;
    Metric = abs(corr(L : L + metricLen - 1)).^2;
    [Mmax, nMax] = max(Metric);

    % Fine timing offset
    fineOffset = nMax - L - 1;

    % Clamp to valid range
    if fineOffset < 0
        fineOffset = 0;
    end

end
