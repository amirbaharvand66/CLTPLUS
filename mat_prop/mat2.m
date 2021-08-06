n = 2; % for laminate id

% lamina name
% N.B. with underscore and no space / hyphen
lamina_name = "mat2";

% mechanical properties
mat.(string(lamina_name)).mprop.E11 = 145e3; % longitudinal Young's modulus
mat.(string(lamina_name)).mprop.E22 = 7e3; % transverse Young's modulus
mat.(string(lamina_name)).mprop.G12 = 3.5e3; % in-plane shear modulus
mat.(string(lamina_name)).mprop.v12 = 0.34; % in-plane Poisson's ratio
mat.(string(lamina_name)).mprop.Xt = 2200; % longitudinal tensite strength
mat.(string(lamina_name)).mprop.Xc = -1850; % longitudinal compression strength
mat.(string(lamina_name)).mprop.Yt = 55; % transverse tensite strength
mat.(string(lamina_name)).mprop.Yc = -200; % transverse compression strength
mat.(string(lamina_name)).mprop.S = 120; % shear strength

% ply thickness and angle
mat.(string(lamina_name)).ply.t_ply = 0.16; % ply thickness (in case of same thickness for plies) [mm]
mat.(string(lamina_name)).ply.t = ones(1, 10) * mat.(string(lamina_name)).ply.t_ply;
mat.(string(lamina_name)).ply.theta = [45, -45, 90, 0, 0, 0 , 0, 90, -45, 45];
mat.(string(lamina_name)).id = n;

% loading
mat.(string(lamina_name)).load.N = [1400; 42; 0]; % e.g. N/mm
mat.(string(lamina_name)).load.m = [0; 0; 0]; % e.g. N.mm / mm
mat.(string(lamina_name)).load.e0 = [0; 0; 0]; % e.g. mm / mm
mat.(string(lamina_name)).load.k0 = [3.3e-3; 0; 0]; % e.g. 1 / mm

% lekhnitskii solution parameters
% load at infinity
mat.(string(lamina_name)).lekh.load = [1; 1; 0]; % [p_x, p_y, p_xy]
% load on hole edge, c: cosine, s: sine
mat.(string(lamina_name)).lekh.hole = [1/2; 0; 0; 1/2]; % [Xc, Xs, Yc, Yc]