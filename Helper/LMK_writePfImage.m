function LMK_writePfImage(dir_name, img)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Saves the currently captured luminance image as a image in .pf format
% including header. 
%
% Input:    img         = luminance image; 
%           dir_name    = path where the .pf-Images will be saved.


% read a similar header for success...
fid = fopen([dir_name, '\_vl.pf']);
i = 1:1420; % size of header varies
answer = fscanf(fid, '%c');
myHeader = answer(i);
    % labSoft needs a nullpointer at the end of the header:
    myHeader(1419:1420) = [int8(' ') 0];
fclose(fid);

% create temporary .pf-file
file_name = [dir_name, '\tempImage.pf'];

% write header into file
fid = fopen(file_name, 'w');
fwrite(fid, myHeader, 'char');
fclose(fid);
% image has the same header like the luminance image with VL filter,
% note: the header could be edited if whished

% write binary image data into file
fid = fopen(file_name, 'a');    
    % reshape image because labSoft reads linewise
    [lines, columns] = size(img);
    imageRS = zeros(columns,lines);
    for j = 1:columns
        imageRS(j,:) = img(:, j);
    end    
fwrite(fid, imageRS, 'float32'); 
fclose(fid);

end