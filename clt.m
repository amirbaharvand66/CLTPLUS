function  [A, B, D, Q, a, b, c, d, mbrn, bnd, z, zc, me0k0, ge, le, gs, ls] = clt(mat, varargin)
% thick composite laminate theory


% INPUT(S)
% A : A matrix
% B : B matrix
% D : D matrix
% Q : reduced stiffness matrix for plane stress
% a : a matrix (see ./moduli/lam_moduli.m)
% b : b matrix (see ./moduli/lam_moduli.m)
% d : d matrix (see ./moduli/lam_moduli.m)
% mbrn : laminate stiffness properties (membrane)
% mbrn : laminate stiffness properties (bending)
% z : laminate thickness coordinates
% zc : copy of laminate thickness coordinates
% me0k0 : laminate mid-plane strain-curvature
% ge : laminate global strain
% le : laminate local strain
% gs : laminate global stress
% ls : laminate local stress


% parsing the output
default_load = 'nm'; % force-moment
default_global_strsstrn = 'on'; % plot global stress-strain
default_local_strsstrn = 'on'; % plot local stress-strain
default_failure = ''; % failure criterion
p = inputParser;
addRequired(p, 'mat');
addParameter(p, 'load', default_load);
addParameter(p, 'global', default_global_strsstrn);
addParameter(p, 'local', default_local_strsstrn);
addParameter(p, 'failure', default_failure);
parse(p, mat, varargin{:}) % parsing p


% assigning material properties
t = mat.ply.t;
theta = mat.ply.theta;
id = mat.id;
Xt = mat.mat.Xt;
Xc = mat.mat.Xc;
Yt = mat.mat.Yt;
Yc = mat.mat.Yc;
S = mat.mat.S;


% Reuter matrix
R = reuter_matrix();


% calculating ABD matrix
[A, B, D, Q, z] = abd(mat);
ABD = [A, B; B, D];
h = sum(t); % laminate total thickness


% ABD inverse matrices (abd) and laminate stiffness properties (membrane and bending)
[a, b, c, d, mbrn, bnd] = lam_moduli(A, B, D, h);


% mid-plane(m) strains(e0) and curvatures(k) (me0k)
if strcmp(p.Results.load, 'ek') == 1
    me0k0 = [mat.load.e0; mat.load.k0];
elseif strcmp(p.Results.load, 'nm') == 1
    me0k0 = ABD \ [mat.load.N; mat.load.m];
end


% creating a copy of z for calculating global and local stress-strain 
zc = zeros(1, 2 * length(t)); % copy of thickness coordinates (z)
zc(1) = -h / 2;
zc(end) = h / 2;
cnt = 0;
for ii = 2:length(zc) - 1
    if mod(ii, 2) == 0
        zc(ii) = z(ii - cnt);
    else
        zc(ii) = z(ii - 1 - cnt);
        cnt = cnt + 1;
    end
end


% calculating global strains(ge) for each ply [exx, eyy, exy]
% N.B. due to the existance of a top and bottom surface for each ply, we have
% 2 values for global strains, one for the top and one for the bottom
% surface where the top strain of the bottom ply equals the bottom strain
% of top layer
ge = zeros(2 * length(t), 3);
for ii = 1:length(zc)
    ge(ii, :) = me0k0(1:3)' + zc(ii) * me0k0(4:end)';
end


% calculating global stress(gs) for each ply [sxx, syy, sxy]
% N.B. due to the existance of a top and bottom surface for each ply, we have
% 2 values for global stresses, one for the top and one for the bottom
% surface
gs = zeros(2 * length(t), 3);


for ii = 1:length(theta)
    M = transformation_matrix_plane_stress(theta(ii)); % transformation matrxi (M)
    
    % transformed reduced stiffness matrix
    q = M \ Q * R * M / R; % inv(M) * Q * R * M * inv(R)
    
    % calculating global stress(gs) for each ply
    gs(2 * ii - 1, :) = q * ge(2 * ii - 1, :)';
    gs(2 * ii, :) = q * ge(2 * ii, :)';
    
end


% calculating local strains(le) for each ply [e11, e22, e12 / 2]
le = zeros(2 * length(t), 3);


for ii = 1:length(theta)
    M = transformation_matrix_plane_stress(theta(ii)); % transformation matrxi (M)
    
    % calculating local strains(le) for each ply
    le(2 * ii -1, :) = R * M / R * ge(2 * ii - 1, :)';
    le(2 * ii, :) = R * M / R * ge(2 * ii, :)';
    
end


% calculating local stress(ls) for each ply
ls = zeros(2 * length(t), 3);


for ii = 1:length(theta)
    M = transformation_matrix_plane_stress(theta(ii));
    
    % calculating local stress(ls) for each ply
    ls(2 * ii - 1, :) = M * gs(2 * ii - 1, :)';
    ls(2 * ii, :) = M * gs(2 * ii, :)';
end


% plot global strains (le) and global stress (ls) distribution
if strcmp(p.Results.global, 'on') == 1
    plot_ge_gs(ge, gs, zc, t, theta, id)
end

% plot local strains (le) and local stress (ls) distribution
if strcmp(p.Results.local, 'on') == 1
    plot_le_ls(le, ls, zc, t, theta, id)
end

% failure criteria
if strcmp(p.Results.failure, '') == 1
    fprintf('N.B. No failure criterion is selected!!! \n')
elseif strcmp(p.Results.failure, 'mstrs') == 1
    % Maximum stress failure criterion
    max_stress(theta, ls, Xt, Xc, Yt, Yc, S, id)
elseif strcmp(p.Results.failure, 'TH') == 1
    % Tsai_Hill failure criterion
    tsai_hill(theta, ls, Xt, Xc, Yt, Yc, S, id)
end





