clear; clc; close all;

CSV=readtable("Avalanche Transistor (V+I).csv");
V = CSV.Var1;
I = CSV.Var2;
R=V./I;

dt=1.6e-9;

dataPositions = 5e5-100 + (-100:100);
Vcrop=V(dataPositions);
Icrop=-I(dataPositions)*2/(0.5/6);
Rcrop=R(dataPositions);

cla;
yyaxis left
plot(Vcrop,'b-'); hold on; 
yyaxis right
plot(Icrop,'r-','linewidth',5);

figure; plot(R)

P = Vcrop .* Icrop;
clf;
plot(P)

Energy=trapz(P*dt);

fSwitch=10e3;
AvgPower = Energy * fSwitch




