function LMK_setFilterWheel(filterPosition)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Sets new filter position.
    % Input: filterPosition = integer, 
    %                         0 = Glass, 1 = X1, 2 = X2, 3 = Z, 
    %                         4 = V(lambda), 5 = V'(lambda)
    
global labSoft

% set filter:
errorCode = labSoft.iSetFilterWheel(filterPosition);

% get error information:
if errorCode~=0
    text = LMK_getErrorInformation;
    disp(text);
end

end