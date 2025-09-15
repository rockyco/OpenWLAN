% The 'wlanFrontEndInit' script generates inputs to the example model using
% the BS option on the mask. The impairments such as channel, AWGN noise,
% CFO and timing offset are added in the script for demonstration of the
% example.

chanBW = get_param([gcs '/WLANTimeAndFrequencySynchronization'],'chanBW');

% Initilize input parameters
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
validIn = true(length(inputWaveform),1);
startIn = [true; false(length(inputWaveform)-1,1)];

stopTime = 1.5* length(inputWaveform)*1/wlanConfig.Fs;
Simulink.suppressDiagnostic(gcb,'SimulinkFixedPoint:util:Overflowoccurred');
Simulink.suppressDiagnostic(gcb,'SimulinkFixedPoint:util:fxpParameterPrecisionLoss');
Simulink.suppressDiagnostic(gcb,'SimulinkFixedPoint:util:fxpParameterOverflow');
