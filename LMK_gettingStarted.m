%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
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
