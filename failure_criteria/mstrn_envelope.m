function mstrn_envelope(v12, v21, Xt, Xc, Yt, Yc, S)
% plot maximum strain failure envelope


% INPUT(S)
% eXt : longitudinal tensite ultimate strain
% eXc : longitudinal compression ultimate strain
% eYt : transverse tensite ultimate strain
% eYc : transverse compression ultimate strain
% eXY : shear ultimate strain
% id : laminate id

n = 2; % number of contours

% create the appropriate mesh 
x = linspace(Xc, Xt, n);
y = linspace(Yc, Yt, n);
[Xt, Yt] = meshgrid(x, y);
[Xc, Yc] = meshgrid(x, y);

% bounds in maximum strain failure criterion
F1t = Xt + v12 * Yt;
F1c = Xc - v12 * Yc;
F2t = Yt + v21 * Xt;
F2c = Yc - v21 * Xc;

% s11-s22 plane
z = S * ones(size(Xt));
mesh(F1t, F2t, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
z = -S * ones(size(Xt));
mesh(F1t, F2t, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

% s11-s12 plane
S = S * ones(1, n);
mesh([F1t(1, :); F1t(1, :)], [F2t(1, :); F2t(1, :)], [S; -S], 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
mesh([F1t(2, :); F1t(2, :)], [F2t(2, :); F2t(2, :)], [S; -S], 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')

% s22-s12 plane
mesh([F1t(:, 1) F1t(:, 1)], [F2t(:, 1) F2t(:, 1)], [S' -S'], 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
mesh([F1t(:, 2) F1t(:, 2)], [F2t(:, 2) F2t(:, 2)], [S' -S'], 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')



xlabel('$\sigma_{11}$','Interpreter','latex', 'FontSize', 20)
ylabel('$\sigma_{22}$','Interpreter','latex', 'FontSize', 20)
zlabel('$\sigma_{12}$','Interpreter','latex', 'FontSize', 20)
axis equal


