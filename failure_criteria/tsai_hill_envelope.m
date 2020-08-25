function tsai_hill_envelope(Xt, Xc, Yt, Yc, S, id)
% plot Tsai_Hill failure envelope


% originally coded by Amir Baharvand (08-2020)

n = 50; % number of contours

set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', sprintf('Tsai-Hill Failure Criterion - Laminate %d', id))

x = linspace(Xc, Xt, n);
y = linspace(Yc, Yt, n);
[x, y] = meshgrid(x, y);
sx = ( (sign(x) + 1) / 2 ) .* Xt + ( (sign(x) - 1) / 2 ) .* Xc;
sy = ( (sign(y) + 1) / 2 ) .* Yt + ( (sign(y) - 1) / 2 ) .* Yc;
txy = real(sqrt((1 - (x.^2 ./ sx.^2 + y.^2 ./ sy.^2 - (x .* y) ./ sx.^2)) * S^2));


mesh(x, y, txy, 'FaceAlpha', 0.1)
hold on
mesh(x, y, -txy, 'FaceAlpha', 0.1)
xlabel('$\sigma_{11}$','Interpreter','latex', 'FontSize', 20)
ylabel('$\sigma_{22}$','Interpreter','latex', 'FontSize', 20)
zlabel('$\sigma_{12}$','Interpreter','latex', 'FontSize', 20)
axis equal
