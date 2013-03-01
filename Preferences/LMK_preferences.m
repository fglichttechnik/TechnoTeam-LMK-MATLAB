% ======================================================================
%> @file LMK_preferences.m
%> @brief author Jan Winter, Sandy Buschmann TU Berlin
%> email j.winter@tu-berlin.de
%> 
%> Defines the preferences colormap and currently used lenspath, maximum and 
%> minimun integration time for LMK GUI.
% ======================================================================

global path COLOR_MAP LENS_PATH drMaxTime drMinTime border position1 position2

%> Define preferences
COLOR_MAP = 'hot';

%> load last LENS_PATH if exists:
LENS_PATH = cell(1,4);
a = exist([path, '\preferences.mat'], 'file');
if a ~= 0
    load([path, '\preferences.mat']); 
else %> default
    LENS_PATH{1} = 'Change lens path: ';
    LENS_PATH{2} = 'C:\Programme\TechnoTeam\LabSoft\Camera\DXP2258\oC200952f50';
    LENS_PATH{3} = ' ';
    LENS_PATH{4} = ' ';
    LENS_PATH{5} = 'Chose lens path...';
    drMaxTime = '3.0';
    drMinTime = '0.1';
    border = '0';
    position1 = '10';
    position2 = '20';
    save([path, '\preferences.mat'], 'LENS_PATH');
end
