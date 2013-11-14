function text = LMK_initApp(val, lenspath)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% The LMK4 application is started via Active X.
    % Input:
    % val = Input parameter for application mode: 
    %       0 = hide, 1 = show, 2 = showMinimized, 
    %       3 = showNormal, 4 = showMaximized, 
    %       5 = showFullScreen. 
    % lenspath = path to lens configuration files
    %
    % Output: 
    % text = information about success or error
    
global labSoft

% create activeXServer object:
labSoft = actxserver('lmk4.LMKAxServer.1');

% check if application is already opened:
if (~labSoft.iIsOpen) % not opened
    % open application:
    errorCode = labSoft.iOpen;
    if errorCode ~= 0 % error
        text = LMK_getErrorInformation;
    else % no error
        % set show modus:
        labSoft.iShow(val);   
        % set path to lens:
        if ~isempty(lenspath)
            errorCode = labSoft.iSetNewCamera(lenspath);
            if errorCode == 0 % no error
                text = 'Camera and application are ready.';
            else % error
                text = LMK_getErrorInformation;
            end 
        else
            text = 'Application is ready.';
        end
    end
else % opened
    text = 'Camera and application are ready.';
end
disp(text);
end