
clear; clc; close all;

LaserAngles = linspace(-3,3,1000); %deg
StartPositionR = linspace(-2,2,2000); %mm

LaserToLensDist = 100; %mm
LensToFiberDist = 25; %mm
FocalLength = 25; %mm


FreeSpace1 = [1 LaserToLensDist; 0 1];
Lens = [1 0; -1/FocalLength 1];
FreeSpace2 = [1 LensToFiberDist; 0 1];

Positions = zeros(length(LaserAngles),length(StartPositionR));
Angles = zeros(length(LaserAngles),length(StartPositionR));

for i=1:length(LaserAngles)
    for j=1:length(StartPositionR)
        StartVector = [StartPositionR(j); deg2rad(LaserAngles(i))];
        EndVector = FreeSpace2 * Lens * FreeSpace1 * StartVector;

        Positions(i,j)=EndVector(1);
        Angles(i,j)=rad2deg(EndVector(2));
    end
end

figure('color','w','Position' ,[177 438 871 301.4000]);
subplot(1,2,1)
imagesc(StartPositionR, LaserAngles,Positions); colormap redblue; set(gca,'ydir','normal');
cb=colorbar; ylabel(cb,'End Position (mm)')
ylabel('Laser Angle (deg)');
xlabel('Start Position (mm)');


subplot(1,2,2)
imagesc(StartPositionR, LaserAngles,Angles); colormap redblue; set(gca,'ydir','normal');
cb=colorbar; ylabel(cb,'End Angle (deg)')
ylabel('Laser Angle (deg)');
xlabel('Start Position (mm)');



