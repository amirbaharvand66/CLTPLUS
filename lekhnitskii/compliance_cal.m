function [S] = compliance_cal(h, A)
% Laminate compliance calculator

% INPUT(S)
% h: laminate thickness
% A: A part of the ABD matrix

% OUTPUT(S)
% S: compliance matrix

C = 1 / h * A; % stiffness matrix
S = inv(C);