function clt_report(id, mat, lam, ABD, abd, mbrn, bnd, loading, me0k0, zc, ge, gs, le, ls, fail_rpt, fail_crtrn)
% reporting for composite laminate theory

% INPUT(S)
% laminate: composite laminate
% mat: material properties
% lam : laminate name
% n: laminate id
% loading: loading type ('ek' / 'nm')
% fail_crtrn: failure criterion

% OUTPUT(S)
% results from CLT module in a formatted Excel worksheet

% originally coded by Amir Baharvand (08-20)


% turn off warning of added specified worksheet
warning( 'off', 'MATLAB:writematrix:AddSheet' );


% creating report file name
rpt_file_name = sprintf('laminate%d_rpt.xlsx', id);
sheet = sprintf('laminate%d', id);


% remove the residual file from previou run(s)
recycle on
delete(rpt_file_name)


% ABD
writematrix(['A' 'B'; 'B' 'D'], rpt_file_name, 'Sheet', sheet, 'Range', 'A3:B4');
writematrix(ABD, rpt_file_name, 'Sheet', sheet, 'Range', 'C1:H6');


%abd
writematrix(['a' 'b'; 'b' 'd'], rpt_file_name, 'Sheet', sheet, 'Range',  'A10:B11');
writematrix(abd, rpt_file_name, 'Sheet', sheet, 'Range', 'C8:H13');


% laminate membrane stiffnesses
writecell(cellstr('Laminate membrane stiffnesses'), rpt_file_name, 'Sheet', sheet, 'Range', 'A15:A15');
writecell(mbrn, rpt_file_name, 'Sheet', sheet, 'Range', 'C15');


% laminate bending stiffnesses
writecell(cellstr('Laminate bending stiffnesses'), rpt_file_name, 'Sheet', sheet, 'Range', 'A18:A18');
writematrix(bnd, rpt_file_name, 'Sheet', sheet, 'Range', 'C18:G19');


% mid-plane strain-curvature

e0 = mat.(lam{:}).load.e0; % applied strain
k0 = mat.(lam{:}).load.k0; % applied curvature
N = mat.(lam{:}).load.N; % applied force
m = mat.(lam{:}).load.m; % applied moment
load_tag = {'Nx'; 'Ny'; 'Nxy'; 'Mx.'; 'My'; 'Mxy'};
ek_tag = {'e0x.'; 'e0y.'; 'e0xy'; 'k0x.'; 'k0y'; 'k0xy'};
writecell(cellstr('Applied load'), rpt_file_name, 'Sheet', sheet, 'Range', 'A21:A21');
writecell(load_tag, rpt_file_name, 'Sheet', sheet, 'Range', 'A22:A27');
writecell(ek_tag, rpt_file_name, 'Sheet', sheet, 'Range', 'C22:C27');
if loading == 'ek'
    nm = ABD * [e0; k0];
    writematrix(nm, rpt_file_name, 'Sheet', sheet, 'Range', 'B22:B27');
    writematrix([e0; k0], rpt_file_name, 'Sheet', sheet, 'Range', 'D22:D27');
elseif loading == 'nm'
    writematrix([N; m], rpt_file_name, 'Sheet', sheet, 'Range', 'B22:B27');
    writematrix(me0k0, rpt_file_name, 'Sheet', sheet, 'Range', 'D22:D27');
end


% 10-percent rule
t = mat.(lam{:}).ply.t;
theta = mat.(lam{:}).ply.theta;
writecell(cellstr('10% rule'), rpt_file_name, 'Sheet',  sheet, 'Range', 'A29:A29');
[tag, zero_of_tot, p45_of_tot, m45_of_tot, ninty_of_tot] = ten_percent_rule(t, theta);
writecell(tag, rpt_file_name, 'Sheet', sheet, 'Range', 'A30:A33');
writematrix([zero_of_tot p45_of_tot m45_of_tot ninty_of_tot]', rpt_file_name, 'Sheet', sheet, ...
    'Range', 'B30:B33');
% pop-up message for 10-percent rule in case of invasion
if ( zero_of_tot + p45_of_tot + m45_of_tot + ninty_of_tot ) <= 10
    writecell(cellstr(ten_p_msg), rpt_file_name, 'Sheet', sheet, 'Range', 'A34:A34');
end


% global & local stress-strain
strsstrn_tag = {'Ply no.', 'Mat no.', 'Ply angle', 'Ply thk.', 'Ply crd.', 'Position', ...
                        'exx', 'eyy', 'exy', 'sxx', 'syy', 'sxy', ...
                        'e11', 'e22', 'e12', 's11', 's22', 's12', ...
                        'Status', 'Failure index', 'Safety factor', 'Failure type', 'Failure criterion'};
writecell(cellstr('Global, local stress-strain and failure in each ply'), rpt_file_name, 'Sheet', sheet, ...
    'Range', 'J36:J36');
writecell(strsstrn_tag, rpt_file_name, 'Sheet', sheet, 'Range', 'A37');
ply_no = ceil( ( 1:length(t) * 2 )/ 2 );
mat_no = id * ones(1, length(t) * 2);
ply_angle = t(ceil((1:length(t  ) * 2) / 2));
ply_thk = t(ceil((1:length(t  ) * 2) / 2));
position = repmat({'top surface'; 'bottom surface'}, length(t), 1);
% name of failure criterion
if strcmpi(fail_crtrn, 'off')
    fail_crtrn = repmat({'off'}, 1, length(t) * 2);
elseif strcmpi(fail_crtrn, 'mstrs')
    fail_crtrn = repmat({'Maximum stress'}, 1, length(t) * 2);
elseif strcmpi(fail_crtrn, 'mstrn')
    fail_crtrn = repmat({'Maximum strain'}, 1, length(t) * 2);
elseif strcmpi(fail_crtrn, 'TH')
    fail_crtrn = repmat({'Tsai-Hill'}, 1, length(t) * 2);
elseif strcmpi(fail_crtrn, 'HR')
    fail_crtrn = repmat({'Hashin-Rotem'}, 1, length(t) * 2);
end
writematrix([ply_no' mat_no' ply_angle' ply_thk' zc'], rpt_file_name, 'Sheet', sheet, 'Range', 'A38');
writecell(position, rpt_file_name, 'Sheet', sheet, 'Range', 'F38');
writematrix([ge gs le ls], rpt_file_name, 'Sheet', sheet, 'Range', 'G38');
if strcmpi(fail_crtrn, 'off')
    writecell([fail_crtrn'], rpt_file_name, 'Sheet', sheet, 'Range', 'S38');
else
    writecell([fail_rpt(2:end, 4) fail_rpt(2:end, 5) fail_rpt(2:end, 6) fail_rpt(2:end, 7) ...
        fail_crtrn'], rpt_file_name, 'Sheet', sheet, 'Range', 'S38');
end

