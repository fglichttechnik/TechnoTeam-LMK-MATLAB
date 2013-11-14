function text = LMK_singlePic(dIntegrationTime, iSmear, dModFrequency)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% A CAMERA IMAGE is captured and converted into a LUMINANCE IMAGE. 
    % Input:
    % dIntegrationTime = brightness, e.g 0.5
    % iSmear = number of smear correction (0 = no smear correction)
    % dModFrequency = Modulation Frequency (0 = no modulation)
    %
    % Output:
    % text = information about success or error
    
global labSoft


% take image
errorCode = labSoft.iSinglePic(dIntegrationTime, iSmear, dModFrequency);

% get error information
if errorCode == 0
    text = 'Single Pic has been captured.';
else
    text = LMK_getErrorInformation;
end
disp(text);
end