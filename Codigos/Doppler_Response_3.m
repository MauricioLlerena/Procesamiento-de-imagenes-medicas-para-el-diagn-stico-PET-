%%Range-Doppler response using matched filter
%1.1. Load data for a pulsed radar signal
load RangeDopplerExampleData;
%1.2. Create a range-Doppler response object
response =
phased.RangeDopplerResponse('DopplerFFTLengthSourcphased.RangeDopplerResponse('DopplerFFTLengthSourc
e','Property', ...
'DopplerFFTLength',RangeDopplerEx_MF_NFFTDOP, ...
'SampleRate',RangeDopplerEx_MF_Fs,'DopplerOutput','Speed',...
'OperatingFrequency',RangeDopplerEx_MF_Fc);
%1.3.  Calculate the range-Doppler response.
[resp,rng_grid,dop_grid] =
response(RangeDopplerEx_MF_X, ...
RangeDopplerEx_MF_Coeff);
%1.4. Plot the range-Doppler response.
figure(1)
imagesc(dop_grid,rng_grid,mag2db(abs(resp)));
xlabel('Speed (m/s)');
ylabel('Range (m)');
title('Range-Doppler Map');
%% Estimate Doppler and range from range-Doppler response
%2.1. Load data for a pulsed radar signal
load RangeDopplerExampleData;
%2.2. Create a range-Doppler response object
hrdresp = phased.RangeDopplerResponse(...
'RangeMethod','FFT',...
'PropagationSpeed',RangeDopplerEx_Dechirp_PropSpeed,...
'SampleRate',RangeDopplerEx_Dechirp_Fs,...}
'DechirpInput',true,...
'SweepSlope',RangeDopplerEx_Dechirp_SweepSlope);  
% 2.3. Obtain the range-Doppler response data
[resp,rng_grid,dop_grid] = step(hrdresp,...
RangeDopplerEx_Dechirp_X,RangeDopplerEx_Dechirp_Xref);
% 2.4. Estimate the range and Doppler by finding the location of the máximum responseof the máximum response
[x_temp,idx_temp] = max(abs(resp));
[~,dop_idx] = max(x_temp);
rng_idx = idx_temp(dop_idx);
dop_est = dop_grid(dop_idx) %Doppler shift
rng_est = rng_grid(rng_idx) % Distance of target
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