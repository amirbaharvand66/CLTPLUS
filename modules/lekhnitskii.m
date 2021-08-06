% read data from clt.m
h = laminate.(string(lamina_name)).ply.h; % h: laminate thickness
A = laminate.(string(lamina_name)).abd.A; % A: A part of the ABD matrix
p = mat.mat2.lekh.load; % load at infinity
p_h = mat.mat2.lekh.hole; % load on hole edge
R = 1; % hole radius
epsilon = 1e-3;
n = 100; % number of divisons
theta = linspace(0 + epsilon, 360 - epsilon, n); % angle on the hole edge

% laminate compliance matrix
[S] = compliance_cal(h, A);

% directionality and angularity 
[r, a] = dir_ang_cal(S);

% characteristic equation roots
[s_k, alpha, beta] = char_eqn_root(r, a);

% Homogeneous Stress Field Constant
[h_k] = h_k_cal(p, s_k);

% Mapped Disturbance Field Constant
[c_k] = c_k_cal(p, p_h, s_k);

% Stress distribution on hole edge
% stress_on_hole(epsilon, theta, R, alpha, beta, s_k, h_k, c_k)

% Stress distribution on x-axis
% stress_on_x(-10, 10, -8, 8, n, theta, alpha, beta, s_k, h_k, c_k)

% Stress distribution on y-axis
% stress_on_y(-8, 8, -10, 10, n, theta, alpha, beta, s_k, h_k, c_k)

R = [1, 5, 10];
mkr = {':', '--', '-'};
% for ii = 1:length(R)
%     sigma_r_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
% end

% for ii = 1:length(R)
%     sigma_theta_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
% end

for ii = 1:length(R)
    tau_rt_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end