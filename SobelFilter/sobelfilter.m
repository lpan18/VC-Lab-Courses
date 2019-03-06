clear all;

% read image
I = imread('cameraman.tif');

% blur image using gaussian
I = imgaussfilt(I);

% initialize sobel filter masks
sobelX = [1 0 -1; 2 0 -2; 1 0 -1];
sobelY = [1 2 1; 0 0 0; -1 -2 -1];

% convolute
imgX = conv2(I, sobelX, 'same');
imgY = conv2(I, sobelY, 'same');

G = normalize(abs(imgX) + abs(imgY));

imshow(G)