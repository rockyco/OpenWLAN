% Phase 4 Testbench: module4_fine_cfo_apply_opt vs Phase 2 reference
% FP-SSOT3: CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

m4_in = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));
m4_ref = load_complex_tv(fullfile(tv_dir, 'm4_corrected_out.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));

[corrected_out, fineFreqOff] = module4_fine_cfo_apply_opt( ...
    m4_in, params.filteredLen, params.startOffset, params.fineOffset, ...
    params.lstfLen, params.lltfLen, params.fs);

wave_error = max(abs(corrected_out - m4_ref));
cfo_error = abs(fineFreqOff - params.fineFreqOff);
max_error = max(wave_error, cfo_error);

fprintf('module4_fine_cfo_apply_opt: wave_err=%.2e, cfo_err=%.2e\n', wave_error, cfo_error);

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
