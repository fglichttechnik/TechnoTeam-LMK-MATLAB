function [filterPosition, filterName] = LMK_getFilterWheel()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
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