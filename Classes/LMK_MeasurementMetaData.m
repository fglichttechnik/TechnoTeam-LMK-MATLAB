%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% Class for the last LMK picture that was captured.

classdef LMK_MeasurementMetaData < handle
    properties
        Algorithm       % Capturing algorith, e.g. SinglePic, HighDynPic
        ColorFilter     % Filter wheel, e.g. X1, X2, Z, VL, VS or Glass 
        CameraImages    % Number of several camera images which are converted into a luminance image
        MaxIntTime      % maximum integration time
        MinIntTime      % minimum integration time
        Overflow        % percentage of overdriven pixels
        MaxLoad         % percentage of overdrive
    end % properties
    methods
        %constructor
        function obj = LMK_MeasurementMetaData(lastInfo)
            if nargin > 0 % Support calling with 0 arguments          
                obj.Algorithm = lastInfo{2};
                obj.ColorFilter = lastInfo{4};
                obj.CameraImages = lastInfo{5};
                obj.MaxIntTime = lastInfo{6};
                obj.MinIntTime = lastInfo{7};
                obj.Overflow = lastInfo{8};
                obj.MaxLoad = lastInfo{9};           
            end
        end % constructor
    end % methods
end