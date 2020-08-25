function disp_ply_angle(t, theta, zc)
% display ply angle on plots

% INPUT(S)
% t : ply thickness
% theta : ply angle
% zc : copy of laminate thickness coordinates

% originally coded by Amir Baharvand (08-20)

for jj = 1: length(t)
    z_mean = 0.5 * (zc(2 * jj - 1) + zc(2 * jj));
    text(0, z_mean, strcat(num2str(string(theta(jj))), '$^o$'),'Interpreter','latex', 'FontSize', 10);
end