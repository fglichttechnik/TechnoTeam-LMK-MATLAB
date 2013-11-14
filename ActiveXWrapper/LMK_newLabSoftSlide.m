function LMK_newLabSoftSlide(filter)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Opens new slide with name filter in LabSoft using TCL commands.
%
% Input: filter = name of the slide (string)

global labSoft

val = 0;
retString = ' ';
execCommand = 'source "$ModulePath/ttip.module"';
[~, val, retString] = labSoft.iExecTclCommand(execCommand, val, retString);
execCommand = 'set Error ""';
[~, val, retString] = labSoft.iExecTclCommand(execCommand, val, retString);
execCommand = 'namespace eval ::ttIP {';
[~, val, retString] = labSoft.iExecTclCommand(execCommand, val, retString);
execCommand = ['CreateImage {', filter, '} {float} {1030 1392 8 3}'];
[~, val, retString] = labSoft.iExecTclCommand(execCommand, val, retString);
execCommand = '}';
[~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);

end