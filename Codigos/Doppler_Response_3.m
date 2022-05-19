%% Range-Doppler response of FMCW signal 

% Load data for a pulse radar signal 
load RangeDopplerExmpleData;

% Range-Doppler response object creation
hrdresp = phased.RangeDopplerResponse('RangeMethod', 'FFT',...
    'PropagationSpeed', RangeDopplerEx_Dechirp_PropSpeed, 'SampleRate',...
    RangeDopplerEx_Dechirp_Fs, 'DechirpInput', true, 'SweepSlope',...
    RangeDopplerEx_Dechirp_SweepSlope);

% Range-Doppler response plot
figure(2)
plotResponse(hrdresp, RangeDopplerEx_Dechirp_X,...
    RangeDopplerEx_Dechirp_Xref, 'Unit', 'db', 'NormalizeDoppler', true)