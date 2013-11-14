function luminanceImage = LMK_readPfImage(dir_name)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
%   Reads the data from a LMK .pf File and returns the values of the
%   luminosity image.
    % 
    % Input:
    % dir_name = path to file
    %
    % Output:
    % luminanceImage = array of dimension lines-by-columns (single)
    

%read data from given filePath
disp(dir_name)
[fid, message] = fopen(dir_name,'r');
disp(message);

% try
    %read header
    fseek(fid, 32, 'cof');
    lines = str2double(fread(fid, [1 , 4], '*char')); 
    fseek(fid, 10, 'cof');
    columns = str2double(fread(fid, [1, 4], '*char'));
    totalNumberOfBytes = lines*columns*4; % .pf-format has 4 Bytes per pixel.
    
    % initialize:
    luminanceImage = zeros(lines*columns, 1);
    
    % write into array:
    fseek(fid, -totalNumberOfBytes, 'eof');
    luminanceImage = fread(fid, inf, '*float');

fclose(fid);
    
    % luminanceImage is a (columns*lines)-by-1 matrix; reshape into colums-by-lines
    % matrix:    
    l = length(luminanceImage);
    l = floor(l / lines) * lines;
    luminanceImage = luminanceImage(1:l);
    luminanceImageS = reshape(luminanceImage, [], lines)';
    luminanceImage = luminanceImageS;

% catch
%     disp(lasterror.message)
%     disp(lasterror.stack)
%     feof(fid)
%     fclose(fid);

end
