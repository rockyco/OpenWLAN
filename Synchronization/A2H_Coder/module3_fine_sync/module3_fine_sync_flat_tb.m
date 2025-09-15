% Phase 3 Testbench: module3_fine_sync_flat vs Phase 2 reference
% FP-SSOT3: This testbench is a CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

% Load test vectors
m3_in = load_complex_tv(fullfile(tv_dir, 'm2_search_buffer.txt'));
lltf_coeffs = load_complex_tv(fullfile(tv_dir, 'lltf_fir_coeffs.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));
searchBufferLen = params.searchBufferLen;
lltfLen = params.lltfLen;
ref_fineOffset = params.fineOffset;

% Run flattened module
fineOffset = module3_fine_sync_flat(m3_in, searchBufferLen, lltfLen, lltf_coeffs);

% Compare
max_error = abs(fineOffset - ref_fineOffset);

fprintf('module3_fine_sync_flat: offset_err=%d\n', max_error);
fprintf('fineOffset: expected=%d, got=%d\n', ref_fineOffset, fineOffset);

if max_error < 1e-10
    fprintf('PASS\n');
else
    fprintf('FAIL\n');
end

function data = load_complex_tv(filepath)
    fid = fopen(filepath, 'r');
    fgetl(fid);  % skip header
    raw = textscan(fid, '%f%f');
    fclose(fid);
    data = complex(raw{1}, raw{2});
end
