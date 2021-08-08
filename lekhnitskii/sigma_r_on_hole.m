function sigma_r_on_hole(epsilon, theta, R, alpha, beta, s_k, h_k, c_k, mkr)
% Calculate radial stress distribution on hole edge

% INPUT(S)
% theta: angle on the hole edge
% R: hole radius
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2
% s_k: characteristic equation roots
% h_k: homogeneous stress field constant
% c_k: mapped disturbance field constant

% OUTPUT(S)
% stress distribution on hole edge

% initializing
sigma_c = zeros(length(theta), 3); % stress components in Cartesian coordinate system
sigma_p = zeros(length(theta), 3); % stress components in Polar coordinate system

for ii = 1:length(theta)
    x = R * cosd(theta(ii));
    y = R * sind(theta(ii));
    z_k = x + s_k * y;
    delta = sqrt(z_k.^2 - s_k.^2 - 1);
    
    % delta sign function
    [sign_delta] = sign_func(theta(ii), alpha, beta, x, y, delta);
    
    % Phi_prime calculator
    [d_phi] = d_phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta);
    
    % stress in Cartesian coordinate system
    [sigma_c(ii, :)] = stress_car(s_k, d_phi);
    
    % stress in Polar coordinate system
    [sigma_p(ii, :)] = stress_polar(sigma_c(ii, :), theta(ii));
end

fig_sigma_r = figure (101);
hold on
set(fig_sigma_r, 'Pos', [0 0 800 600])
plot(deg2rad(theta), sigma_p(:, 1), 'LineStyle', mkr, 'Color', 'k', 'LineWidth', 2, 'DisplayName', sprintf('%d%sHole radius', R, '$\times$'))
set(gca, 'FontSize', 15)
xticks([0 + epsilon, pi/2, pi, 3*pi/2, 2*pi - epsilon])
xticklabels({'0', '$\pi/2$', '$\pi$', '$3\pi/2$', '$2\pi$'})
xlabel('$\theta$[rad]','Interpreter','latex', 'FontSize', 25)
ylabel('$\sigma_{r}/p$' ,'Interpreter','latex', 'FontSize', 25)
legend('Interpreter','latex', 'FontSize', 20, 'Location', 'east')
xlim([deg2rad(theta(1)), deg2rad(theta(end))])
box on