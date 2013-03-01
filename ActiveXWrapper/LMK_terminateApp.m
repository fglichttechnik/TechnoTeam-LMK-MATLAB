function text = LMK_terminateApp()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Closes the LabSoft Application.
    % Output: text = Information about success or error.
    
global labSoft path

% close app
errorCode = labSoft.iClose(0); 
% 1: Dialog window opens whether user wants to save the current state or
% cancel closing the application.
% 0: No dialog window

% get error Information
switch errorCode
    case 0
        text = 'Application is closed.';
    case 1
        text = 'Application was not closed.';
    otherwise
        text = LMK_getErrorInformation;
end
disp(text);

% remove temporary folder:
rmpath([path, '\Temp']);
[~, ~] = lastwarn;
[stat, mess, ~] = rmdir('Temp','s');

if stat == 0
    disp(mess);
end
end