function mstrs_envelope(Xt, Xc, Yt, Yc, S, all_fc)
% plot maximum stress failure envelope


% INPUT(S)
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength
% id : laminate id


n = 2; % number of contours

x = linspace(Xc, Xt, n);
y = linspace(Yc, Yt, n);
[x, y] = meshgrid(x, y);
z = S * ones(size(x));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end
z = S * ones(size(x));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end

x = linspace(Xc, Xt, n);
z = linspace(-S, S, n);
[x, z] = meshgrid(x, z);
y = Yc * ones(size(x));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end
y = Yt * ones(size(x));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end

y = linspace(Yc, Yt, n);
z = linspace(-S, S, n);
[y, z] = meshgrid(y, z);
x = Xc * ones(size(y));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end
x = Xt * ones(size(y));
if strcmp(all_fc, 'on') == 1
    mesh(x, y, z, 'FaceColor','k', 'FaceAlpha',0.1, 'EdgeColor','none')
else
    mesh(x, y, z, 'FaceColor','b', 'FaceAlpha',0.1, 'EdgeColor','none')
end


xlabel('$\sigma_{11}$','Interpreter','latex', 'FontSize', 20)
ylabel('$\sigma_{22}$','Interpreter','latex', 'FontSize', 20)
zlabel('$\sigma_{12}$','Interpreter','latex', 'FontSize', 20)
axis equal


