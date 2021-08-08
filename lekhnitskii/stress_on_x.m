function stress_on_x(x_min, x_max, y_min, y_max, n, theta, alpha, beta, s_k, h_k, c_k)
% Calculate stress distribution on x-axis

% INPUT(S)
% x_min, x_max: x-axis range
% y_min, y_max: y-axis range
% n: number of divisons
% theta: angle on the hole edge
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2
% s_k: characteristic equation roots
% h_k: homogeneous stress field constant
% c_k: mapped disturbance field constant

% OUTPUT(S)
% stress distribution on hole edge

% initializing
sigma_c = zeros(length(theta), 3); % stress components in Cartesian coordinate system
x_vec = linspace(x_min, x_max, n);

for ii = 1:length(x_vec)
    x = x_vec(ii);
    y = 0;
    z_k = x + s_k * y;
    delta = sqrt(z_k.^2 - s_k.^2 - 1);
    
    % delta sign function
    [sign_delta] = sign_func(theta(ii), alpha, beta, x, y, delta);
    
    % Phi_prime calculator
    [d_phi] = d_phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta);
    
    % stress in Cartesian coordinate system
    [sigma_c(ii, :)] = stress_car(s_k, d_phi);
end

% remove meaningless stress result inside hole
x = [x_vec(x_vec <= -1), NaN, x_vec(x_vec >= 1)];
s1 = sigma_c(:, 1); sx = [s1(x_vec <= -1); NaN; s1(x_vec >= 1)];
s2 = sigma_c(:, 2); sy = [s2(x_vec <= -1); NaN; s2(x_vec >= 1)];
s3 = sigma_c(:, 3); sxy = [s3(x_vec <= -1); NaN; s3(x_vec >= 1)];

figure('position', [0 0 800 600])
hold on
plot(x, sx, 'k', 'LineWidth', 2)
plot(x, sy, '--k', 'LineWidth', 2)
plot(x, sxy, ':k', 'LineWidth', 2)
plot_hole(0, 0, 1) % plot hole
set(gca, 'FontSize', 15)
xlabel('$x/r$','Interpreter','latex', 'FontSize', 25)
ylabel('$\sigma_{ij}/p$' ,'Interpreter','latex', 'FontSize', 25)
legend('$\sigma_{x}$', '$\sigma_{y}$', '$\tau_{xy}$','Interpreter','latex', 'FontSize', 20)
title('Stress along x-axis','Interpreter','latex', 'FontSize', 20)
box on
xlim([y_min, y_max])
ylim([y_min, y_max])