% Phase 3 Testbench: module2_coarse_cfo_flat vs Phase 2 reference
% FP-SSOT3: This testbench is a CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

% Load test vectors
m2_in = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));
m2_ref_sb = load_complex_tv(fullfile(tv_dir, 'm2_search_buffer.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));
filteredLen = params.filteredLen;
startOffset = params.startOffset;
lstfLen = params.lstfLen;
lltfLen = params.lltfLen;
fs = params.fs;
ref_coarseFreqOff = params.coarseFreqOff;
ref_searchBufferLen = params.searchBufferLen;

% Run flattened module
[search_buffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo_flat(m2_in, filteredLen, startOffset, lstfLen, lltfLen, fs);

% Compare
sb_error = max(abs(search_buffer - m2_ref_sb));
cfo_error = abs(coarseFreqOff - ref_coarseFreqOff);
len_error = abs(searchBufferLen - ref_searchBufferLen);
max_error = max([sb_error, cfo_error]);

fprintf('module2_coarse_cfo_flat: sb_err=%.2e, cfo_err=%.2e\n', sb_error, cfo_error);
fprintf('coarseFreqOff: expected=%.6f, got=%.6f\n', ref_coarseFreqOff, coarseFreqOff);
fprintf('searchBufferLen: expected=%d, got=%d\n', ref_searchBufferLen, searchBufferLen);

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
