% Module 3: Fine Symbol Timing Estimation (L-LTF cross-correlation) - Flattened
% @CSR: 1.0 within fixed-length search buffer
% @FSM: NO (receives fixed-length stream, no async control input)
% @FP-CORR: 160-tap cross-correlation with fixed L-LTF ref -> hls::FIR IP (>16 taps)
% @FP-CORR: 3-FIR Karatsuba decomposition for complex correlation
%
% Flattened: MATLAB FIR builtin replaced with explicit convolution loop
%            wlan.internal.legacyLTF() replaced with precomputed coefficients from test_vectors
% Accuracy target: < 1e-10 vs original module

function fineOffset = module3_fine_sync_flat(search_buffer, searchBufferLen, lltfLen, lltf_fir_coeffs)
%#codegen

    % L-LTF reference length (160 taps)
    L = length(lltf_fir_coeffs);  % 160

    % Cross-correlation via explicit FIR: corr[n] = sum_{k=0}^{L-1} h[k] * x[n-k]
    % where h = conj(flipud(LLTF)) = lltf_fir_coeffs
    corr = complex(zeros(searchBufferLen, 1));

    for n = 1:searchBufferLen
        acc = complex(0, 0);
        for k = 1:L
            idx = n - k + 1;
            if idx >= 1
                acc = acc + lltf_fir_coeffs(k) * search_buffer(idx);
            end
        end
        corr(n) = acc;
    end

    % Decision metric: |corr|^2, find peak from L onwards
    metricLen = searchBufferLen - L + 1;

    Mmax = 0;
    nMax = 1;
    for n = 1:metricLen
        val = abs(corr(L + n - 1))^2;
        if val > Mmax
            Mmax = val;
            nMax = n;
        end
    end

    % Fine timing offset
    fineOffset = nMax - L - 1;

    % Clamp to valid range
    if fineOffset < 0
        fineOffset = 0;
    end

end
