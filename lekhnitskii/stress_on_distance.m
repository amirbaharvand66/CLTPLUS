function stress_on_distance(epsilon, theta, alpha, beta, s_k, h_k, c_k, R)
% Calculate stress components at various distance from hole edge

% INPUT(S)
% theta: angle on the hole edge
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2
% s_k: characteristic equation roots
% h_k: homogeneous stress field constant
% c_k: mapped disturbance field constant
% R: a list of distance

mkr = {':', '--', '-'};

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Hoop Stress')
hold on

for ii = 1:length(R)
    sigma_r_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Radial Stress')
hold on

for ii = 1:length(R)
    sigma_theta_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Shear Stress')
hold on

for ii = 1:length(R)
    tau_rt_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end