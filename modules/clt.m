function  [A, B, D, Q, a, b, c, d, mbrn, bnd, z, zc, me0k0, ge, le, gs, ls, fail_rpt] = clt(mat, varargin)
% thick composite laminate theory

% INPUT(S)
% mat: material properties

% OUTPUT(S)
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

% originally coded by Amir Baharvand (08-20)

%%%%%%%%%%%%%PARSING FUNCTION INPUTS%%%%%%%%%%%%%
% parsing the output
default_load = 'nm'; % force-moment
default_global_strsstrn = 'on'; % plot global stress-strain
default_local_strsstrn = 'on'; % plot local stress-strain
default_failure = ''; % failure criterion
% paerse valid option(s)
valid_load = {'nm', 'ek'};
valid_global_strsstrn = {'on', 'off'};
valid_local_strsstrn = {'on', 'off'}; 
valid_failure = {'', 'mstrs', 'mstrn', 'TH','PHR', 'all'};
valid_report = {'on', 'off'}; 
% parser checker
check_load = @(x) any(validatestring(x, valid_load));
check_global_strsstrn = @(x) any(validatestring(x, valid_global_strsstrn));
check_local_strsstrn = @(x) any(validatestring(x, valid_local_strsstrn));
check_failure = @(x) any(validatestring(x, valid_failure));
check_report = @(x) any(validatestring(x, valid_report));
% parsing operation
p = inputParser;
addRequired(p, 'mat');
addParameter(p, 'load', default_load, check_load);
addParameter(p, 'global', default_global_strsstrn, check_global_strsstrn);
addParameter(p, 'local', default_local_strsstrn, check_local_strsstrn);
addParameter(p, 'failure', default_failure, check_failure);
addParameter(p, 'report', default_failure, check_report);
parse(p, mat, varargin{:}); % parsing p
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% assigning material properties
t = mat.ply.t;
theta = mat.ply.theta;
id = mat.id;
E11 = mat.mat.E11; % longitudinal Young's modulus
E22 = mat.mat.E22; % transverse Young's modulus
G12 = mat.mat.G12; % in-plane shear modulus
v12 = mat.mat.v12; % in-plane Poisson's ratio
Xt = mat.mat.Xt;
Xc = mat.mat.Xc;
Yt = mat.mat.Yt;
Yc = mat.mat.Yc;
S = mat.mat.S;
if strcmp(p.Results.failure, 'mstrn') || strcmp(p.Results.failure, 'all')== 1
    eXt = Xt / E11; % longitudinal tensite ultimate strain
    eXc = Xc / E11; % longitudinal compression ultimate strain
    eYt = Yt / E22; % transverse tensite ultimate strain
    eYc = Yc / E22; % transverse compression ultimate strain
    eXY = S  / G12; % shear ultimate strain
end


% Reuter matrix
R = reuter_matrix();


% calculating ABD matrix
[A, B, D, Q, z, v21] = abd(mat);
ABD = [A, B; B, D];
h = sum(t); % laminate total thickness


% ABD inverse matrices (abd)
[a, b, c, d] = abd_inv(A, B, D);


% laminate stiffness properties (membrane and bending)
[mbrn, bnd] = lam_moduli(a, d, h);


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
    all_fc = 'off';
    [fail_rpt] = mstrs(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Maximum stress', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmp(p.Results.failure, 'mstrn') == 1
    % Maximum strain failure criterion
    all_fc = 'off';
    [fail_rpt] = mstrn(theta, v12, v21, le, eXt, eXc, eYt, eYc, eXY, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Maximum Stress', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmp(p.Results.failure, 'TH') == 1
    % Tsai_Hill failure criterion
    all_fc = 'off';
    [fail_rpt] = tsai_hill(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Tsai-Hill', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmp(p.Results.failure, 'PHR') == 1
    % Puck (Hashin-Rotem) failure criterion
    all_fc = 'off';
    [fail_rpt] = puck(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Puck', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmp(p.Results.failure, 'all') == 1
    % All failure criteria
    all_fc = 'on';
    [~] = mstrs(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    [~] = mstrn(theta, v12, v21, le, eXt, eXc, eYt, eYc, eXY, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    [~] = tsai_hill(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    [~] = puck(theta, ls, Xt, Xc, Yt, Yc, S, id, all_fc);
    fail_rpt = {};
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'k', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'm', 'LineWidth', 5);
    lgd(4) = plot(nan, nan, 'c', 'LineWidth', 5);
    lgd(5) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(6) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Maximum stress', 'Maximum Stress', 'Tsai-Hill', 'Puck', 'Unfailed', 'Failed'}...
        , 'Interpreter', 'latex', 'FontSize', 15)
%     legend('1', '2', '3', '4')
end


% report
if strcmp(p.Results.report, 'on') == 1
    ABD_inv = [a b; c d];
    clt_report(id, mat, ABD, ABD_inv, mbrn, bnd, p.Results.load, me0k0, zc, ge, gs, le, ls, fail_rpt, p.Results.failure)
end



