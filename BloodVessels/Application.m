function [ ] = Application( )
% Delineation of blood vessels in retinal images based on combination of BCOSFIRE filters responses.
%
% VERSION 09/09/2014
% CREATED BY: George Azzopardi (1), Nicola Strisciuglio (1,2), Mario Vento (2) and Nicolai Petkov (1)
%             1) University of Groningen, Johann Bernoulli Institute for Mathematics and Computer Science, Intelligent Systems
%             1) University of Salerno, Dept. of Information Eng., Electrical Eng. and Applied Math., MIVIA Lab
%
%   If you use this script please cite the following paper:
%   "George Azzopardi, Nicola Strisciuglio, Mario Vento, Nicolai Petkov, 
%   Trainable COSFIRE filters for vessel delineation with application to retinal images, 
%   Medical Image Analysis, Available online 3 September 2014, ISSN 1361-8415, 
%   http://dx.doi.org/10.1016/j.media.2014.08.002"
%
%
% EXAMPLE APPLICATION.

% Example with an image from DRIVE data set
%image = double(imread('/Users/rishabgargeya/Desktop/kaggle/sample/')) ./ 255;
image = double(imread('/Users/rishabgargeya/Desktop/kaggle/sample/15_right.jpeg')) ./ 255;
image = imresize(image, [565 584]);
imshow(image)


%% Symmetric filter params
symmfilter = struct();
symmfilter.sigma     = 2.4;
symmfilter.len       = 8;
symmfilter.sigma0    = 3;
symmfilter.alpha     = 0.7;

%% Asymmetric filter params
asymmfilter = struct();
asymmfilter.sigma     = 1.8;
asymmfilter.len       = 22;
asymmfilter.sigma0    = 2;
asymmfilter.alpha     = 0.1;

%% Filters responses
% Tresholds values
% DRIVE -> preprocessthresh = 0.5, thresh = 37
% STARE -> preprocessthresh = 0.5, thresh = 40
% CHASE_DB1 -> preprocessthresh = 0.1, thresh = 38
figure();
imshow(image);
[resp segresp r1 r2] = BCOSFIRE(image, symmfilter, asymmfilter, 0.9, 30);
figure(2);
imshow(segresp)
%% Calculate Features
stats = regionprops(segresp, 'FilledArea');
AreaPix = nnz(segresp)
BW2 = bwperim(segresp);
imshow(BW2)
PerimPix = nnz(BW2)
skel = bwmorph(segresp,'skel',Inf);
length = nnz(skel);
AvgWidth = AreaPix/length
BP = bwmorph(skel, 'branchpoints');
BranchPoints = nnz(BP)
perim = regionprops(skel,'Perimeter');
tortuosity = perim.Perimeter;
tortuosity = tortuosity/2
