% Phase 3 Testbench: module4_fine_cfo_apply_flat vs Phase 2 reference
% FP-SSOT3: This testbench is a CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

% Load test vectors
m4_in = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));
m4_ref = load_complex_tv(fullfile(tv_dir, 'm4_corrected_out.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));
filteredLen = params.filteredLen;
startOffset = params.startOffset;
fineOffset = params.fineOffset;
lstfLen = params.lstfLen;
lltfLen = params.lltfLen;
fs = params.fs;
ref_fineFreqOff = params.fineFreqOff;

% Run flattened module
[corrected_out, fineFreqOff] = module4_fine_cfo_apply_flat(m4_in, filteredLen, startOffset, fineOffset, lstfLen, lltfLen, fs);

% Compare
wave_error = max(abs(corrected_out - m4_ref));
cfo_error = abs(fineFreqOff - ref_fineFreqOff);
max_error = max(wave_error, cfo_error);

fprintf('module4_fine_cfo_apply_flat: wave_err=%.2e, cfo_err=%.2e\n', wave_error, cfo_error);
fprintf('fineFreqOff: expected=%.6f, got=%.6f\n', ref_fineFreqOff, fineFreqOff);
fprintf('output length: expected=%d, got=%d\n', params.outputLen, length(corrected_out));

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
