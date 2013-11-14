function text = LMK_loadH5Protocol(filename)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Loads protocol in .h5-format into the labSoft program.
%
% Input: filename = full path and filename to the protocoll (string)
% Output: text = string with information about success or error

global labSoft

% Load .h5-Protocol into LabSoft application:
errorCode = labSoft.iImportHDF5Protocol(filename);

% Get information about success or error:
if errorCode ~= 0
    text = LMK_getErrorInformation;
else
    text = 'The protocol has been imported into LabSoft. ';
end
disp(text);

end