clear; clc; close all;
wave = read_rigol_bin('RigolDS0.bin');
V = wave.y;
samplingRate = 1.25e9; %Samples/s
t = ((1:length(V))-1)/samplingRate;
tmax = 0.036; %Because I didn't save everything
validSamples = t<tmax;
t = t(validSamples);
V = V(validSamples);

% --- Level-crossing detection with interpolation ---
threshold = 0.3;
minDt = 500;  % minimum samples between accepted pulses

% Rising-edge crossings: sample below threshold, next sample at/above it
above = V >= threshold;
risingEdge = find(~above(1:end-1) & above(2:end));  % index k means V(k)<thr<=V(k+1)

% Enforce minimum spacing (in samples) between accepted pulses
pulseIdx = [];
lastIdx = -inf;
for k = 1:length(risingEdge)
    if risingEdge(k) - lastIdx > minDt
        pulseIdx(end+1) = risingEdge(k); %#ok<AGROW>
        lastIdx = risingEdge(k);
    end
end

% --- Sub-sample interpolation for each accepted crossing ---
% Linear interpolation between V(k) and V(k+1) to find the exact
% fractional sample where V == threshold
frac = (threshold - V(pulseIdx)) ./ (V(pulseIdx+1) - V(pulseIdx));
pulseTimes = t(pulseIdx) + frac' ./ samplingRate;   % interpolated trigger times
pulseTimes = pulseTimes(:);  % ensure column

fprintf('Found %d pulses\n', length(pulseTimes));

% --- Plot (decimated background trace, full-res pulse markers) ---
decimateFactor = 10;
idx = 1:decimateFactor:length(V);
figure;
plot(t(idx), V(idx), 'k-'); hold on
yline(threshold, 'r--');
plot(pulseTimes, threshold*ones(size(pulseTimes)), 'bo');
xlabel('Time (s)'); ylabel('Voltage (V)');
title(sprintf('%d pulses detected (interpolated)', length(pulseTimes)));

% --- Pulse spacing histogram ---
pulseDeltaT = diff(pulseTimes);
pulseDeltaT(pulseDeltaT > 1e-6) = [];
figure('Color','w');
histogram(pulseDeltaT*1e9, 200);
xlabel('\Delta t between pulses (ns)'); ylabel('Count');
title('Pulse spacing distribution');
xlim([500 503])


%Pulse statistics
disp(['Jitter - Standard deviation = ' num2str(std(pulseDeltaT)*1e12,'%0.1f') ' ps']);
disp(['Jitter - 5 percentile = ' num2str(prctile(pulseDeltaT,5)*1e9,'%0.2f') ' ns']);
disp(['Jitter - 5 percentile = ' num2str(prctile(pulseDeltaT,50)*1e9,'%0.2f') ' ns']);
disp(['Jitter - 95 percentile = ' num2str(prctile(pulseDeltaT,95)*1e9,'%0.2f') ' ns']);




