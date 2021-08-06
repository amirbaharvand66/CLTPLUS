function [S] = compliance_cal(h, a)
% Laminate compliance calculator

% INPUT(S)
% h: laminate thickness
% a: "a" part of the inverse ABD matrix

% OUTPUT(S)
% S: compliance matrix

S = 1 / h * a; 