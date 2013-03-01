function text = LMK_saveProtocol(filename)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Saves current measurement from labSoft into file (.ttcs format).
% 
% Input: filename = full path name of target directory and file name 
%                   (without .ttcs extension)


global labSoft

filename = [filename, '.ttcs'];

% Save protocol into file
errorCode = labSoft.iSaveProtokoll(filename);

% Get information about success or error:
if errorCode ~= 0
    text = LMK_getErrorInformation;
else
    text = 'Protocol has been saved. ';
end
disp(text);

end