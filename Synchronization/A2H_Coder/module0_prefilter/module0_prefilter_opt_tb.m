% Phase 4 Testbench: module0_prefilter_opt vs Phase 2 reference
% FP-SSOT3: CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

m0_in = load_complex_tv(fullfile(tv_dir, 'system_input.txt'));
m0_ref = load_complex_tv(fullfile(tv_dir, 'm0_output.txt'));
coeffs = load_real_tv(fullfile(tv_dir, 'filter_coeffs.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));

[m0_out, filteredLen] = module0_prefilter_opt(m0_in, params.num_samples, coeffs, params.numTaps);

max_error = max(abs(m0_out - m0_ref));
fprintf('module0_prefilter_opt: MaxRelErr = %.2e\n', max_error);

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
function data = load_real_tv(filepath)
    fid = fopen(filepath, 'r'); fgetl(fid);
    raw = textscan(fid, '%f'); fclose(fid);
    data = raw{1};
end
