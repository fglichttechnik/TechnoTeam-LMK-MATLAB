function LMK_executeMenuPoint(execCommand)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Executes any menu items of the labSoft program.You can call every menu 
% item of the labSoft main menu, which is available at this time  
% 
% Input: execCommand =  Wished menu item. For example starts 
%                       "Capture|SinglePic" a Singlepic capture. The 
%                       strings have to be written in the same way, as 
%                       they are shown within the program. Because the 
%                       menu strings are language dependend, you have to 
%                       regard this. For example in the german version the 
%                       singlepic capture is called with 
%                       "Aufnahme|SinglePic" instead!  


global labSoft

errorCode = labSoft.iExecMenuPoint(execCommand);

if errorCode ~= 0
    errorMessage = LMK_getErrorInformation();
    disp(errorMessage);
end

end