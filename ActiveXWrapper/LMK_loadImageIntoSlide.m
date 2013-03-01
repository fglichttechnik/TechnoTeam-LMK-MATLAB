function LMK_loadImageIntoSlide(image_dir, slide)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Loads luminance image into "Leuchtdichtebild" slide. Then copies current 
% luminance image from the "Leuchtdichte" slide into "filterName" slide of 
% the labSoft software by using execution TCL commands (see labSoft 
% documentation).
%
% For creating new slides see function LMK_newLabSoftSlide.
% 
% Input: filterName = name of the target slide

global labSoft

% loads image into slide 'Leuchtdichtebild'
[~] = labSoft.iLoadImage(-2, image_dir);

% copy image into its slide with TCL commands (header is given by
% TechnoTeam
    val = 0;
    retString = ' ';
    % every single line must be executed by iExecTclCommand:
    execCommand = 'source "$ModulePath/ttip.module"';
    [~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);
    execCommand = 'set Error ""';
    [~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);
    execCommand = 'namespace eval ::ttIP {';
    [~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);
    % this TCL command copies the image from slide 'Leuchtdichtebild' into
    % wished slide:
    execCommand = ['CopyImage {', slide, '} {_LUMPIC_}'];
    [~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);
    execCommand = '}';
    [~, ~, ~] = labSoft.iExecTclCommand(execCommand, val, retString);


end