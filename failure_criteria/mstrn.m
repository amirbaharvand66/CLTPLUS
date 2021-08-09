function [fail_rpt] = mstrn(theta, v12, v21, le, eXt, eXc, eYt, eYc, eXY, ls, Xt, Xc, Yt, Yc, S, id, all_fc)
% maximum strain failure criterion

% INPUT(S)
% theta : ply angle
% le : local strain for each ply
% eXt : longitudinal tensite ultimate strain
% eXc : longitudinal compression ultimate strain
% eYt : transverse tensite ultimate strain
% eYc : transverse compression ultimate strain
% eXY : shear ultimate strain
% ls : local stress for each ply
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength
% id : laminate id

% originally coded by Amir Baharvand (08-20)

% plot envelope
if strcmpi(all_fc, 'on') == 1
    set(gcf, 'NumberTitle', 'off')
    set(gcf, 'Name', sprintf('All Failure Criterion - Laminate %d', id))
    hold on
    mstrn_envelope(v12, v21, Xt, Xc, Yt, Yc, S)
else
    figure()
    set(gcf, 'NumberTitle', 'off')
    set(gcf, 'Name', sprintf('Maximum Strain Failure Criterion - Laminate %d', id))
    hold on
    mstrn_envelope(v12, v21, Xt, Xc, Yt, Yc, S)
end

ply_num = zeros(length(theta) * 2, 1);
flag_vec = zeros(length(theta) * 2, 1);
theta_c = theta(ceil((1:length(theta) * 2) / 2))';
ft_vec = cell(length(theta) * 2, 1);
fidx_vec = zeros(length(theta) * 2, 1);
position = repmat({'top surface'; 'bottom surface'}, length(theta), 1);

for ii = 1:size(le, 1)
    s11 = ls(ii, 1);
    s22 = ls(ii, 2);
    s12 = ls(ii, 3);
    
    e11 = le(ii, 1);
    e22 = le(ii, 2);
    e12 = le(ii, 3);
    
    e__x = ( (sign(e11) + 1) / 2 ) * eXt + ( (sign(e11) - 1) / 2 ) * eXc;
    e__y = ( (sign(e22) + 1) / 2 ) * eYt + ( (sign(e22) - 1) / 2 ) * eYc;
    
    fidx = max( [e11 / eXt, e11 / eXc, e22 / eYt, e22 / eYc, e12 / eXY] ); % failure index
    
    % no failure at top surface
    if ( abs(e11) < e__x ) && ( abs(e22) < e__y ) && (abs(e12) < eXY) && ( mod(ii, 2) == 1 )
        ft = '';
        flag = 0;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % no failure at bottom surface
    elseif ( abs(e11) < e__x ) && ( abs(e22) < e__y ) && (abs(e12) < eXY) && ( mod(ii, 2) == 0 )
        ft = '';
        flag = 0;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % failure at top surface
    elseif ( ( abs(e11) >= e__x ) || ( abs(e22) >= e__y ) || (abs(e12) >= eXY) ) && ( mod(ii, 2) == 1 )
        ft = failure_type('strn', 'e', [e11, e22, e__x, e__y]);
        flag = 1;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % failure at bottom surface
    else
        ft = failure_type('strn', 'e', [e11, e22, e__x, e__y]);
        flag = 1;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    end
    
    % collecting necessary outputs for failure reporting
    % collecting ply number
    ply_num(ii) = ceil(ii / 2);
    
    % collecting flag values
    flag_vec(ii) = flag;
    
    % collecting failure type
    ft_vec{ii} = ft;
    
    % collecting failure index
    fidx_vec(ii) = fidx;
end

% in case of failure of either top or bottom surface the whole ply should
% fail, this for loop does it
for ii = 1:2:size(ls, 1) - 1
    if (flag_vec(ii + 1) ~= flag_vec(ii) ) && ( flag_vec(ii + 1) > flag_vec(ii) )
        flag_vec(ii) = flag_vec(ii +1);
    elseif (flag_vec(ii + 1) ~= flag_vec(ii) ) && ( flag_vec(ii + 1) < flag_vec(ii) )
        flag_vec(ii + 1) = flag_vec(ii);
    end
end

ply_num = num2cell(ply_num);
flag_vec = num2cell(flag_vec);
theta_c = num2cell(theta_c);
fidx_vec = num2cell(fidx_vec);
fail_tag = {'Ply no.', 'Ply angle', 'Position', 'Status', 'Failure index', 'Failure type'};
fail_rpt = [fail_tag; ply_num, theta_c, position, flag_vec, fidx_vec, ft_vec]; % failure report

% displaying failure report
fprintf('*************************************************************************************\n')
fprintf('\t\t Maximum Strain Failure Criterion - Laminate %d\n', id)
fprintf('\t\t\t FAILURE = 1     Without failure = 0\n')
fprintf('*************************************************************************************\n')
fprintf('Ply no. \t Ply angle \t Failure occurrence \t Status \t Failure index \t Failure Type\n')

for ii = 2:size(fail_rpt, 1)
    if mod(ii, 2) == 0
        fprintf('%0.0f \t %d \t\t %s \t\t %d \t %2.3f \t\t %s\n', fail_rpt{ii, :})
    else
        fprintf('%0.0f \t %d \t\t %s \t %d \t %2.3f \t\t %s\n', fail_rpt{ii, :})
    end
end


title({'Ply number (Ply angle$^{\pm}$)', ...
    '(+) Laminate top surface (-) Laminate bottom surface', ...
    'Units acoording to input values'}, 'Interpreter','latex', 'FontSize', 20)
grid on
box on
view(-45, 45)