function [text, cameraImage] = LMK_grab()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
%A single CAMERA IMAGE with the CURRENT INTEGRATION TIME is captured.
    % Output:
    % cameraImage = array (dimension lines by colums) of type uint16
    % text = information about success or error

global labSoft
global path

% set optimal brightness:
LMK_autoScanTime();

% capture the camera image:
error = labSoft.iGrab(); 
if error == 0 % no error
    % define temporary path and filename:
    grabdir = [path, '\Temp\grab.pus'];

    % save picture from camera to temporary file:
    errorCode = labSoft.iSaveImage(-3,grabdir);  

    % load image from file into an array:
    if errorCode == 0 % no error
        cameraImage = LMK_readPusImage(grabdir); 
    else % error
        text = LMK_getErrorInformation;
        disp(text);
    end
    text = 'Camera image has been captured and saved temporarily (\Temp\grab.pus)';
else % error
    text = LMK_getErrorInformation;
end
disp(text);
end