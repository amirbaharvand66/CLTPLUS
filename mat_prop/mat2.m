n = 2; % for laminate id
mat(n).mat.E11 = 142e3; % longitudinal Young's modulus
mat(n).mat.E22 = 13e3; % transverse Young's modulus
mat(n).mat.G12 = 5e3; % in-plane shear modulus
mat(n).mat.v12 = 0.3; % in-plane Poisson's ratio
mat(n).mat.t_ply = 0.16; % ply thickness (in case of same thickness for plies) [mm]
mat(n).mat.Xt = 2200; % longitudinal tensite strength
mat(n).mat.Xc = -1850; % longitudinal compression strength
mat(n).mat.Yt = 55; % transverse tensite strength
mat(n).mat.Yc = -200; % transverse compression strength
mat(n).mat.S = 120; % shear strength


% reuired in case of choosing "maximum strain" as the failure criterion [%]
% mat(n).mat.eXt = mat(n).mat.Xt / mat(n).mat.E11; % longitudinal tensite ultimate strain
% mat(n).mat.eXc = mat(n).mat.Xc / mat(n).mat.E11; % longitudinal compression ultimate strain
% mat(n).mat.eYt = mat(n).mat.Yt / mat(n).mat.E22; % transverse tensite ultimate strain
% mat(n).mat.eYc = mat(n).mat.Yc / mat(n).mat.E22; % transverse compression ultimate strain
% mat(n).mat.eXY = mat(n).mat.S  / mat(n).mat.G12; % shear ultimate strain


% ply thickness and angle
mat(n).ply.t = ones(1, 8) * mat(n).mat.t_ply;
mat(n).ply.theta = [0, -45, 0, 90, 45, 0, 0, 0];
mat(n).id = n;


% loading
mat(n).load.N = [1200; 0; 0]; % e.g. N/mm
mat(n).load.m = [0; 0; 0]; % e.g. N.mm / mm
mat(n).load.e0 = [0; 0; 0]; % e.g. mm / mm
mat(n).load.k0 = [3.3e-3; 0; 0]; % e.g. 1 / mm