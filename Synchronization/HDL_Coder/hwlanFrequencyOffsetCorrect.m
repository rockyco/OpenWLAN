function dataOut = hwlanFrequencyOffsetCorrect(in, fs, foffset)
%helperFrequencyOffset Apply a frequency offset to the input signal
%
%   OUT = hwlanFrequencyOffsetCorrect(IN, FS, FOFFSET) applies the specified
%   frequency offset to the input signal.
%
%   OUT is the frequency-offset output of the same size as IN.
%   IN is the complex 2D array input.
%   FS is the sampling rate in Hz (e.g. 80e6).
%   FOFFSET is the frequency offset to apply to the input in Hz.
%
%

%   Copyright 2021-2024 The MathWorks, Inc.

%#codegen

% Initialize output
freqOff = foffset/fs;

foffsetfp = uint16(abs(freqOff*2^16));
NCOLatency = 6;

NCOObj = dsp.HDLNCO('DitherSource','None','Waveform','Complex exponential',...
    'AccumulatorWL',16,'PhaseQuantization',true,'NumQuantizerAccumulatorBits',...
    16,'OutputDataType','Binary point scaling');

NCOOutput = zeros(length(in)+NCOLatency,1);
validOut = false(length(in)+NCOLatency,1);
for ii=1:length(in)+NCOLatency
    if ii<=length(in)
        [NCOOutput(ii),validOut(ii)] = NCOObj(foffsetfp,true);
    else
        [NCOOutput(ii),validOut(ii)] = NCOObj(uint16(0),false);
    end
end
% % Consider valid output of NCO
foffsetVal = (NCOOutput(validOut));
if freqOff>0
dataOut = double(in.*conj(foffsetVal(1:length(in))));
else
dataOut = double(in.*(foffsetVal(1:length(in))));    
end

% [EOF]
