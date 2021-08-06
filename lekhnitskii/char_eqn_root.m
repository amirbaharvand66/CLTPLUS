function [s_k, alpha, beta] = char_eqn_root(r, a)
% Characteristic equation roots

% INPUT(S)
% r: directionality
% a: angularity

% OUTPUT(S)
% s_k: characteristic equation roots
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2

alpha = sqrt((r - a) / 2);
beta = sqrt((r + a) / 2);
s1 = alpha+1i * beta;
s2 = -alpha+1i * beta;
s_k = [s1; s2];