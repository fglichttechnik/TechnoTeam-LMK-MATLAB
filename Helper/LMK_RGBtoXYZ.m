function colorImageXYZ = LMK_RGBtoXYZ(colorImageRGB, colorImageBGR, columns, lines)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Converts a colorimage from color space RGB to XYZ.
    % Input:
    % colorImageRGB = lines-by-columns-by-3 array
    % colorImageBGR = lines*columns-by-1 array
    % columns = has been read in LMK_readPcfImage
    % lines = has been read in LMK_readPcfImage

l = length(colorImageBGR);
l = floor(l / (l/3)) * (l/3);  

% convert colorImageRGB from columns-by-lines-by-3 to columns*lines-by-3:
% c = 1:columns;
% li = 1:lines;
% d = 1:3;% 
% colorImageRGB_2D = zeros((l/3), 3);% 
% rPlane = colorImageRGB(:,:,1);
% gPlane = colorImageRGB(:,:,2);
% bPlane = colorImageRGB(:,:,3);
% to be finished



% convert BGR-Format to XYZ-Format
XYZ = ...
    [1.1302 1.7518 2.7689; 
    0.0601 4.5907 1.0000; 
    5.5943 0.0565 0.0000];

iMatBGR = zeros((l/3), 3);
iMatBGR = reshape(colorImageBGR, 3, (l/3));
r = 1:3;
a = 1:(l/3);
colorImageXYZ = zeros(3, (l/3));
colorImageXYZ(r,a) = XYZ * iMatBGR(r, a);
colorImageXYZ = reshape(colorImageXYZ, l, 1);

% colorImage is a (columns*lines)-by-3 matrix; reshape into
% colums-by-lines-by-3 matrix:    
l = length(colorImageXYZ);
l = floor(l / lines) * lines;  
colorImageS = colorImageXYZ(1:l);    

xb = 1:3:l;
xg = 2:3:l;
xr = 3:3:l;
y = 1:(l/3);

xPlane(y,1) = colorImageS(xb, 1);
yPlane(y,1) = colorImageS(xg, 1);
zPlane(y,1) = colorImageS(xr, 1);

colorImageX = reshape(xPlane, [], lines);
colorImageX = colorImageX';
colorImageY = reshape(yPlane, [], lines);
colorImageY = colorImageY';
colorImageZ = reshape(zPlane, [], lines);
colorImageZ = colorImageZ';

colorImageXYZ = zeros(lines, columns, 3);
colorImageXYZ(:, :, 1) = colorImageX;
colorImageXYZ(:, :, 2) = colorImageY;
colorImageXYZ(:, :, 3) = colorImageZ;
end