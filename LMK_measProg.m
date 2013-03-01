%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% This is a test programm which initiates the application, makes a color
% HighDyn picture and saves it at the current path in .pcf format.

lensPath = 'C:\Programme\TechnoTeam\LabSoft\Camera\DXP2258\oC200952f50';

%init CamNApp
LMK_initApp(1,lensPath);

[dIntegrationTime, drMinTime, drMaxTime] = LMK_getIntegrationTime();
drMaxTime = 1.0;
LMK_colorHighDynPic(drMinTime, drMaxTime, 0, 0);

%LMK_saveImage('.', 'jawImage', clock, 'Color picture');
global labSoft;
picformat = '.pcf';
w = what;
currentPath = w.path;
file_path = [sprintf('%s\jawImage',currentPath), '\', datestr(now), picformat];

errorCode = labSoft.iSaveImage(-1,file_path); % saves color pic in *.pcf format


