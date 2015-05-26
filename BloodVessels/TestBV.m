image = double(imread('/Users/rishabgargeya/Desktop/database/DRIVE/training/images/28_training.tif'))...
    ./ 255;
% Symmetric filter params
symmfilter = struct();
symmfilter.sigma     = 2.4;
symmfilter.len       = 8;
symmfilter.sigma0    = 3;
symmfilter.alpha     = 0.7;
% Asymmetric filter params
asymmfilter = struct();
asymmfilter.sigma     = 1.8;
asymmfilter.len       = 22;
asymmfilter.sigma0    = 2;
asymmfilter.alpha     = 0.1;

% Filters responses
% Tresholds values
% DRIVE -> preprocessthresh = 0.5, thresh = 37
[resp segresp r1 r2] = BCOSFIRE(image, symmfilter, asymmfilter, 0.5, 37);
imshow(segresp);