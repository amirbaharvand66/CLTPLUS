function plot_hole(c_x, c_y, r)
% Plot hole

% INPUT(S)
% c_x, c_y: hole center coordinates
% r: radius

theta = linspace(0, 2*pi);
x = r * cos(theta);
y = r * sin(theta);
plot(c_x + x, c_y + y, '-.r', 'LineWidth', 2)
axis equal

