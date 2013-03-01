function cameraImage = LMK_readPusImage(grabdir)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Reads the data from a LMK .pus File and returns the values of the camera
% image.
    %
    % Input:    grabdir     = path to file
    %
    % Output:   cameraImage = array of dimension lines-by-columns (uint16)


%read data from given filePath
[fid, message] = fopen(grabdir,'r');
disp(message);

% read header:
fseek(fid, 41, 'cof');
lines = str2double(fread(fid, [1 , 4], '*char')); 
fseek(fid, 10, 'cof');
columns = str2double(fread(fid, [1, 4], '*char'));
totalNumberOfBytes = lines*columns*2; % .pus-format has 4 Bytes per pixel.

% initialize:
cameraImage = zeros(lines*columns, 1);

% write into array:
fseek(fid, -totalNumberOfBytes, 'eof');
cameraImage = fread(fid, inf, '*ushort');

fclose(fid);

% image is a (columns*lines)-by-1 matrix; reshape into colums-by-lines
% matrix:    
l = length(cameraImage);
l = floor(l / lines) * lines; 
cameraImage = cameraImage(1:l);
cameraImageS = reshape(cameraImage, [], lines)';
cameraImage = cameraImageS;

end