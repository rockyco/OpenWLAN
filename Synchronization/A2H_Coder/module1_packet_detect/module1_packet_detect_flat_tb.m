% Phase 3 Testbench: module1_packet_detect_flat vs Phase 2 reference
% FP-SSOT3: This testbench is a CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

% Load test vectors
m1_in = load_complex_tv(fullfile(tv_dir, 'm0_output.txt'));
m1_ref = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));
filteredLen = params.filteredLen;
lstfLen = params.lstfLen;
ref_startOffset = params.startOffset;

% Run flattened module
[m1_out, startOffset] = module1_packet_detect_flat(m1_in, filteredLen, lstfLen);

% Compare
data_error = max(abs(m1_out - m1_ref));
offset_error = abs(startOffset - ref_startOffset);
max_error = max(data_error, offset_error);

fprintf('module1_packet_detect_flat: data_err=%.2e, offset_err=%d\n', data_error, offset_error);
fprintf('startOffset: expected=%d, got=%d\n', ref_startOffset, startOffset);

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
