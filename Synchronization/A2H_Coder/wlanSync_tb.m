% WLAN Synchronization Testbench with Comprehensive Visualization
% This script generates inputs to the example model using
% the BS option on the mask. The impairments such as channel, AWGN noise,
% CFO and timing offset are added in the script for demonstration of the
% example. Includes comprehensive visualization with optional file saving.

chanBW = '20MHz'; % Channel bandwidth
% Initilize input parameters
numPkts = 1;          
timeOffset = 25; 
snr = 30;
CFO = 10e3; 

% Configuration for visualization and saving
saveResults = true;  % Set to true to save plots to files
showPlots = true;    % Set to true to display plots

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
ofdmInfo = wlanVHTOFDMInfo('VHT-Data',cfg);
wlanConfig.lstf = wlanLSTF(cfg);
wlanConfig.lltf = wlanLLTF(cfg);
wlanConfig.lstfLen = length(wlanConfig.lstf)/10;
wlanConfig.lltfLen = length(wlanConfig.lltf);

wlanConfig.FFTLen=64*wlanConfig.Fs/20e6;
wlanConfig.cpLength=wlanConfig.FFTLen/4;
wlanConfig.gaurdLen=wlanConfig.FFTLen/4;
wlanConfig.corrLen = 64;
S=wlanConfig.cpLength*9;
fac=wlanConfig.Fs/wlanConfig.cpLength;
fs=wlanConfig.Fs;

% Filter used for correlation in Fine time sync 
% Running filter at 160MHz for resource sharing option in FIR filter
filterUpsampleFactor = 160e6/wlanConfig.Fs; 
filterLatency = (wlanConfig.corrLen/filterUpsampleFactor)+filterUpsampleFactor+9;

% Create bit vector containing concatenated PSDUs and generate input
% waveform
numBits = cfg.PSDULength*numPkts;
dataBits = randi([0 1],numBits,1);
txWaveform =wlanWaveformGenerator(dataBits,cfg,'NumPackets',numPkts);

% Genrate Tx and Rx filter
% All frequency values are in MHz.
Fs = wlanConfig.Fs;  % Sampling Frequency

Fpass = 0.9*Fs/2;               % Passband Frequency
Fstop = Fs/2;              % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

inputWaveform = filter(Hd.Numerator,1,txWaveform);

% Create and configure the channel
tgacChannel = wlanTGacChannel;
tgacChannel.DelayProfile = 'Model-A';
tgacChannel.NumReceiveAntennas = 1;
tgacChannel.ChannelBandwidth = cfg.ChannelBandwidth;
tgacChannel.SampleRate = fs;


% Create an instance of the AWGN channel per SNR point simulated
awgnChannel = comm.AWGNChannel;   
awgnChannel.NoiseMethod = 'Signal to noise ratio (SNR)';
awgnChannel.SignalPower = 1;
awgnChannel.SNR = snr-10*log10(ofdmInfo.FFTLength/ofdmInfo.NumTones);

% Add channel and noise
inputWaveform = tgacChannel(inputWaveform);
inputWaveform = awgnChannel([zeros(timeOffset,1); inputWaveform]);

% Add CFO
firstIndex = 0;

normalizedCFO = CFO/fs;

