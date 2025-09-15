% Phase 4 Testbench: module3_fine_sync_opt vs Phase 2 reference
% FP-SSOT3: CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

m3_in = load_complex_tv(fullfile(tv_dir, 'm2_search_buffer.txt'));
lltf_coeffs = load_complex_tv(fullfile(tv_dir, 'lltf_fir_coeffs.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));

fineOffset = module3_fine_sync_opt(m3_in, params.searchBufferLen, params.lltfLen, lltf_coeffs);

max_error = abs(fineOffset - params.fineOffset);
fprintf('module3_fine_sync_opt: offset_err=%d\n', max_error);
fprintf('fineOffset: expected=%d, got=%d\n', params.fineOffset, fineOffset);

if max_error < 1e-03
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

function data = load_complex_tv(filepath)
    fid = fopen(filepath, 'r'); fgetl(fid);
    raw = textscan(fid, '%f%f'); fclose(fid);
    data = complex(raw{1}, raw{2});
end
