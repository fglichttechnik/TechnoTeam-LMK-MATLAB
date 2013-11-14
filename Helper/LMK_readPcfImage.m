function [colorImageRGB, colorImageBGR, columns, lines] = LMK_readPcfImage(path)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
%   Reads the data from a LMK .pcf File and returns the values of the color image
    % Input path =              path to file
    % Output colorImageRGB =    lines-by-columns-by-3 array of type float


%read data from given filePath
[fid, message] = fopen(path,'r');
disp(message);


%read header:
fseek(fid, 48, 'cof');
lines = str2double(fread(fid, [1 , 4], '*char'));
fseek(fid, 10, 'cof');
columns = str2double(fread(fid, [1, 4], '*char'));
totalNumberOfBytes = lines*columns*12; % Twelve bytes per pixel. 
    % 3 "Float" values each for the three colors. The chromaticity 
    % values in the file are in the order of blue - green - read.

% initialize:
colorImageBGR = zeros(lines*columns*3, 1);    
bluePlane = zeros(lines*columns, 1);
greenPlane = zeros(lines*columns, 1);
redPlane = zeros(lines*columns, 1);

% read into array:
fseek(fid, -totalNumberOfBytes, 'eof');
colorImageBGR = fread(fid, inf, '*float');

fclose(fid);
    
% colorImageRGB is a (columns*lines)-by-1 matrix; reshape into
% colums-by-lines-by-3 matrix:    
l = length(colorImageBGR);
l = floor(l / lines) * lines;  
colorImageRGBS = colorImageBGR(1:l);    

xb = 1:3:(lines*columns*3);
xg = 2:3:(lines*columns*3);
xr = 3:3:(lines*columns*3);
y = 1:(lines*columns);

bluePlane(y,1) = colorImageRGBS(xb, 1);
greenPlane(y,1) = colorImageRGBS(xg, 1);
redPlane(y,1) = colorImageRGBS(xr, 1);

colorImageB = reshape(bluePlane, [], lines);
colorImageB = colorImageB';
colorImageG = reshape(greenPlane, [], lines);
colorImageG = colorImageG';
colorImageR = reshape(redPlane, [], lines);
colorImageR = colorImageR';

colorImageRGB = zeros(lines, columns, 3);
colorImageRGB(:, :, 1) = colorImageR;
colorImageRGB(:, :, 2) = colorImageG;
colorImageRGB(:, :, 3) = colorImageB;
    
end