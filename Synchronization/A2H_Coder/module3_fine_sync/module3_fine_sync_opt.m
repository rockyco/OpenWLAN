% Module 3: Fine Symbol Timing (L-LTF cross-correlation) - Optimized
% @CSR: 1.0
% @FSM_REQUIRED: NO
% @FP-CORR: 160-tap cross-correlation -> hls::FIR IP (>16 taps)
% @OPTIMIZATIONS: FIR inherent O(N*L), waivered for hls::FIR IP in Phase 5
%
% Phase 4: No incremental optimization possible for FIR cross-correlation.
% The nested loop structure maps directly to hls::FIR IP in Phase 5.
% See module3_fine_sync_p4_waiver.txt.

function fineOffset = module3_fine_sync_opt(search_buffer, searchBufferLen, lltfLen, lltf_fir_coeffs)
%#codegen

    % L-LTF reference length (160 taps)
    L = length(lltf_fir_coeffs);  % 160

    % Cross-correlation via explicit FIR
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

    % Peak detection: |corr|^2 from L onwards
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

    if fineOffset < 0
        fineOffset = 0;
    end

end
