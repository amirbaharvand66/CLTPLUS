function [M] = transformation_matrix(theta)
% transformation matrxi (M) for transforming stress from
% Cartesian to Polar coordinate

% INPUT(S)
% theta: angle on the hole edge

% OUTPUT(S)
% M: transformation matrxi

c = cosd(theta);
s = sind(theta);
M = [c^2            s^2             2 * s * c;
         s^2            c^2             -2 * s * c;
         -s * c          s * c            c^2 - s^2];
