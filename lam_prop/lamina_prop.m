n = 1; % for laminate id

% lamina mechanical properties
if strcmpi(micro_cal, 'on')
    fiber_resin_prop;
    [mat.(string(lamina_name)).mprop.rho, ...
        mat.(string(lamina_name)).mprop.E11 ,...
        mat.(string(lamina_name)).mprop.E22, ...
        mat.(string(lamina_name)).mprop.G12, ...
        mat.(string(lamina_name)).mprop.v12] = micro_mech_cal(micro, micro_method);
else
    lamina_name = "lam2";
    % lamina name
    % N.B. with underscore and no space / hyphen
    mat.(string(lamina_name)).mprop.E11 = 145e3; % longitudinal Young's modulus
    mat.(string(lamina_name)).mprop.E22 = 7e3; % transverse Young's modulus
    mat.(string(lamina_name)).mprop.G12 = 3.5e3; % in-plane shear modulus
    mat.(string(lamina_name)).mprop.v12 = 0.34; % in-plane Poisson's ratio
end

% lamina strength
mat.(string(lamina_name)).mprop.Xt = 2200; % longitudinal tensite strength
mat.(string(lamina_name)).mprop.Xc = -1850; % longitudinal compression strength
mat.(string(lamina_name)).mprop.Yt = 55; % transverse tensite strength
mat.(string(lamina_name)).mprop.Yc = -200; % transverse compression strength
mat.(string(lamina_name)).mprop.S = 120; % shear strength

% ply thickness and angle
mat.(string(lamina_name)).ply.t_ply = 0.15; % ply thickness (in case of same thickness for plies) [mm]
mat.(string(lamina_name)).ply.theta = [90, 90, 90, 90, 0, 0, 0, 0, 0, 0, 0, 0, 90, 90, 90, 90];
n_layers = length(mat.(string(lamina_name)).ply.theta);
mat.(string(lamina_name)).ply.t = ones(1, n_layers) * mat.(string(lamina_name)).ply.t_ply;
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