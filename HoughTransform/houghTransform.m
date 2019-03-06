function [H] = houghTransform(I, threshold, rhoResolution, thetaResolution)

% Calculate scale bins of H for theta and rho
[m, n] = size(I);
thetaMax = 2*pi;
thetaRange = 0:thetaResolution:thetaMax;
rhoMax = sqrt(m^2+n^2);
rhoRange = 0:rhoResolution:rhoMax;

% Allocate memory for H
H = zeros(size(thetaRange,2), size(rhoRange,2));

% Iterate over image and calculate rho for all theta per pixel
    % Perform voting
for y = 1:m
    for x = 1:n
        if I(y,x) >= threshold
            for theta = thetaRange
                rho = round(x * cos(theta) + y * sin(theta));
                if(rho>=0)
                    rhoPos = floor(rho/rhoResolution) + 1;
                    thetaPos = floor(theta/thetaResolution) + 1;
                    H(thetaPos,rhoPos) = H(thetaPos,rhoPos) + 1;
                end
            end
        end
    end
end
        