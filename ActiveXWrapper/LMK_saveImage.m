function [text, file_path] = LMK_saveImage(dir_name, file_name, val_date, date_time, picformat)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
% Save image:
    %
    % Input:
    % dir_name = name of destination directory
    % filen_name = name of destination file
    % val_date = value, 0 = no current date and time at the end of the name
    %                   of the file added; 1 = current date and time to be added
    % date_time = date and time when the picture was captured
    % picformat = luminance pictures: '.pf', color images: '.pcf'
    %
    % Output:
    % text = information about success or error
    % file_path = final path where the image has been saved
    
global labSoft 

% specify input parameters:
switch val_date
    case 0
            file_path = [dir_name, '\', file_name, picformat];
    case 1
            file_path = [dir_name, '\', file_name, '_', date_time, picformat];
end

tf1 = strmatch('.pf', picformat);
if tf1 == 1
    picnr = -2;    
end
tf2 = strmatch('.pcf', picformat);
if tf2 == 1
    picnr = -1;      
end

% save image:
errorCode = labSoft.iSaveImage(picnr,file_path);

% get error information:
if errorCode == 0
    text = ['Picture has been saved temporarily (', file_path, ')'];
else
    text = LMK_getErrorInformation;
end
disp(text);
end