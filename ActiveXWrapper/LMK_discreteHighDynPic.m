function [text, highDynXYZL] = LMK_LMK_discreteHighDynPic(drMinTime, drMaxTime, dFactor, ...
        iSmear, dModFrequency)
% This function is currently not used in the LMK_menu GUI.
%
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Captures one HighDyn picture for each filter, corrects the resulting 
% image with given filter parameters, creates LMK_measurement object and
% saves measurement.
%
% Input:    drMinTime       = minimum integration time
%           drMaxTime       = maximum integration time
%           dFactor         = Factor between two times (proposal 3.0) 
%           iSmear          = Number of smear images (0=no smear correction)  
%           dModFrequency   = Modulation frequency (0=no modulation) 
%
% Output:   text            = String with information about succes or error.
%           highDynXYZL     = filter corrected image with X, Y, Z, L, LS dimension

global labSoft path 

% path = pwd;
highDynImage = zeros(1032, 1379, 5); 

% capture 5 images = for filter X1, X2, Z, VL, VS:
for i = 1 : 5

    % set filter wheel X1...VS
    LMK_setFilterWheel(i);
    [~, ~] = LMK_getFilterWheel; 
    
    % take high dyn picture
    errorCode = labSoft.iHighDynPic(drMaxTime, drMinTime, dFactor, ...
        iSmear, dModFrequency);       
    
    % Get the information about succes or error:
    if errorCode ~= 0 
        text = LMK_getErrorInformation;
    else
        text = 'High dyn picture has been captured.';
    end
    disp(text);
    [lastInfo, ~] = LMK_getLastInfo();
    
    % save image temporarily
    dir_name = [path, '\Temp'];
    switch i
        case 1
            file_name = '_x1';
        case 2
            file_name = '_x2';
        case 3
            file_name = '_z'; 
        case 4
            file_name = '_v'; 
    end
    date_time = lastInfo{10};
    val_date = 0;
    picfor = lastInfo{2};   
    tf1 = strmatch('Single Luminance Picture', picfor);
    if tf1 == 1
        picformat = '.pf';
    end
    tf2 = strmatch('HighDyn Color Picture', picfor);
    if tf2 == 1
        picformat = '.pcf';
    end
    tf3 = strmatch('HighDyn Luminance Picture', picfor);
    if tf3 == 1
        picformat = '.pf';
    end
    [text, filepath] = LMK_saveImage(dir_name, file_name, val_date, date_time,...
    picformat);
    set(status, 'String', text);

    % read image
    dir_name = filepath;          
    highDyn = LMK_readPfImage(dir_name);         
    highDynImage(:,:,i) = highDyn; 
end         
    
    % define parameters for filter correction:
    XYZL = [0.056618 1.0718 -0.0097523 0.0074725 1;...
        0.0030606 -0.060261 -0.0034014 1.0874 1;...
        0.19087 0.011688 0.14489 -0.0094411 1;...
        0.0030606 -0.060261 -0.0034014 1.0874 1;...
        1 1 1 1 1];
    
    f1_l = 0.9704;    
    f2_x = 0.9742;
    f2_y = 0.9704;
    f2_z = 0.9629;    
    
    % reshape highDynImage for matrix operations:    
    X1 = reshape(highDynImage(:, :, 1), 1, []);    
    X2 = reshape(highDynImage(:, :, 2), 1, []);    
    Z = reshape(highDynImage(:, :, 3), 1, []);
    VL = reshape(highDynImage(:, :, 4), 1, []);
    VS = reshape(highDynImage(:, :, 5), 1, []);
    
    l = length(X1); 
    l = floor(l / (l/3)) * (l/3);
    
    [lines, columns, ~] = size(highDynImage);
    
    highDynR = [X1;...
        X2;...
        Z;...
        VL;...
        VS];
    
    a = 1 : l;    
    highDynXYZLR(:,a) = XYZL * highDynR(:, a);
        
    % re-reshape image:    
    X = reshape(highDynXYZLR(1,:), lines, columns);
    Y = reshape(highDynXYZLR(2,:), lines, columns);
    Z = reshape(highDynXYZLR(3,:), lines, columns);
    L = reshape(highDynXYZLR(4,:), lines, columns);
    LS = reshape(highDynXYZLR(5,:), lines, columns);
    
    highDynXYZL(:, :, 1) = X .* f2_x;
    highDynXYZL(:, :, 2) = Y .* f2_y;
    highDynXYZL(:, :, 3) = Z .* f2_z;
    highDynXYZL(:, :, 4) = L .* f1_l; 
    highDynXYZL(:, :, 5) = LS; 
    
     %create LMK_Measurement object and save:
    for v = 1 : 9
        measurementMetaData{v} = lastInfo{v};
    end
    measurementMetaData{10} = lastInfo{11};
    measurementMetaData{11} = lastInfo{12};
    % measurementMetaData = 'High Dyn Luminance Image';
    dataImage = highDynImage;    
    cameraImage = highDynImage;
    LMK_measurements = LMK_Measurement(date_time, cameraImage, ...
        dataImage, measurementMetaData);
    imageNames = properties(LMK_measurements.measurementMetaData);

    save('Temp\measurements.mat', 'LMK_measurements'); 

    text = 'High dyn pictures have been captured and saved temporarily.';
    set(status, 'String', text);
end