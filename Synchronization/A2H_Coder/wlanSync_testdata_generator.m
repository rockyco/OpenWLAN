% Phase 2: Test Vector Generation for wlanSync
% FP-SSOT: This testbench is the ONLY generator of test vectors
% FP-SSOT2: Phase 2 generates ALL module boundary test vectors
% FP-SSOT4: Full sample count

addpath(pwd);

chanBW = '20MHz';
numPkts = 1;
timeOffset = 25;
snr = 30;
CFO = 10e3;

switch(chanBW)
    case '20MHz'
        wlanConfig.Fs = 20e6;
        CBW = 'CBW20';
    case '40MHz'
        CBW = 'CBW40';
        wlanConfig.Fs = 40e6;
    otherwise
        CBW = 'CBW80';
        wlanConfig.Fs = 80e6;
end

cfg = wlanVHTConfig('ChannelBandwidth', CBW);
ofdmInfo = wlanVHTOFDMInfo('VHT-Data', cfg);
wlanConfig.lstf = wlanLSTF(cfg);
wlanConfig.lltf = wlanLLTF(cfg);
wlanConfig.lstfLen = length(wlanConfig.lstf)/10;
wlanConfig.lltfLen = length(wlanConfig.lltf);
wlanConfig.FFTLen = 64*wlanConfig.Fs/20e6;
wlanConfig.cpLength = wlanConfig.FFTLen/4;
wlanConfig.corrLen = 64;
fs = wlanConfig.Fs;

% Filter design
Fs = wlanConfig.Fs;
Fpass = 0.9*Fs/2; Fstop = Fs/2; Dpass = 0.057501127785; Dstop = 0.0001; dens = 20;
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
b = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);
numTaps = length(b);

% Generate waveform with FIXED seed for reproducibility
rng(42);
numBits = cfg.PSDULength*numPkts;
dataBits = randi([0 1], numBits, 1);
txWaveform = wlanWaveformGenerator(dataBits, cfg, 'NumPackets', numPkts);

% Apply impairments
inputWaveform = filter(Hd.Numerator, 1, txWaveform);
tgacChannel = wlanTGacChannel;
tgacChannel.DelayProfile = 'Model-A';
tgacChannel.NumReceiveAntennas = 1;
tgacChannel.ChannelBandwidth = cfg.ChannelBandwidth;
tgacChannel.SampleRate = fs;
inputWaveform = tgacChannel(inputWaveform);

awgnChannel = comm.AWGNChannel;
awgnChannel.NoiseMethod = 'Signal to noise ratio (SNR)';
awgnChannel.SignalPower = 1;
awgnChannel.SNR = snr - 10*log10(ofdmInfo.FFTLength/ofdmInfo.NumTones);
inputWaveform = awgnChannel([zeros(timeOffset,1); inputWaveform]);

