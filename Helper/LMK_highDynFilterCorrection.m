function highDynXYZL = LMK_highDynFilterCorrection(highDynImage)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Calculates the X, Y, Z, LS parameters of the HighDyn image using the 
% filter correction parameters given by LabSoft.
% Input highDynImage =  HighDyn picture made with LabSoft with filters 
%                       X1, X2, Z, VL, and VS.
% Output highDynXYZL =  Filter corrected image with X, Y, Z, Ls dimensions.

% define parameters for filter correction:
X1X2ZVVs = [0.056618 1.0718 -0.0097523 0.0074725 0;...
    0.0030606 -0.060261 -0.0034014 1.0874 0;...
    0.19087 0.011688 0.14489 -0.0094411 0;...
    0.0030606 -0.060261 -0.0034014 1.0874 0;...
    0 0 0 0 1];

f1_l = 0.9704;    
f2_x = 0.9742;
f2_y = 0.9704;
f2_z = 0.9629;    
f1_ls = 0.9704;

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
highDynXYZLR(:,a) = X1X2ZVVs * highDynR(:, a);

% re-reshape image:    
X = reshape(highDynXYZLR(1,:), lines, columns);
Y = reshape(highDynXYZLR(2,:), lines, columns);
Z = reshape(highDynXYZLR(3,:), lines, columns);
L = reshape(highDynXYZLR(4,:), lines, columns);
LS = reshape(highDynXYZLR(5,:), lines, columns);

highDynXYZL(:, :, 1) = X .* f2_x;      %X
highDynXYZL(:, :, 2) = Y .* f2_y;      %Y = L
highDynXYZL(:, :, 3) = Z .* f2_z;      %Z
highDynXYZL(:, :, 4) = LS .* f1_ls;    %LS
%highDynXYZL(:, :, 5) = L .* f1_l; %L = Y not needed

end