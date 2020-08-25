function [M] = transformation_matrix_plane_stress(theta)
% transformation matrxi (M) for transforming each ply local coordinate
% system to the global coordinate system

% INPUT(S)
% theta : ply angle

% originally coded by Amir Baharvand (08-20)
    
for ii = 1:length(theta)
    c = cosd(theta(ii));
    s = sind(theta(ii));
    M = [c^2            s^2             2 * s * c;
             s^2            c^2             -2 * s * c;
             -s * c          s * c            c^2 - s^2];
end