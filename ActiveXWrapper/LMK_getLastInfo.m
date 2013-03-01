function [lastInfo, lastInfoName] = LMK_getLastInfo()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Determines information about the preceeding capture from camera.

global labSoft

% initialize:
irSucces = 0;           % 1=success, 0=no success 
irAlgorithm = 0;        % 1=SinglePic ... 4=ColorHighDyn 
qrGreyFilter = ' ';     % Unused 
qrColorFilter = ' ';    % List of color filters  
ulpPicCount = 0;        % Number of camera images (MultiPic)  
drMaxIntTime = 0.0;     % Maximal integration time 
drMinIntTime = 0.0;     % Minimal integration time  
drOverflow = 0.0;       % Percentage of overdriven pixels 
drMaxLoad = 0.0;        % Percentage of overdrive  
drCaptureTime = 0.0;    % Capture date and time as double number  
irSmear = 0;            % Number of smear images 
drFrequency = 0.0;      % Modulation frequency 

% give names:
lastInfoName{1}= 'Succes: ';
lastInfoName{2}= 'Algorithm: ';
lastInfoName{3}= 'Grey Filter: ';
lastInfoName{4}= 'Color Filter: ';
lastInfoName{5}= 'Camera images: ';
lastInfoName{6}= 'max. IntTime: ';
lastInfoName{7}= 'min. IntTime: ';
lastInfoName{8}= 'Overflow: ';
lastInfoName{9}= 'max. Load: ';
lastInfoName{10}= 'Capture Time: ';
lastInfoName{11}= 'Smear images: ';
lastInfoName{12}= 'Modulation Frequency ';

% get information from camera:
[errorCode, irSucces, irAlgorithm, qrGreyFilter, qrColorFilter, ulpPicCount,...
    drMaxIntTime, drMinIntTime, drOverflow, drMaxLoad, drCaptureTime, ...
    irSmear, drFrequency] = ...
    labSoft.iCaptureGetLastInfo(irSucces, irAlgorithm, qrGreyFilter, ...
    qrColorFilter, ulpPicCount, drMaxIntTime, drMinIntTime, drOverflow,...
    drMaxLoad, drCaptureTime, irSmear, drFrequency);

% precise information if no error occured:
if errorCode == 0 % no error
    % success or no success:
    if irSucces == 1, succes = 'YES';
    else succes = 'NO';
    end
    lastInfo{1}= succes; 
    % kind of image:
    switch irAlgorithm
        case 0, lastInfo{2} = 'Camera Picture';
        case 1, lastInfo{2} = 'Single Luminance Picture';
        case 2, lastInfo{2} = 'Multi Luminance Picture';
        case 3, lastInfo{2} = 'HighDyn Luminance Picture'; 
        case 4, lastInfo{2} = 'HighDyn Color Picture';  
        otherwise, lastInfo{2} = '???';
    end
    % grey filter (unused):
    lastInfo{3}= qrGreyFilter;
    % color Filter:
    tf = strmatch('VL', qrColorFilter);
    if tf == 1, qrColorFilter = 'V(lambda)';
    end
    tf = strmatch('VS', qrColorFilter);
    if tf == 1, qrColorFilter = 'V´(lambda)';
    end    
    lastInfo{4}= qrColorFilter;
    
    % time parameters:
    lastInfo{5}= ulpPicCount;
    lastInfo{6}= drMaxIntTime;
    lastInfo{7}= drMinIntTime;
    lastInfo{8}= drOverflow;
    lastInfo{9}= drMaxLoad;    
    
    %   drCaptureTime is a serial date number. Convert date into date vector
    %   and correct false date (110 instead of 2010 and one day back):
    drCaptureTime = datevec(drCaptureTime);
    drCaptureTime = num2cell(drCaptureTime);
    drCaptureTime{1} = drCaptureTime{1} + 1900;
    drCaptureTime{3} = drCaptureTime{3} - 1;
    drCaptureTime = [num2str(drCaptureTime{1}),'-',...
    num2str(drCaptureTime{2}), '-', num2str(drCaptureTime{3}), '-', ...
    num2str(drCaptureTime{4}), '-', num2str(drCaptureTime{5}), '-', ...
    num2str(drCaptureTime{6})];    
    lastInfo{10}= drCaptureTime;
    
    % smear correction:
    lastInfo{11}= irSmear;
    % frequency modulation:
    lastInfo{12}= drFrequency;    
    
else % error
    lastInfo = zeros(1,12);
    lastInfo{1} = LMK_getErrorInformation; 
    for n = 2:12
        lastInfo{n} = ' ';
    end
    disp(lastInfo);
end

end