function text = LMK_highDynPic(drMinTime, drMaxTime, dFactor, iSmear, dModFrequency)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Set filter before you use this function.
% By means of the algorithm HighDyn several camera images with different 
% exposure times are shot and converted into a luminance image. 
%
% Input:
% drMaxTime     = Largest integration time  
% drMinTime     = Smallest integration time (proposal: 0.0)  
% dFactor       = Factor between two times (proposal 3.0)  
% iSmear        = Number of smear images (0=no smear correction)  
% dModFrequency = Modulation frequency (0=no modulation) 
%
% Output:
% text          = String with information about succes or error.

global labSoft

% set filter before you use this function

% Capture camera image:
errorCode = labSoft.iHighDynPic(drMaxTime, drMinTime, dFactor,...
    iSmear, dModFrequency);

% Get the information about succes of error:
if errorCode ~= 0 
    text = LMK_getErrorInformation;
else
    text = 'High dyn picture has been captured.';
end
disp(text);



end