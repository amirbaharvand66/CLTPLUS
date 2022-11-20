function mstrs_envelope(Xt, Xc, Yt, Yc, S)
% plot maximum stress failure envelope

% INPUT(S)
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength
% id : laminate id

% originally coded by Amir Baharvand (08-20)

n = 2; % number of contours

x = linspace(Xc, Xt, n);
y = linspace(Yc, Yt, n);
[x, y] = meshgrid(x, y);

z = S * ones(size(x));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
z = S * ones(size(x));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

x = linspace(Xc, Xt, n);
z = linspace(-S, S, n);
[x, z] = meshgrid(x, z);

y = Yc * ones(size(x));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
y = Yt * ones(size(x));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

y = linspace(Yc, Yt, n);
z = linspace(-S, S, n);
[y, z] = meshgrid(y, z);

x = Xc * ones(size(y));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
x = Xt * ones(size(y));
mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

xlabel('$\sigma_{11}$','Interpreter','latex', 'FontSize', 20)
ylabel('$\sigma_{22}$','Interpreter','latex', 'FontSize', 20)
zlabel('$\sigma_{12}$','Interpreter','latex', 'FontSize', 20)
axis equal
