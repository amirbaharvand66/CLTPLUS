function clt_report(id, mat, ABD, abd, mbrn, bnd, loading, me0k0, zc, ge, gs, le, ls, fail_rpt, fail_crtrn)
% reporting for composite laminate theory


% INPUT(S)
% laminate: composite laminate
% mat: material properties
% n: laminate id
% loading: loading type ('ek' / 'nm')
% fail_crtrn: failure criterion


% OUTPUT(S)
% results from CLT module in a formatted Excel worksheet


% turn off warning of added specified worksheet
warning( 'off', 'MATLAB:xlswrite:AddSheet' );


% creating report file name
rpt_file_name = sprintf('laminate%d_rpt.xlsx', id);
sheet = sprintf('laminate%d', id);


% remove the residual file from previou run(s)
recycle on
delete(rpt_file_name)


% ABD
xlswrite(rpt_file_name, ['A' 'B'; 'B' 'D'], sheet, 'A3:B4');
xlswrite(rpt_file_name, ABD, sheet, 'C1:H6');


%abd
xlswrite(rpt_file_name, ['a' 'b'; 'b' 'd'], sheet, 'A10:B11');
xlswrite(rpt_file_name, abd, sheet, 'C8:H13');


% laminate membrane stiffnesses
xlswrite(rpt_file_name, cellstr('Laminate membrane stiffnesses'), sheet, 'A15:A15');
xlswrite(rpt_file_name, mbrn, sheet, 'C15');


% laminate bending stiffnesses
xlswrite(rpt_file_name, cellstr('Laminate bending stiffnesses'), sheet, 'A18:A18');
xlswrite(rpt_file_name, bnd, sheet, 'C18:G19');


% mid-plane strain-curvature
load_tag = {'Nx'; 'Ny'; 'Nxy'; 'Mx.'; 'My'; 'Mxy'};
ek_tag = {'e0x.'; 'e0y.'; 'e0xy'; 'k0x.'; 'k0y'; 'k0xy'};
xlswrite(rpt_file_name, cellstr('Applied load'), sheet, 'A21:A21');
xlswrite(rpt_file_name, load_tag, sheet, 'A22:A27');
xlswrite(rpt_file_name, ek_tag, sheet, 'C22:C27');
if loading == 'ek'
    nm = ABD * [mat.load.e0; mat.load.k0];
    xlswrite(rpt_file_name, nm, sheet, 'B22:B27');
    xlswrite(rpt_file_name, [mat.load.e0; mat.load.k0], sheet, 'D22:D27');
elseif loading == 'nm'
    xlswrite(rpt_file_name, [mat.load.N; mat.load.m], sheet, 'B22:B27');
    xlswrite(rpt_file_name, me0k0, sheet, 'D22:D27');
end


% 10-percent rule
xlswrite(rpt_file_name, cellstr('10% rule'), sheet, 'A29:A29');
[tag, zero_of_tot, p45_of_tot, m45_of_tot, ninty_of_tot] = ten_percent_rule(mat);
xlswrite(rpt_file_name, tag, sheet, 'A30:A33');
xlswrite(rpt_file_name, [zero_of_tot p45_of_tot m45_of_tot ninty_of_tot]', sheet, 'B30:B33');
% pop-up message for 10-percent rule in case of invasion
if ( zero_of_tot + p45_of_tot + m45_of_tot + ninty_of_tot ) <= 10
    xlswrite(rpt_file_name, cellstr(ten_p_msg), sheet, 'A34:A34');
end


% global & local stress-strain
strsstrn_tag = {'Ply no.', 'Mat no.', 'Ply angle', 'Ply thk.', 'Ply crd.', 'Position', ...
                        'exx', 'eyy', 'exy', 'sxx', 'syy', 'sxy', ...
                        'e11', 'e22', 'e12', 's11', 's22', 's12', ...
                        'Status', 'Failure index', 'Failure type', 'Failure criterion'};
xlswrite(rpt_file_name, cellstr('Global, local stress-strain and failure in each ply'), sheet, 'J36:J36');
xlswrite(rpt_file_name, strsstrn_tag, sheet, 'A37');
ply_no = ceil( ( 1:length(mat.ply.t) * 2 )/ 2 );
mat_no = id * ones(1, length(mat.ply.t) * 2);
ply_angle = mat.ply.t(ceil((1:length(mat.ply.t  ) * 2) / 2));
ply_thk = mat.ply.t(ceil((1:length(mat.ply.t  ) * 2) / 2));
position = repmat({'top surface'; 'bottom surface'}, length(mat.ply.t), 1);
% name of failure criterion
if strcmp(fail_crtrn, 'mstrs')
    fail_crtrn = repmat({'Maximum stress'}, 1, length(mat.ply.t) * 2);
elseif strcmp(fail_crtrn, 'mstrn')
    fail_crtrn = repmat({'Maximum strain'}, 1, length(mat.ply.t) * 2);
elseif strcmp(fail_crtrn, 'TH')
    fail_crtrn = repmat({'Tsai-Hill'}, 1, length(mat.ply.t) * 2);
elseif strcmp(fail_crtrn, 'PHR')
    fail_crtrn = repmat({'Puck'}, 1, length(mat.ply.t) * 2);
else
    fail_crtrn = repmat({''}, 1, length(mat.ply.t) * 2);
end
xlswrite(rpt_file_name, [ply_no' mat_no' ply_angle' ply_thk' zc'], sheet, 'A38');
xlswrite(rpt_file_name, position, sheet, 'F38');
xlswrite(rpt_file_name, [ge gs le ls], sheet, 'G38');
xlswrite(rpt_file_name, [fail_rpt(2:end, 4) fail_rpt(2:end, 5) fail_rpt(2:end, 6) fail_crtrn'], sheet, 'S38');

