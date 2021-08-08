function [sigma_c] = stress_car(s_k, d_phi)
% stress in Cartesian coordinate system

% INPUT(S)
% s_k: characteristic equation roots
% d_phi: Phi_prime

% OUTPUT(S)
% sigma_c: stress components in Cartesian coordinate system

sigma_x = 2 * real(sum(s_k.^2 .* d_phi));
sigma_y = 2 * real(sum(d_phi));
tau_xy = -2 * real(sum(s_k .* d_phi));

sigma_c = [sigma_x, sigma_y, tau_xy];