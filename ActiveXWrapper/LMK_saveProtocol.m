function text = LMK_saveProtocol(filename)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
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