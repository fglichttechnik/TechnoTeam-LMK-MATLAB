%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% Defines the path (your current working directory) and starts the LMK GUI.

global path
path = pwd;

% Create temporary directory:
[s, mess, messid] = mkdir('Temp');
if s ~= 1
    disp('error');
end

% Define preferences:
LMK_preferences;

% Open initFig-GUI to chose the lens path:
LMK_initFig;
uiwait(LMK_initFig);

% Open the Menu-GUI:
LMK_menue;
