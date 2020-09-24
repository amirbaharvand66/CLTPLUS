n = 2; % for laminate id

% lamina name
% N.B. with underscore and no space / hyphen
lamina_name = "mat2";

% mechanical properties
mat.(string(lamina_name)).mprop.E11 = 142e3; % longitudinal Young's modulus
mat.(string(lamina_name)).mprop.E22 = 13e3; % transverse Young's modulus
mat.(string(lamina_name)).mprop.G12 = 5e3; % in-plane shear modulus
mat.(string(lamina_name)).mprop.v12 = 0.3; % in-plane Poisson's ratio
mat.(string(lamina_name)).mprop.Xt = 2200; % longitudinal tensite strength
mat.(string(lamina_name)).mprop.Xc = -1850; % longitudinal compression strength
mat.(string(lamina_name)).mprop.Yt = 55; % transverse tensite strength
mat.(string(lamina_name)).mprop.Yc = -200; % transverse compression strength
mat.(string(lamina_name)).mprop.S = 120; % shear strength

% ply thickness and angle
mat.(string(lamina_name)).ply.t_ply = 0.16; % ply thickness (in case of same thickness for plies) [mm]
mat.(string(lamina_name)).ply.t = ones(1, 6) * mat.(string(lamina_name)).ply.t_ply;
mat.(string(lamina_name)).ply.theta = [0, -45, -30, 30, 45, 0];
mat.(string(lamina_name)).id = n;

% loading
mat.(string(lamina_name)).load.N = [1400; 42; 0]; % e.g. N/mm
mat.(string(lamina_name)).load.m = [0; 0; 0]; % e.g. N.mm / mm
mat.(string(lamina_name)).load.e0 = [0; 0; 0]; % e.g. mm / mm
mat.(string(lamina_name)).load.k0 = [3.3e-3; 0; 0]; % e.g. 1 / mm