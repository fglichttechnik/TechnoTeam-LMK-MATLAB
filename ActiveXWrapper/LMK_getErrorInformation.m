function text = LMK_getErrorInformation()
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
%  Gets more precisely error description from the
    %  instrument.
    %  
    %  Output: text = String with error stack information. 
    
global labSoft

text = ' ';
[~, text] = labSoft.iGetErrorInformation(text);

end