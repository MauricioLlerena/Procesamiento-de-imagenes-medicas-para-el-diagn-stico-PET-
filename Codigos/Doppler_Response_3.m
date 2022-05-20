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
<<<<<<< HEAD

%% Range speed response pattern of target

%4.1 Set initial specifications

antenna = phased.IsotropicAntennaElement(...
    'FrequencyRange', [5e9 15e9]);
transmitter = phased.Transmitter('Gain', 20, 'InUseOutputPort', true);
fc = 10e9;
target = phased.RadarTarget('Model', 'Nonfluctuating', ...
    'MeanRCS', 1, 'OperatingFrequency', fc);
txloc = [0,0,0]; %location for the antenna, global origina, introduces as a vector[x, y, z]
tgtloc = [5000,5000,10]; %location for the target, introduce as a vector [x, y, z]
antennaplatform = phased.Platform('InitialPosition', txloc);
targetplatform = phased.Platform('InitialPosition', tgtloc);
[tgtrng, tgtang] = rangeangle(targetplatform.InitialPosition, ...
    antennaplatform.InitialPosition);

%4.2 Plot the range-Doppler response

waveform = phased.RectangularWaveform('PulseWidth', 2e-6,'OutputFormat', 'Pulses', 'PRF', 1e4, 'NumPulses', 1);
c = physconst('Lightspeed');
maxrange = c/(2*waveform.PRF);
SNR = npwgnthresh(1e-6, 1, 'noncoherent');
lambda = c/target.OperatingFrequency;
maxrange = c/(2*waveform.PRF);
tau = waveform.PulseWidth;
Ts = 290;
dbterm = db2pow(SNR - 2*transmitter.Gain);
Pt = (4*pi)^3*physconst('Boltzmann')*Ts/tau/target.MeanRCS/lambda^2*maxrange^4*dbterm;

%4.3 Set the peak transmit power to the value obtained from the radar
%equation

transmitter.PeakPower = ;

%4.4 Create radiator and collector objects that operate at 10 GHz. Create a
%free space path for the propagation of the pulse to and from the target.
%Then, create a receiver.

radiator = phased.Radiator(...
    'PropagationSpeed', c, ...
    'OperatingFrequency', fc, 'Sensor', antenna);
channel = phased.FreeSpace(...
    'PropagationSpeed', c, ...
    'OperatingFrequency', fc, 'TwoWayPropagation', false);
collector = phased.Collector(...
    'PropagationSpeed', c, ...
    'OperatingFrequency', fc, 'Sensor', antenna);
receiver = phased.ReceiverPreamp('NoiseFigure', 0, ...
    'EnableInputPort', true, 'SeedSource', 'Property', 'Seed', 2e3);

%4.5 Propagate 25 pulses to and from the target. Collect the echoes at the
%receiver, and store them in a column matrix named rx_puls.

numPulses = 25;
rx_puls = zeros(100, numPulses);

for n = 1:numPulses
    wf = waveform();
    [wf, txstatus] = transmmitter(wf);
    wf = radiator(wf, tgtang);
    wf = channel(wf, txloc, tgtloc, [0;0;0], [0;0;0]);
    wf = target(wf);
    wf = channel(wf, tgtloc, txloc, [0;0;0], [0;0;0]);
    wf = collector(wf, tgtang);
    rx_puls(:,n) = receiver(wf, ~txstatus);
end

%4.6 Create a range-Doppler response object tat uses the matched filter
%approach. Configure this object to show radial speed rather than Doppler
%frequency. Use plotResponse to plot the range versus speed.

rangedoppler = phased.RangeDopplerResponse(...
    'RangeMethod', 'Matched filter', ...
    'PropagationSpeed', c, ...
    'DopplerOutput', 'Speed', 'OperatingFrequency', fc);

figure(3)
plotResponse(rangedoppler, rx_puls, getMatchedFilter(waveform));
=======
%% Range speed response pattern of target.
>>>>>>> fd657158a7dff2c8386128123e0ff985253e64a5
