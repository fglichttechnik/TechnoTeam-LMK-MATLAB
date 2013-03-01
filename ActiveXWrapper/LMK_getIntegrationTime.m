function [dIntegrationTime, drMinTime, drMaxTime] = LMK_getIntegrationTime()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Determines current integration time and other time parameters.    
    % If you called the function LMK_autoScanTime before, than
    % dIntegrationTime is the optimal integration time for LMK_singlePic and
    % dIntegrationTime, drMinTime, drMaxTime is optimal for
    % LMK_colorHighDynPic and LMK_highDynPic.
    %
    % Output:
    % dIntegrationTime  = Integration Time for luminance pictures and color
    %                     pictures
    % drMinTime         = Minimal possible time (color pictures)
    % drMaxTime         = Maximal possible time (color pictures)

global labSoft

% Get time parameters:
dIntegrationTime = 0.000000;   % Current integration time     
drPreviousTime = 0.0;       % Next smaller (proposed) time  
drNextTime = 0.0;           % Next larger (proposed) time
drMinTime = 0.0;            % Minimal possible time  
drMaxTime = 0.0;            % Maximal possible time
[errorCode, dIntegrationTime, ~, ~, drMinTime,...
    drMaxTime] = labSoft.iGetIntegrationTime(dIntegrationTime, drPreviousTime, ...
    drNextTime, drMinTime, drMaxTime) ;

% Get information about error or success:
if errorCode ~=0
    text = LMK_getErrorInformation;
    disp(text);
end

end