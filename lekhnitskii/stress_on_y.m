function stress_on_y(x_min, x_max, y_min, y_max, n, theta, alpha, beta, s_k, h_k, c_k)
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
y_vec = linspace(y_min, y_max, n);

for ii = 1:length(y_vec)
    x = 0;
    y = y_vec(ii);
    z_k = x + s_k * y;
    delta = sqrt(z_k.^2 - s_k.^2 - 1);
    
    % delta sign function
    [sign_delta] = sign_func(theta(ii), alpha, beta, x, y, delta);
    
    % Phi_prime calculator
    [d_phi] = d_phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta);
    
    % stress in Cartesian coordinate system
    [sigma_c(ii, :)] = stress_car(s_k, d_phi);
end

figure('position', [0 0 800 600])
hold on
plot(y_vec, sigma_c(:, 1), 'k', 'LineWidth', 2)
plot(y_vec, sigma_c(:, 2), '--k', 'LineWidth', 2)
plot(y_vec, sigma_c(:, 3), ':k', 'LineWidth', 2)
plot_hole(0, 0, 1) % plot hole
set(gca, 'FontSize', 20)
xlabel('$y/r$','Interpreter','latex', 'FontSize', 25)
ylabel('$\sigma_{ij}/p$' ,'Interpreter','latex', 'FontSize', 25)
legend('$\sigma_{x}$', '$\sigma_{y}$', '$\tau_{xy}$','Interpreter','latex', 'FontSize', 20)
box on
xlim([y_min, y_max])
ylim([y_min, y_max])