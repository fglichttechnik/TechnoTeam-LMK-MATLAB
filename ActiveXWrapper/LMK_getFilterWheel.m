function [filterPosition, filterName] = LMK_getFilterWheel()
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Determines filter state from camera.
    % Output: filterName =  Name of current filter (String) 

global labSoft

% Get the filter state:
filterPosition = 0; % Position of filter wheel 
filterName = ' ';   % Name of current filter
[errorCode, filterPosition, filterName] = labSoft.iGetFilterWheel(...
    filterPosition, filterName);

% Display filter name or error information:
if errorCode~=0
    text = LMK_getErrorInformation;
    disp('Maybe camera is not connected.');
    disp(text);
else
    disp('Filtername:');
    disp(filterName);
end

end