function [h_k] = h_k_cal(p, s_k)
% Homogeneous Stress Field Constant

% INPUT(S)
% p: load at infinity
% s_k: characteristic equation roots

% OUTPUT(S)
% h_k: homogeneous stress field constant

p_x = p(1);
p_y = p(2);
p_xy = p(3);
h_k = zeros(2, 1);

for k = 1:2
    l = 3 - k;
    h_k(k, 1) = 1/2 * (p_x - p_y * s_k(l)^2) / (s_k(k)^2 - s_k(l)^2) - p_xy / (4 * s_k(k));
end