inputWaveform = inputWaveform .* exp(1i*2*pi*normalizedCFO*...
    (firstIndex:firstIndex+length(inputWaveform)-1).');
inputWaveform = [inputWaveform; zeros(length(Hd.Numerator)-1,1)];

% Perform synchronization
[correctedWaveform, coarseFreqOff, fineFreqOff] = wlanSync(inputWaveform, wlanConfig, CBW, Hd);

% Save test vectors for HLS validation (MANDATORY for framework)
fprintf('Saving test vectors for HLS validation...\n');
writematrix([real(inputWaveform), imag(inputWaveform)], 'wlanSync_in.txt', 'Delimiter', ' ');
writematrix([real(correctedWaveform), imag(correctedWaveform)], 'wlanSync_ref.txt', 'Delimiter', ' ');
writematrix([coarseFreqOff, fineFreqOff], 'wlanSync_cfo_ref.txt', 'Delimiter', ' ');
fprintf('Test vectors saved successfully.\n');

% Display results
fprintf('\n======================================\n');
fprintf('WLAN SYNCHRONIZATION RESULTS\n');
fprintf('======================================\n');
fprintf('Configuration:\n');
fprintf('  Channel Bandwidth: %s\n', chanBW);
fprintf('  Sampling Rate: %.1f MHz\n', fs/1e6);
fprintf('  SNR: %d dB\n', snr);
fprintf('  Time Offset: %d samples\n', timeOffset);
fprintf('\nFrequency Offset Results:\n');
fprintf('  Injected CFO: %.2f kHz\n', CFO/1000);
fprintf('  Coarse CFO Estimate: %.2f kHz\n', coarseFreqOff/1000);
fprintf('  Fine CFO Estimate: %.2f kHz\n', fineFreqOff/1000);
fprintf('  Total CFO Correction: %.2f kHz\n', (coarseFreqOff+fineFreqOff)/1000);
fprintf('  Residual CFO: %.2f kHz\n', (CFO-(coarseFreqOff+fineFreqOff))/1000);
fprintf('  Estimation Error: %.2f%%\n', abs(CFO-(coarseFreqOff+fineFreqOff))/CFO*100);
fprintf('======================================\n\n');

if showPlots
    % Visualization - Main Analysis Figure
    fig1 = figure('Name', 'WLAN Synchronization Analysis', 'Position', [100, 100, 1400, 900]);
    
    % 1. Time domain signals
    subplot(3,3,1);
    t_tx = (0:length(txWaveform)-1)/fs * 1e6; % Convert to microseconds
    plot(t_tx, real(txWaveform), 'b', 'LineWidth', 1);
    hold on;
    plot(t_tx, imag(txWaveform), 'r', 'LineWidth', 1);
    grid on;
    xlabel('Time (μs)');
    ylabel('Amplitude');
    title('Original Transmitted Waveform');
    legend('Real', 'Imaginary', 'Location', 'best');
    xlim([0, 50]); % Show first 50 microseconds
    
    % 2. Received signal with impairments
    subplot(3,3,2);
    t_rx = (0:length(inputWaveform)-1)/fs * 1e6;
    plot(t_rx, abs(inputWaveform), 'g', 'LineWidth', 1);
    grid on;
    xlabel('Time (μs)');
    ylabel('Magnitude');
    title(sprintf('Received Signal (SNR=%d dB, CFO=%d kHz)', snr, CFO/1000));
    xlim([0, 100]);
    
    % 3. Corrected signal
    subplot(3,3,3);
    t_corr = (0:length(correctedWaveform)-1)/fs * 1e6;
    plot(t_corr, abs(correctedWaveform), 'm', 'LineWidth', 1);
    grid on;
    xlabel('Time (μs)');
    ylabel('Magnitude');
    title('Synchronized & Corrected Signal');
    xlim([0, 50]);
    
    % 4. Power spectrum comparison
    subplot(3,3,4);
    nfft = 2048;
    [pxx_tx, f_tx] = pwelch(txWaveform, hamming(nfft), nfft/2, nfft, fs, 'centered');
    [pxx_rx, f_rx] = pwelch(inputWaveform, hamming(nfft), nfft/2, nfft, fs, 'centered');
    [pxx_corr, f_corr] = pwelch(correctedWaveform, hamming(nfft), nfft/2, nfft, fs, 'centered');
    plot(f_tx/1e6, 10*log10(pxx_tx), 'b', 'LineWidth', 1);
    hold on;
    plot(f_rx/1e6, 10*log10(pxx_rx), 'r', 'LineWidth', 1);
    plot(f_corr/1e6, 10*log10(pxx_corr), 'g', 'LineWidth', 1);
    grid on;
    xlabel('Frequency (MHz)');
    ylabel('Power Spectral Density (dB/Hz)');
    title('Power Spectrum Analysis');
    legend('Transmitted', 'Received', 'Corrected', 'Location', 'best');
    ylim([-80, -20]);
    
    % 5. Constellation diagram before correction
    subplot(3,3,5);
    % Extract data portion after preamble
    startIdx = round(wlanConfig.lstfLen*10 + wlanConfig.lltfLen*2 + timeOffset);
    if startIdx < length(inputWaveform)-1000
        dataSymbols = inputWaveform(startIdx:startIdx+1000);
        scatter(real(dataSymbols), imag(dataSymbols), 5, 'filled');
        grid on;
        xlabel('In-Phase');
        ylabel('Quadrature');
        title('Constellation Before Correction');
        axis equal;
        axis([-2 2 -2 2]);
    end
    
    % 6. Constellation diagram after correction
    subplot(3,3,6);
    if length(correctedWaveform) > 1000
        corrSymbols = correctedWaveform(1:1000);
        scatter(real(corrSymbols), imag(corrSymbols), 5, 'filled');
        grid on;
        xlabel('In-Phase');
        ylabel('Quadrature');
        title('Constellation After Correction');
        axis equal;
        axis([-2 2 -2 2]);
    end
    
    % 7. Autocorrelation for packet detection
    subplot(3,3,7);
    autocorrLen = min(1000, length(inputWaveform)-wlanConfig.lstfLen);
    autocorr = zeros(autocorrLen, 1);
    for i = 1:autocorrLen
        autocorr(i) = abs(sum(inputWaveform(i:i+wlanConfig.lstfLen-1) .* ...
            conj(inputWaveform(i+wlanConfig.lstfLen:i+2*wlanConfig.lstfLen-1))));
    end
    t_auto = (0:autocorrLen-1)/fs * 1e6;
    plot(t_auto, autocorr/max(autocorr), 'LineWidth', 1.5);
    grid on;
    xlabel('Time (μs)');
    ylabel('Normalized Correlation');
    title('Packet Detection Metric');
    ylim([0 1.1]);
    
    % 8. Frequency offset estimation accuracy
    subplot(3,3,8);
    freqOffsets = [CFO, coarseFreqOff, fineFreqOff, coarseFreqOff+fineFreqOff];
    freqLabels = {'Injected CFO', 'Coarse Est.', 'Fine Est.', 'Total Est.'};
    bar(freqOffsets/1000);
    set(gca, 'XTickLabel', freqLabels);
    ylabel('Frequency Offset (kHz)');
    title('Frequency Offset Estimation');
    grid on;
    hold on;
    yline(CFO/1000, 'r--', 'LineWidth', 2);
    legend('Estimates', 'True CFO', 'Location', 'best');
    
    % 9. Phase tracking
    subplot(3,3,9);
    if length(correctedWaveform) > 100
        phase_rx = unwrap(angle(inputWaveform(timeOffset+1:min(timeOffset+1000, end))));
        phase_corr = unwrap(angle(correctedWaveform(1:min(1000, end))));
        t_phase = (0:length(phase_rx)-1)/fs * 1e6;
        plot(t_phase, phase_rx, 'r', 'LineWidth', 1);
        hold on;
        plot(t_phase(1:length(phase_corr)), phase_corr, 'g', 'LineWidth', 1);
        grid on;
        xlabel('Time (μs)');
        ylabel('Phase (radians)');
        title('Phase Evolution');
        legend('Before Correction', 'After Correction', 'Location', 'best');
    end
    
    sgtitle(sprintf('WLAN Synchronization Performance (BW=%s, Time Offset=%d samples)', chanBW, timeOffset));
    
    % Save the figure if requested
    if saveResults
        saveas(fig1, 'wlan_sync_analysis.png');
        saveas(fig1, 'wlan_sync_analysis.fig');
        fprintf('Main analysis figure saved to wlan_sync_analysis.png\n');
    end
    
    % Additional Performance Analysis Figure
    fig2 = figure('Name', 'Synchronization Performance Analysis', 'Position', [100, 100, 1200, 600]);
    
    % Synchronization convergence over CFO range
    subplot(1,2,1);
    fprintf('Running CFO robustness analysis...\n');
    cfo_test = -20e3:5e3:20e3;
    cfo_errors = zeros(size(cfo_test));
    
    for idx = 1:length(cfo_test)
        % Add test CFO
        test_cfo = cfo_test(idx);
        normalizedTestCFO = test_cfo/fs;
        testWaveform = txWaveform .* exp(1i*2*pi*normalizedTestCFO*(0:length(txWaveform)-1).');
        testWaveform = filter(Hd.Numerator,1,testWaveform);
        testWaveform = awgnChannel([zeros(timeOffset,1); testWaveform]);
        testWaveform = [testWaveform; zeros(length(Hd.Numerator)-1,1)]; %#ok<AGROW>
        
        % Estimate CFO
        try
            [~, coarse, fine] = wlanSync(testWaveform, wlanConfig, CBW, Hd);
            cfo_errors(idx) = test_cfo - (coarse + fine);
        catch
            cfo_errors(idx) = NaN;
        end
    end
    
    plot(cfo_test/1000, cfo_errors/1000, 'b-o', 'LineWidth', 2);
    grid on;
    xlabel('Injected CFO (kHz)');
    ylabel('Residual CFO (kHz)');
    title('CFO Estimation Performance Across Range');
    hold on;
    yline(0, 'r--', 'LineWidth', 1);
    
    % SNR performance analysis
    subplot(1,2,2);
    fprintf('Running SNR performance analysis...\n');
    snr_test = 0:5:30;
    cfo_rmse = zeros(size(snr_test));
    
    for idx = 1:length(snr_test)
        % Configure AWGN channel for test SNR
        testAwgnChannel = comm.AWGNChannel;   
        testAwgnChannel.NoiseMethod = 'Signal to noise ratio (SNR)';
        testAwgnChannel.SignalPower = 1;
        testAwgnChannel.SNR = snr_test(idx)-10*log10(ofdmInfo.FFTLength/ofdmInfo.NumTones);
        
        % Add impairments
        testWaveform = filter(Hd.Numerator,1,txWaveform);
        testWaveform = testAwgnChannel([zeros(timeOffset,1); testWaveform]);
        testWaveform = testWaveform .* exp(1i*2*pi*normalizedCFO*(0:length(testWaveform)-1).');
        testWaveform = [testWaveform; zeros(length(Hd.Numerator)-1,1)]; %#ok<AGROW>
        
        % Estimate CFO
        try
            [~, coarse, fine] = wlanSync(testWaveform, wlanConfig, CBW, Hd);
            cfo_rmse(idx) = abs(CFO - (coarse + fine));
        catch
            cfo_rmse(idx) = NaN;
        end
    end
    
    semilogy(snr_test, cfo_rmse/1000, 'r-s', 'LineWidth', 2);
    grid on;
    xlabel('SNR (dB)');
    ylabel('CFO Estimation Error (kHz)');
    title('CFO Estimation vs SNR');
    
    sgtitle('Synchronization Performance Analysis');
    
    % Save the figure if requested
    if saveResults
        saveas(fig2, 'wlan_sync_performance.png');
        saveas(fig2, 'wlan_sync_performance.fig');
        fprintf('Performance analysis figure saved to wlan_sync_performance.png\n');
    end
    
    % Additional detailed metrics figure
    fig3 = figure('Name', 'Synchronization Metrics', 'Position', [100, 100, 800, 600]);
    
    % Performance metrics table
    subplot(2,1,1);
    axis off;
    metrics = {
        'Parameter', 'Value';
        'Channel Bandwidth', chanBW;
        'Sampling Rate', sprintf('%.1f MHz', fs/1e6);
        'SNR', sprintf('%d dB', snr);
        'Time Offset', sprintf('%d samples', timeOffset);
        'Injected CFO', sprintf('%.2f kHz', CFO/1000);
        'Coarse CFO Estimate', sprintf('%.2f kHz', coarseFreqOff/1000);
        'Fine CFO Estimate', sprintf('%.2f kHz', fineFreqOff/1000);
        'Total CFO Correction', sprintf('%.2f kHz', (coarseFreqOff+fineFreqOff)/1000);
        'Residual CFO', sprintf('%.2f kHz', (CFO-(coarseFreqOff+fineFreqOff))/1000);
        'CFO Estimation Error', sprintf('%.2f%%', abs(CFO-(coarseFreqOff+fineFreqOff))/CFO*100);
    };
    
    % Display metrics as text
    for i = 1:size(metrics, 1)
        if i == 1
            text(0.2, 1-i*0.08, metrics{i,1}, 'FontWeight', 'bold', 'FontSize', 11);
            text(0.6, 1-i*0.08, metrics{i,2}, 'FontWeight', 'bold', 'FontSize', 11);
        else
            text(0.2, 1-i*0.08, metrics{i,1}, 'FontSize', 10);
            text(0.6, 1-i*0.08, metrics{i,2}, 'FontSize', 10);
        end
    end
    title('Synchronization Performance Metrics', 'FontSize', 14);
    
    % Eye diagram visualization
    subplot(2,1,2);
    if length(correctedWaveform) > 640
        eyediagram(correctedWaveform(1:640), 64, 1, 0);
        title('Eye Diagram of Corrected Signal');
        xlabel('Sample Index');
        ylabel('Amplitude');
    end
    
    % Save the figure if requested
    if saveResults
        saveas(fig3, 'wlan_sync_metrics.png');
        saveas(fig3, 'wlan_sync_metrics.fig');
        fprintf('Metrics figure saved to wlan_sync_metrics.png\n');
    end
end

if saveResults
    fprintf('\nVisualization complete. Figures saved as:\n');
    fprintf('  - wlan_sync_analysis.png/fig\n');
    fprintf('  - wlan_sync_performance.png/fig\n');
    fprintf('  - wlan_sync_metrics.png/fig\n');
else
    fprintf('\nVisualization complete.\n');
end