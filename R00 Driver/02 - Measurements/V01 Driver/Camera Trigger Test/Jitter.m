clear; clc; close all;
wave = read_rigol_bin('Rigol 50k 4ch0.bin');
V1 = wave(1).y;
V2 = wave(2).y;
V3 = wave(3).y;
V4 = wave(4).y;


samplingRate = 625e6; %Samples/s
t = ((1:length(V1))-1)/samplingRate;


% --- Level-crossing detection with interpolation ---
threshold = 0.03;
minDt = 100;  % minimum samples between accepted pulses

% Rising-edge crossings: sample below threshold, next sample at/above it
above = V1 >= threshold;
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
frac = (threshold - V1(pulseIdx)) ./ (V1(pulseIdx+1) - V1(pulseIdx));
pulseTimes = t(pulseIdx) + frac' ./ samplingRate;   % interpolated trigger times
pulseTimes = pulseTimes(:);  % ensure column

fprintf('Found %d pulses\n', length(pulseTimes));

% --- Plot (decimated background trace, full-res pulse markers) ---
decimateFactor = 1;
idx = 1:decimateFactor:100000;%length(V1);
figure;
plot(t(idx), V1(idx), 'k-'); hold on
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
xlim(mean(pulseDeltaT)*1e9+[-1 1]*5)


%Pulse statistics
disp(['Mean pulse dt = ' num2str(mean(pulseDeltaT)*1e9,'%0.1f') ' ns']);
disp(['Jitter - Standard deviation = ' num2str(std(pulseDeltaT)*1e12,'%0.1f') ' ps']);
disp(['Jitter - 5 percentile = ' num2str(prctile(pulseDeltaT,5)*1e9,'%0.2f') ' ns']);
disp(['Jitter - 5 percentile = ' num2str(prctile(pulseDeltaT,50)*1e9,'%0.2f') ' ns']);
disp(['Jitter - 95 percentile = ' num2str(prctile(pulseDeltaT,95)*1e9,'%0.2f') ' ns']);




