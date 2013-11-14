function text = LMK_autoScanTime()
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%> @brief author Sandy Buschmann, Jan Winter TU Berlin
%> email j.winter@tu-berlin.de
%>
%> One or more CAMERA IMAGES are captured.
    %> After each capture the brightness of the image is checked. 
    %> If the brightest parts of an image are not overdriven yet this image 
    %> is said to have its optimal brightness. The program corrects the 
    %> exposure time automatically taking further shots as long as the 
    %> optimal brightness has been achieved.
    %> After calling this function, the camera will capture images with the
    %> optimal integration time.
    %> To get the integration time use function LMK_getIntegrationTime.
    %>
    %> @retval text string with information about success or error.

global labSoft

%> Set optimal brightness:
errorCode = labSoft.iAutoScanTime();

%> Get information about success or error:
if errorCode ~= 0
    text = LMK_getErrorInformation;
else
    text = 'Autoscan time has been set. ';
end
disp(text);

end