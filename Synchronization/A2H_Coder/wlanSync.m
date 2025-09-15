% WLAN Time and Frequency Synchronization
% This example shows how to perform time and frequency synchronization

function [correctedWaveform, coarseFreqOff, fineFreqOff] = wlanSync(inputWaveform, wlanConfig, CBW, Hd)
%#codegen

    fs = wlanConfig.Fs;  % Sampling Frequency
    inputWaveformRef = inputWaveform(1:end-length(Hd.Numerator)+1);
    inputWaveformRef = filter(Hd.Numerator,1,inputWaveformRef);

    % WLAN packet detection
    [startOffset,Mn]=wlanPacketDetect(inputWaveformRef,CBW);
    rxWave1 = inputWaveformRef(startOffset+1:end);

    % Coarse CFO estimation and correction
    coarseFreqOff = wlanCoarseCFOEstimate(rxWave1,CBW);
    % Correct the frequency offset
    rxWave2 = frequencyOffset(rxWave1, fs, coarseFreqOff);

    % Fine time synchronization
    searchBufferLLTF = rxWave2(1:wlanConfig.lstfLen*10+wlanConfig.lltfLen*3);
    [offset,MN] = wlanSymbolTimingEstimate(searchBufferLLTF,CBW);
    rxWave3 = inputWaveformRef(startOffset+offset+1:end);

    % Fine CFO estimation and correction
    LTFs = rxWave3(10*wlanConfig.lstfLen+(1:wlanConfig.lltfLen*2));
    fineFreqOff = wlanFineCFOEstimate(LTFs,CBW);   

    correctedWaveform = frequencyOffset(rxWave3,fs,fineFreqOff); 

end
