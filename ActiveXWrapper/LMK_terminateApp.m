function text = LMK_terminateApp()
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
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