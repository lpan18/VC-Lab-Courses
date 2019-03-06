clc;
clear;
close all;

%create galaxy
galaxy = (rand(10000,3)+rand(10000,3)+rand(10000,3)+rand(10000,3)-2)*0.5;
ball(:,1) = galaxy(:,1)*2;
ball(:,2) = galaxy(:,2)*4;
distance = sum(ball.*ball,2);
angle = atan2(ball(:,1),ball(:,2))+distance;
galaxy(:,1) = distance.*sin(angle);
galaxy(:,2) = distance.*cos(angle);

%do rotation
r1 = 0.6;
r2 = 0.3;
matrix1 = [cos(r1),0,sin(r1);0,1,0;-sin(r1),0,cos(r1)];
matrix2 = [1,0,0;0,cos(r2),sin(r2);0,-sin(r2),cos(r2)];
galaxy = galaxy*matrix1*matrix2;

% use pcshow if you are using new versions of matlab.
%pcshow([galaxy(:,1),galaxy(:,2),galaxy(:,3)]);
% showPointCloud([galaxy(:,1),galaxy(:,2),galaxy(:,3)]);

%Do a PCA and plot the top view (a round disk) of the galaxy
% coeff = pca(galaxy)

[U, S, V] = svd(galaxy);
% galaxy: 10000*3
% V: 3*2 the rows of t represent the new 3 basis vector
% map it into new basis vector (eigen vector)
galaxy = galaxy * V;

% S(:,3) = 0; 
% galaxy = U*S*V';
% figure()
% showPointCloud([galaxy(:,1),galaxy(:,2),galaxy(:,3)]);
figure();
scatter(galaxy(:,1),galaxy(:,2),2);
axis equal