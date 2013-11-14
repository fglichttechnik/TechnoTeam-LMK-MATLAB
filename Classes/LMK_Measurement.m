%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
% Class for the last measurement that was done with LMK_GUI.

classdef LMK_Measurement < handle
    properties
        timeStamp       % time when image was captured
        cameraImage     % m-by-n matrix of the camera photo (black&white)
        dataImage       % m-by-n or m-by-n-by-o matrix of the luminance image
        measurementMetaData   % image parameters of class LMK_MeasurementMetaData
        comments        % comments of the user
        lightSource     % light source
    end % properties
    methods
        %constructor
        function obj = LMK_Measurement(timeStamp, cameraImage, ...
                dataImage, measurementMetaData)
            if nargin > 0 % Support calling with 0 arguments
                obj.timeStamp = timeStamp;
                obj.cameraImage = cameraImage;
                obj.dataImage = dataImage;
                obj.measurementMetaData = LMK_MeasurementMetaData(measurementMetaData);
            end
        end% constructor
    end % methods
end