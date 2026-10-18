clear; clc; close all;
wave = read_rigol_bin('Rigol 50k 4ch0.bin');
V1 = wave(1).y;
V2 = wave(2).y;
V3 = wave(3).y;
V4 = wave(4).y;
samplingRate = 625e6; %Samples/s
t = ((1:length(V1))-1)/samplingRate;

% --- Detect pulses on each channel ---
minDt = 100;  % minimum samples between accepted pulses

[pulseTimes1] = detectPulses(V1, t, 0.03, minDt, samplingRate);
[pulseTimes2] = detectPulses(V2, t, 2.0,  minDt, samplingRate);
[pulseTimes3] = detectPulses(V3, t, 2.0,  minDt, samplingRate);

fprintf('V1: Found %d pulses\n', length(pulseTimes1));
fprintf('V2: Found %d pulses\n', length(pulseTimes2));
fprintf('V3: Found %d pulses\n', length(pulseTimes3));

% --- Plot (decimated background trace, full-res pulse markers) ---
decimateFactor = 1;
idx = 1:decimateFactor:100000; %length(V1);

figure;
subplot(3,1,1);
plot(t(idx), V1(idx), 'k-'); hold on
yline(0.03, 'r--');
plot(pulseTimes1, 0.03*ones(size(pulseTimes1)), 'bo');
ylabel('V1 (V)');
title(sprintf('V1: %d pulses detected', length(pulseTimes1)));

subplot(3,1,2);
plot(t(idx), V2(idx), 'k-'); hold on
yline(2.0, 'r--');
plot(pulseTimes2, 2.0*ones(size(pulseTimes2)), 'bo');
ylabel('V2 (V)');
title(sprintf('V2: %d pulses detected', length(pulseTimes2)));

subplot(3,1,3);
plot(t(idx), V3(idx), 'k-'); hold on
yline(2.0, 'r--');
plot(pulseTimes3, 2.0*ones(size(pulseTimes3)), 'bo');
xlabel('Time (s)'); ylabel('V3 (V)');
title(sprintf('V3: %d pulses detected', length(pulseTimes3)));

% --- Pulse spacing histograms ---
plotJitterStats(pulseTimes1, 'V1');

% --- Cross-channel delay between V2 and V3 pulses ---
maxPairDt = 1e-6;  % max allowed delay to consider a valid pair (adjust to your expected delay)
deltaT_V3_V2 = pairPulseDelay(pulseTimes2, pulseTimes3, maxPairDt);

fprintf('Found %d valid V2->V3 pulse pairs\n', length(deltaT_V3_V2));

plotPairDelayStats(deltaT_V3_V2, 'V3 - V2');


% ================= Local functions =================

function pulseTimes = detectPulses(V, t, threshold, minDt, samplingRate)
    % Rising-edge crossings: sample below threshold, next sample at/above it
    above = V >= threshold;
    risingEdge = find(~above(1:end-1) & above(2:end));

    % Enforce minimum spacing (in samples) between accepted pulses
    pulseIdx = [];
    lastIdx = -inf;
    for k = 1:length(risingEdge)
        if risingEdge(k) - lastIdx > minDt
            pulseIdx(end+1) = risingEdge(k); %#ok<AGROW>
            lastIdx = risingEdge(k);
        end
    end

    % Sub-sample interpolation for each accepted crossing
    frac = (threshold - V(pulseIdx)) ./ (V(pulseIdx+1) - V(pulseIdx));
    pulseTimes = t(pulseIdx) + frac' ./ samplingRate;
    pulseTimes = pulseTimes(:);
end

function plotJitterStats(pulseTimes, label)
    pulseDeltaT = diff(pulseTimes);
    pulseDeltaT(pulseDeltaT > 1e-6) = [];

    figure('Color','w');
    histogram(pulseDeltaT*1e9, 200);
    xlabel('\Delta t between pulses (ns)'); ylabel('Count');
    title(sprintf('%s pulse spacing distribution', label));
    xlim(mean(pulseDeltaT)*1e9+[-1 1]*5)

    disp([label ' Mean pulse dt = ' num2str(mean(pulseDeltaT)*1e9,'%0.1f') ' ns']);
    disp([label ' Jitter - Standard deviation = ' num2str(std(pulseDeltaT)*1e12,'%0.1f') ' ps']);
    disp([label ' Jitter - 5 percentile = ' num2str(prctile(pulseDeltaT,5)*1e9,'%0.2f') ' ns']);
    disp([label ' Jitter - 50 percentile = ' num2str(prctile(pulseDeltaT,50)*1e9,'%0.2f') ' ns']);
    disp([label ' Jitter - 95 percentile = ' num2str(prctile(pulseDeltaT,95)*1e9,'%0.2f') ' ns']);
end

function deltaT = pairPulseDelay(tA, tB, maxDt)
    % For each pulse in tA, find nearest pulse in tB and compute tB - tA.
    % Pairs where the nearest match exceeds maxDt are discarded.
    deltaT = nan(length(tA),1);
    for i = 1:length(tA)
        [dtMin, idx] = min(abs(tB - tA(i)));
        if dtMin <= maxDt
            deltaT(i) = tB(idx) - tA(i);
        end
    end
    deltaT(isnan(deltaT)) = [];
    deltaT = deltaT(:);
end

function plotPairDelayStats(deltaT, label)
    figure('Color','w');
    histogram(deltaT*1e9, 200);
    xlabel('\Delta t (ns)'); ylabel('Count');
    title(sprintf('%s pulse delay distribution', label));
    xlim(mean(deltaT)*1e9+[-1 1]*5)

    disp([label ' Mean delay = ' num2str(mean(deltaT)*1e9,'%0.2f') ' ns']);
    disp([label ' Jitter - Standard deviation = ' num2str(std(deltaT)*1e12,'%0.1f') ' ps']);
    disp([label ' Jitter - 5 percentile = ' num2str(prctile(deltaT,5)*1e9,'%0.2f') ' ns']);
    disp([label ' Jitter - 50 percentile = ' num2str(prctile(deltaT,50)*1e9,'%0.2f') ' ns']);
    disp([label ' Jitter - 95 percentile = ' num2str(prctile(deltaT,95)*1e9,'%0.2f') ' ns']);
end

