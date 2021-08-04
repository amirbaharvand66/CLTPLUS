function [r, a] = dir_ang_cal(S)
% directionality and angularity calculator

% INPUT(S)
% S: compliance matrix

% OUTPUT(S)
% r: directionality
% a: angularity

S22 = S(2, 2);
S11 = S(1, 1);
S12 = S(1, 2);
S66 = S(3, 3);

r = sqrt(S22 / S11);
a = 1/2 * (2 * S12 + S66) / S11;