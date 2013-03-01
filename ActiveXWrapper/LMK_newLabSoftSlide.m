function LMK_newLabSoftSlide(filter)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
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