normalizedCFO = CFO/fs;
inputWaveform = inputWaveform .* exp(1i*2*pi*normalizedCFO*(0:length(inputWaveform)-1).');
inputWaveform = [inputWaveform; zeros(length(Hd.Numerator)-1,1)];

num_samples = length(inputWaveform);

% Create test_vectors directory
tv_dir = 'test_vectors';
if ~exist(tv_dir, 'dir')
    mkdir(tv_dir);
end

fprintf('=== Phase 2: Test Vector Generation ===\n');
fprintf('Input waveform length: %d\n', num_samples);

% Save system input (E0: system_input.txt)
write_complex_tv(fullfile(tv_dir, 'system_input.txt'), inputWaveform, 'system input (raw waveform)');
fprintf('Saved: system_input.txt (%d samples)\n', num_samples);

% Run Module 0: Pre-filter
[m0_output, filteredLen] = module0_prefilter(inputWaveform, num_samples, b.', numTaps);
write_complex_tv(fullfile(tv_dir, 'm0_output.txt'), m0_output, 'M0 output (filtered waveform)');
fprintf('Saved: m0_output.txt (%d samples)\n', filteredLen);

% Save filter coefficients
write_real_tv(fullfile(tv_dir, 'filter_coeffs.txt'), b.', 'FIR filter coefficients (51 taps)');
fprintf('Saved: filter_coeffs.txt (%d taps)\n', numTaps);

% Run Module 1: Packet Detection
[m1_data_out, startOffset] = module1_packet_detect(m0_output, filteredLen, wlanConfig.lstfLen);
write_complex_tv(fullfile(tv_dir, 'm1_data_out.txt'), m1_data_out, 'M1 data output (passthrough)');
write_scalar_tv(fullfile(tv_dir, 'm1_startOffset.txt'), startOffset, 'M1 control output: startOffset');
fprintf('Saved: m1_data_out.txt (%d samples), m1_startOffset.txt (=%d)\n', filteredLen, startOffset);

% Splitter: m1_data_out -> {m2_data_in, m4_data_in}
m2_data_in = m1_data_out;
m4_data_in = m1_data_out;

% Run Module 2: Coarse CFO
[searchBuffer, coarseFreqOff, searchBufferLen] = module2_coarse_cfo(m2_data_in, filteredLen, startOffset, wlanConfig.lstfLen, wlanConfig.lltfLen, fs);
write_complex_tv(fullfile(tv_dir, 'm2_search_buffer.txt'), searchBuffer, 'M2 search buffer output');
write_scalar_tv(fullfile(tv_dir, 'm2_coarseFreqOff.txt'), coarseFreqOff, 'M2 control output: coarseFreqOff (Hz)');
fprintf('Saved: m2_search_buffer.txt (%d samples), m2_coarseFreqOff.txt (=%.2f Hz)\n', searchBufferLen, coarseFreqOff);

% Run Module 3: Fine Sync
fineOffset = module3_fine_sync(searchBuffer, searchBufferLen, wlanConfig.lltfLen);
write_scalar_tv(fullfile(tv_dir, 'm3_fineOffset.txt'), fineOffset, 'M3 control output: fineOffset');
fprintf('Saved: m3_fineOffset.txt (=%d)\n', fineOffset);

% Run Module 4: Fine CFO + Apply
[corrected_out, fineFreqOff] = module4_fine_cfo_apply(m4_data_in, filteredLen, startOffset, fineOffset, wlanConfig.lstfLen, wlanConfig.lltfLen, fs);
write_complex_tv(fullfile(tv_dir, 'm4_corrected_out.txt'), corrected_out, 'M4 corrected output');
write_scalar_tv(fullfile(tv_dir, 'm4_fineFreqOff.txt'), fineFreqOff, 'M4 control output: fineFreqOff (Hz)');
fprintf('Saved: m4_corrected_out.txt (%d samples), m4_fineFreqOff.txt (=%.2f Hz)\n', length(corrected_out), fineFreqOff);

% Save L-LTF reference coefficients for M3 (needed in HLS)
LLTF = wlan.internal.legacyLTF('CBW20', 1, 1);
lltf_ref = conj(flipud(LLTF(:,1)));  % FIR coefficients = conj(flipped LLTF)
write_complex_tv(fullfile(tv_dir, 'lltf_fir_coeffs.txt'), lltf_ref, 'L-LTF FIR coefficients (160 taps)');
fprintf('Saved: lltf_fir_coeffs.txt (%d taps)\n', length(lltf_ref));

% Save system parameters
params = struct();
params.num_samples = num_samples;
params.filteredLen = filteredLen;
params.numTaps = numTaps;
params.lstfLen = wlanConfig.lstfLen;
params.lltfLen = wlanConfig.lltfLen;
params.searchBufferLen = searchBufferLen;
params.fftLen = wlanConfig.FFTLen;
params.cpLength = wlanConfig.cpLength;
params.fs = fs;
params.startOffset = startOffset;
params.fineOffset = fineOffset;
params.coarseFreqOff = coarseFreqOff;
params.fineFreqOff = fineFreqOff;
params.outputLen = length(corrected_out);
save(fullfile(tv_dir, 'system_params.mat'), '-struct', 'params');

% Also save as text for HLS consumption
fid = fopen(fullfile(tv_dir, 'system_params.txt'), 'w');
fprintf(fid, '%% system parameters\n');
fprintf(fid, 'num_samples\t%d\n', num_samples);
fprintf(fid, 'filteredLen\t%d\n', filteredLen);
fprintf(fid, 'numTaps\t%d\n', numTaps);
fprintf(fid, 'lstfLen\t%d\n', wlanConfig.lstfLen);
fprintf(fid, 'lltfLen\t%d\n', wlanConfig.lltfLen);
fprintf(fid, 'searchBufferLen\t%d\n', searchBufferLen);
fprintf(fid, 'fftLen\t%d\n', wlanConfig.FFTLen);
fprintf(fid, 'cpLength\t%d\n', wlanConfig.cpLength);
fprintf(fid, 'fs\t%d\n', fs);
fprintf(fid, 'startOffset\t%d\n', startOffset);
fprintf(fid, 'fineOffset\t%d\n', fineOffset);
fprintf(fid, 'coarseFreqOff\t%.15e\n', coarseFreqOff);
fprintf(fid, 'fineFreqOff\t%.15e\n', fineFreqOff);
fprintf(fid, 'outputLen\t%d\n', length(corrected_out));
fclose(fid);
fprintf('Saved: system_params.txt\n');

% Cross-check: run original wlanSync and compare
[correctedOrig, coarseOrig, fineOrig] = wlanSync(inputWaveform, wlanConfig, CBW, Hd);

coarseErr = abs(coarseOrig - coarseFreqOff);
fineErr = abs(fineOrig - fineFreqOff);
minLen = min(length(correctedOrig), length(corrected_out));
waveErr = max(abs(correctedOrig(1:minLen) - corrected_out(1:minLen)));

fprintf('\n=== Cross-check against original ===\n');
fprintf('Coarse CFO error: %.2e\n', coarseErr);
fprintf('Fine CFO error: %.2e\n', fineErr);
fprintf('Max waveform error: %.2e\n', waveErr);
fprintf('Output lengths: original=%d, modular=%d\n', length(correctedOrig), length(corrected_out));

if coarseErr == 0 && fineErr == 0 && waveErr == 0
    fprintf('\n>>> PHASE 2: TEST VECTORS GENERATED SUCCESSFULLY <<<\n');
    fprintf('MaxRelErr=0.0\n');  % For hook extraction
else
    fprintf('\n>>> PHASE 2: WARNING - non-zero error <<<\n');
    fprintf('MaxRelErr=%.2e\n', max([coarseErr, fineErr, waveErr]));
end

% List all generated files
fprintf('\n=== Generated Test Vector Files ===\n');
d = dir(fullfile(tv_dir, '*'));
for i = 1:length(d)
    if ~d(i).isdir
        fprintf('  %s (%d bytes)\n', d(i).name, d(i).bytes);
    end
end

%% Helper functions for tab-delimited test vector output

function write_complex_tv(filepath, data, description)
    fid = fopen(filepath, 'w');
    fprintf(fid, '%% %s\n', description);
    for k = 1:length(data)
        fprintf(fid, '%.15e\t%.15e\n', real(data(k)), imag(data(k)));
    end
    fclose(fid);
end

function write_real_tv(filepath, data, description)
    fid = fopen(filepath, 'w');
    fprintf(fid, '%% %s\n', description);
    for k = 1:length(data)
        fprintf(fid, '%.15e\n', data(k));
    end
    fclose(fid);
end

function write_scalar_tv(filepath, value, description)
    fid = fopen(filepath, 'w');
    fprintf(fid, '%% %s\n', description);
    fprintf(fid, '%.15e\n', value);
    fclose(fid);
end
