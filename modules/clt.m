function  [laminate] = clt(mat, varargin)
% function  [A, B, D, Q, a, b, c, d, mbrn, bnd, z, zc, me0k0, ge, le, gs, ls, fail_rpt, ...
%     abd_name] = clt(mat, varargin)
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

% originally coded by Amir Baharvand (AB) (08-20)

%%%%%%%%%%%%%PARSING FUNCTION INPUTS%%%%%%%%%%%%%
% parsing the output
default_load = 'nm'; % force-moment
default_global_strsstrn = 'on'; % plot global stress-strain
default_local_strsstrn = 'on'; % plot local stress-strain
default_failure = 'off'; % failure criterion
default_report = 'off'; % report
default_save_output = 'off'; % save output workspace
% paerse valid option(s)
valid_load = {'nm', 'ek'};
valid_global_strsstrn = {'on', 'off'};
valid_local_strsstrn = {'on', 'off'};
valid_failure = {'off', 'mstrs', 'mstrn', 'TH', 'HR'};
valid_report = {'on', 'off'};
valid_save_output = {'on', 'off'};
% parser checker
check_load = @(x) any(validatestring(x, valid_load));
check_global_strsstrn = @(x) any(validatestring(x, valid_global_strsstrn));
check_local_strsstrn = @(x) any(validatestring(x, valid_local_strsstrn));
check_failure = @(x) any(validatestring(x, valid_failure));
check_report = @(x) any(validatestring(x, valid_report));
check_save_output = @(x) any(validatestring(x, valid_save_output));
% parsing operation
p = inputParser;
addRequired(p, 'mat');
addParameter(p, 'load', default_load, check_load);
addParameter(p, 'global', default_global_strsstrn, check_global_strsstrn);
addParameter(p, 'local', default_local_strsstrn, check_local_strsstrn);
addParameter(p, 'failure', default_failure, check_failure);
addParameter(p, 'report', default_report, check_report);
addParameter(p, 'save_output', default_save_output, check_save_output);
parse(p, mat, varargin{:}); % parsing p
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% assigning material properties
lam = fieldnames(p.Results.mat); % laminate name
t = mat.(lam{:}).ply.t;
theta = mat.(lam{:}).ply.theta;
id = mat.(lam{:}).id;
E11 = mat.(lam{:}).mprop.E11; % longitudinal Young's modulus
E22 = mat.(lam{:}).mprop.E22; % transverse Young's modulus
G12 = mat.(lam{:}).mprop.G12; % in-plane shear modulus
v12 = mat.(lam{:}).mprop.v12; % in-plane Poisson's ratio
Xt = mat.(lam{:}).mprop.Xt; % longitudinal tensite strength
Xc = mat.(lam{:}).mprop.Xc; % longitudinal compression strength
Yt = mat.(lam{:}).mprop.Yt; % transverse tensite strength
Yc = mat.(lam{:}).mprop.Yc; % transverse compression strength
S = mat.(lam{:}).mprop.S; % shear strength
e0 = mat.(lam{:}).load.e0; % applied strain
k0 = mat.(lam{:}).load.k0; % applied curvature
N = mat.(lam{:}).load.N; % applied force
m = mat.(lam{:}).load.m; % applied moment


% ultimate strain values for maximum strain failure criterion
if strcmpi(p.Results.failure, 'mstrn') || strcmpi(p.Results.failure, 'all')
    eXt = Xt / E11; % longitudinal tensite ultimate strain
    eXc = Xc / E11; % longitudinal compression ultimate strain
    eYt = Yt / E22; % transverse tensite ultimate strain
    eYc = Yc / E22; % transverse compression ultimate strain
    eXY = S  / G12; % shear ultimate strain
end


% Reuter matrix
R = reuter_matrix();


% calculating ABD matrix
[A, B, D, Q, z, v21] = abd(t, theta, E11, E22, G12, v12);
ABD = [A, B; B, D];
h = sum(t); % laminate total thickness


% ABD inverse matrices (abd)
[a, b, c, d] = abd_inv(A, B, D);
ABD_inv = [a b; c d];


% laminate stiffness properties (membrane and bending)
[lam_typ] = lam_type(t, theta); % detecting laminate type
[mbrn, bnd] = lam_moduli(B, D, a, d, h, lam_typ);



% mid-plane(m) strains(e0) and curvatures(k) (me0k)
if strcmpi(p.Results.load, 'ek')
    me0k0 = [e0; k0];
elseif strcmpi(p.Results.load, 'nm')
    me0k0 = ABD \ [N; m];
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
if strcmpi(p.Results.global, 'on')
    plot_ge_gs(ge, gs, zc, t, theta, id)
end

% plot local strains (le) and local stress (ls) distribution
if strcmpi(p.Results.local, 'on')
    plot_le_ls(le, ls, zc, t, theta, id)
end

% failure criteria
failure = lower(p.Results.failure);
if strcmpi(failure, 'off')
    fail_rpt = {};
elseif strcmpi(failure, 'mstrs')
    % Maximum stress failure criterion
    [fail_rpt] = mstrs(theta, ls, Xt, Xc, Yt, Yc, S, id);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Maximum stress', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmpi(failure, 'mstrn')
    % Maximum strain failure criterion
    [fail_rpt] = mstrn(theta, v12, v21, le, eXt, eXc, eYt, eYc, eXY, ls, Xt, Xc, Yt, Yc, S, id);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Maximum Stress', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmpi(failure, 'TH')
    % Tsai_Hill failure criterion
    [fail_rpt] = tsai_hill(theta, ls, Xt, Xc, Yt, Yc, S, id);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Tsai-Hill', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)
elseif strcmpi(failure, 'HR')
    % Hashin-Rotem failure criterion
    [fail_rpt] = hashin(theta, ls, Xt, Xc, Yt, Yc, S, id);
    % creating legend
    lgd(1) = plot(nan, nan, 'b', 'LineWidth', 5);
    lgd(2) = plot(nan, nan, 'g', 'LineWidth', 5);
    lgd(3) = plot(nan, nan, 'r', 'LineWidth', 5);
    legend(lgd, {'Hashin-Rotem', 'Unfailed', 'Failed'}, 'Interpreter', 'latex', 'FontSize', 15)

else
    fprintf('Select from one of the options: ')
    fprintf('%s ', valid_failure{:})
    fprintf('\n')
    error('INVALID INPUT!!!')
end


% report
if strcmpi(p.Results.report, 'on')
    clt_report(id, mat, lam, ABD, ABD_inv, mbrn, bnd, p.Results.load, me0k0, zc, ge, gs, le, ls, fail_rpt, p.Results.failure)
end

% save output / workspace
if strcmpi(p.Results.save_output, 'on')
    save('clt_output.mat')
end


% saving laminate data
laminate.abd.A = A;                             laminate.abd.B = B;                                     laminate.abd.D = D;
laminate.abd.Q = Q;                            laminate.prop.v21 = v21;
laminate.abd.a = a;                              laminate.abd.b = b;
laminate.abd.bTranspose = c;             laminate.abd.d = d;
laminate.prop.mbrn = mbrn;              laminate.prop.bnd = bnd;
laminate.ply.z = z;                               laminate.ply.zc = zc;                                     laminate.ply.h = h;
laminate.strsstrn.me0k0 = me0k0;
laminate.strsstrn.gblstrn = ge;            laminate.strsstrn.lclstrn = ls;
laminate.strsstrn.gblstrs = gs;             laminate.strsstrn.lclstrs = ls;
if strcmp(failure, 'off') == 0
    laminate.rpt.failure = fail_rpt;
end


