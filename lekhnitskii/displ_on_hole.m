function displ_on_hole(S, theta, epsilon, R, alpha, beta, s_k, h_k, c_k)
% Hole deformation

% INPUT(S)
% S: compliance matrix
% theta: angle on the hole edge
% R: hole radius
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2
% s_k: characteristic equation roots
% h_k: homogeneous stress field constant
% c_k: mapped disturbance field constant

% OUTPUT(S)
% deformation around hole 

% initializing
displ = zeros(length(theta), 2); % hoel displacement in Cartesian coordinate system

for ii = 1:length(theta)
    x = R * cosd(theta(ii));
    y = R * sind(theta(ii));
    z_k = x + s_k * y;
    delta = sqrt(z_k.^2 - s_k.^2 - 1);
    
    % delta sign function
    [sign_delta] = sign_func(theta(ii), alpha, beta, x, y, delta);
    
    % Phi calculator
    [phi] = phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta);
    
    % Hole displacement
    [displ(ii, :)] = displ_cal(S, s_k, phi);
end

% extract the scientific part of maximum total displacement (sqrt(c^2 + v^2))
[sci_part, disp_res] = displ_normalizer(displ);
theta_rad = deg2rad(theta);
sf = max(disp_res / (10^sci_part));

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', sprintf('Hole Deformation - scaling factor %f', sf))
polarplot(theta_rad, disp_res / (10^sci_part) * R / min(disp_res / (10^sci_part)), 'k', 'LineWidth', 2)
hold on
polarplot(theta_rad, sin(theta_rad).^2 + cos(theta_rad).^2, '--k', 'LineWidth', 2)
% polarplot properties
pp_prop = gca;
pp_prop.ThetaAxisUnits = 'radians';
set(gca,'FontSize', 15, 'FontName', 'Times New Roman')
legend('Deformed', 'Undeformed','Interpreter','latex', 'FontSize', 20)

figure('position', [0 0 800 600])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Hole Deformation')
hold on
plot(deg2rad(theta), displ(:, 1), 'k', 'LineWidth', 2)
plot(deg2rad(theta), displ(:, 2), '--k', 'LineWidth', 2)
set(gca, 'FontSize', 15)
xticks([0 + epsilon, pi/2, pi, 3*pi/2, 2*pi - epsilon])
xticklabels({'0', '$\pi/2$', '$\pi$', '$3\pi/2$', '$2\pi$'})
xlabel('$\theta$[rad]','Interpreter','latex', 'FontSize', 25)
ylabel('$u_i/r$', 'Interpreter','latex', 'FontSize', 25)
legend('$u$', '$v$','Interpreter','latex', 'FontSize', 20)
xlim([deg2rad(theta(1)), deg2rad(theta(end))])
box on