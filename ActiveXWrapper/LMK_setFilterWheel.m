function LMK_setFilterWheel(filterPosition)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
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