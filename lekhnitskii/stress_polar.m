function [sigma_p] = stress_polar(sigma_c, theta)
% stress in Polar coordinate system

% INPUT(S)
% sigma_c: stress components in Cartesian coordinate system
% theta: angle on the hole edge

% OUTPUT(S)
% sigma_p: stress components in Polar coordinate system

M = transformation_matrix(theta);
sigma_p = M * sigma_c';