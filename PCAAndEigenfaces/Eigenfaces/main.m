clc;
clear;
close all;
load('faces.mat');
% images: size=[200,300,250], containing 200 images [250x300]
images = images/255;
faces = reshape(images,[200,300*250]);
% face_1 = squeeze(images(1,:,:));
mean_face = mean(faces, 1);
faces = faces - repmat(mean_face,[200,1]);

%PCA the faces and show the eigenfaces.
[U, S, V] = svd(faces', 'econ');
%Select the first 1 eigenface
U1 = U(:, 1);
eigenface = U1'+mean_face;
img_out = reshape(eigenface,[300,250]);
figure();
imshow(img_out) % 0-1
% we can also use mat2gray to show double values
% imshow(img_out*255,[]);
% imshow(mat2gray(img_out*255));

%Load an image and project it to the "face space" to get a vector representing this image
img = double(imread('1.png'))/255;
% imshow(img);
img = reshape(img,[1,300*250]);
recon = (img-mean_face)*U*U'+mean_face;

%Reconstruct the image by the vector and eigenfaces
recon = reshape(recon,[300,250]);
figure();
imshow(recon);

%Compute PSNR 