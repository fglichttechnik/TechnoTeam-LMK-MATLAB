function text = LMK_getErrorInformation()
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
%  Gets more precisely error description from the
    %  instrument.
    %  
    %  Output: text = String with error stack information. 
    
global labSoft

text = ' ';
[~, text] = labSoft.iGetErrorInformation(text);

end