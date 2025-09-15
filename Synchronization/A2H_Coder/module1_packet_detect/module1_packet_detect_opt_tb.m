% Phase 4 Testbench: module1_packet_detect_opt vs Phase 2 reference
% FP-SSOT3: CONSUMER of test vectors (read-only)

addpath(fullfile(pwd, '..'));
tv_dir = fullfile(pwd, '..', 'test_vectors');

m1_in = load_complex_tv(fullfile(tv_dir, 'm0_output.txt'));
m1_ref = load_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'));

params = load(fullfile(tv_dir, 'system_params.mat'));

[m1_out, startOffset] = module1_packet_detect_opt(m1_in, params.filteredLen, params.lstfLen);

data_error = max(abs(m1_out - m1_ref));
offset_error = abs(startOffset - params.startOffset);
max_error = max(data_error, offset_error);

fprintf('module1_packet_detect_opt: data_err=%.2e, offset_err=%d\n', data_error, offset_error);
fprintf('startOffset: expected=%d, got=%d\n', params.startOffset, startOffset);

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
