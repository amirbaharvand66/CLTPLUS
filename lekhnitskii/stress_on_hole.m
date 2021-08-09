function stress_on_hole(epsilon, theta, R, alpha, beta, s_k, h_k, c_k)
% Calculate stress distribution on hole edge in both
% the Cartesian and Polar coordinate system

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

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Stress on Hole Edge - Cartesian')
hold on
plot(deg2rad(theta), sigma_c(:, 1), 'k', 'LineWidth', 2)
plot(deg2rad(theta), sigma_c(:, 2), '--k', 'LineWidth', 2)
plot(deg2rad(theta), sigma_c(:, 3), ':k', 'LineWidth', 2)
set(gca, 'FontSize', 15)
xticks([0 + epsilon, pi/2, pi, 3*pi/2, 2*pi - epsilon])
xticklabels({'0', '$\pi/2$', '$\pi$', '$3\pi/2$', '$2\pi$'})
xlabel('$\theta$[rad]','Interpreter','latex', 'FontSize', 25)
ylabel('$\sigma_{ij}/p$' ,'Interpreter','latex', 'FontSize', 25)
legend('$\sigma_{x}$', '$\sigma_{y}$', '$\tau_{xy}$','Interpreter','latex', 'FontSize', 20, 'location', 'southeast')
xlim([deg2rad(theta(1)), deg2rad(theta(end))])
box on

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Stress on Hole Edge - Polar')
hold on
plot(deg2rad(theta), sigma_p(:, 1), 'k', 'LineWidth', 2)
plot(deg2rad(theta), sigma_p(:, 2), '--k', 'LineWidth', 2)
plot(deg2rad(theta), sigma_p(:, 3), ':k', 'LineWidth', 2)
set(gca, 'FontSize', 15)
xticks([0 + epsilon, pi/2, pi, 3*pi/2, 2*pi - epsilon])
xticklabels({'0', '$\pi/2$', '$\pi$', '$3\pi/2$', '$2\pi$'})
xlabel('$\theta$[rad]','Interpreter','latex', 'FontSize', 25)
ylabel('$\sigma_{ij}/p$' ,'Interpreter','latex', 'FontSize', 25)
legend('$\sigma_{r}$', '$\sigma_{\theta}$', '$\tau_{r\theta}$','Interpreter','latex', 'FontSize', 20, 'location', 'east')
xlim([deg2rad(theta(1)), deg2rad(theta(end))])
box on