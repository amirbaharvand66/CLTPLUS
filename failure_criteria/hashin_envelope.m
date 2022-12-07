function hashin_envelope(Xt, Xc, Yt, Yc, S)
% plot Hashin-Rotem failure envelope

% INPUT(S)
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength
% id : laminate id

% originally coded by Amir Baharvand (08-20)

n = 50; % number of contours

x = linspace(Xc, Xt, n);
y = linspace(Yc, Yt, n);
[x, y] = meshgrid(x, y);
% sx = ( (sign(x) + 1) / 2 ) .* Xt + ( (sign(x) - 1) / 2 ) .* Xc;
sy = ( (sign(y) + 1) / 2 ) .* Yt + ( (sign(y) - 1) / 2 ) .* Yc;

txy = real(sqrt(((1 - ( y.^2 ./ sy.^2)) * S^2)));

mesh(x, y, txy, 'FaceAlpha', 0.1, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
hold on
mesh(x, y, -txy, 'FaceAlpha', 0.1, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

xlabel('$\sigma_{11}$','Interpreter','latex', 'FontSize', 20)
ylabel('$\sigma_{22}$','Interpreter','latex', 'FontSize', 20)
zlabel('$\sigma_{12}$','Interpreter','latex', 'FontSize', 20)
axis equal