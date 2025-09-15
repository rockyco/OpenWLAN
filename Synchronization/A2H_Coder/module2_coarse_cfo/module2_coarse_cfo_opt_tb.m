% Phase 4 Testbench: module2_coarse_cfo_opt vs Phase 2 reference
% FP-SSOT3: CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

m2_in = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));
m2_ref_sb = load_complex_tv(fullfile(tv_dir, 'm2_search_buffer.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));

[search_buffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo_opt( ...
    m2_in, params.filteredLen, params.startOffset, params.lstfLen, params.lltfLen, params.fs);

sb_error = max(abs(search_buffer - m2_ref_sb));
cfo_error = abs(coarseFreqOff - params.coarseFreqOff);
max_error = max(sb_error, cfo_error);

fprintf('module2_coarse_cfo_opt: sb_err=%.2e, cfo_err=%.2e\n', sb_error, cfo_error);

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
