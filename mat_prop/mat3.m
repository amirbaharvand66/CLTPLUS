n = 3; % for laminate id
mat(n).mat.E11 = 145e3; % longitudinal Young's modulus
mat(n).mat.E22 = 7e3; % transverse Young's modulus
mat(n).mat.G12 = 3.5e3; % in-plane shear modulus
mat(n).mat.v12 = 0.34; % in-plane Poisson's ratio
mat(n).mat.t_ply = 0.25; % ply thickness (in case of same thickness for plies) [mm]
mat(n).mat.Xt = 1750; % longitudinal tensite strength
mat(n).mat.Xc = -1350; % longitudinal compression strength
mat(n).mat.Yt = 63; % transverse tensite strength
mat(n).mat.Yc = -210; % transverse compression strength
mat(n).mat.S = 80; % shear strength


% ply thickness and angle
mat(n).ply.t = ones(1, 4) * mat(n).mat.t_ply;
mat(n).ply.theta = [0, 90, 45, -45];
mat(n).id = n;

% loading
mat(n).load.N = [126; 0; 0]; % e.g. N/mm
mat(n).load.m = [0; 0; 0]; % e.g. N.mm / mm
mat(n).load.e0 = [0; 0; 0]; % e.g. mm / mm
mat(n).load.k0 = [3.3e-3; 0; 0]; % e.g. 1 / mm