function text = LMK_colorHighDynPic(drMinTime, drMaxTime, dFactor, iSmear, dModFrequency)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Capture color camera images.
    % A lot of camera images with different exposure times and with 
    % different color filters are converted into one color image. 
    %
    % Input:
    % drMaxTime = Largest integration time  
    % drMinTime = Smallest integration time (proposal: 0.0)  
    % dFactor = Factor between two times (proposal 3.0)  
    % iSmear = Number of smear images (0=no smear correction)  
    % dModFrequency = Modulation frequency (0=no modulation) 
    %
    % Output:
    % text = String with information about succes or error.
    
global labSoft

% Capture color camera image:
errorCode = labSoft.iColorHighDynPic(drMaxTime, drMinTime, dFactor,...
    iSmear, dModFrequency);

% Get the information about succes of error:
if errorCode ~= 0 
    text = LMK_getErrorInformation;
else
    text = 'Color picture has been captured.';
end
disp(text);

end