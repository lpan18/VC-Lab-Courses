clear all;

%parameters
sigma     = 2;
threshold = 0.2;
rhoRes    = 2;
thetaRes  = pi/180;

% Load image
I = imread('sfu.jpg');

% Convert to grayscale and scale to [0,1]
if(ndims(I)==3)
    I = rgb2gray(I);
end

I = im2double(I);

% Gaussian filter
I = imgaussfilt(I, sigma);

% Edge filter - use edge()
I = edge(I);
%imshow(I);

% Hough transform
[H] = houghTransform(I, threshold, rhoRes, thetaRes);

% Show normalized H
figure;
imshow(H/max(H(:)))
