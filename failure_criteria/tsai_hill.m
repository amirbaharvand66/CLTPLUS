function [fail_rpt] = tsai_hill(theta, ls, Xt, Xc, Yt, Yc, S, id)
% Tsai_Hill failure criterion

% INPUT(S)
% theta : ply angle
% ls : local stress for each ply
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength
% id : laminate id

% originally coded by Amir Baharvand (08-20)

% plot envelope
figure()
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', sprintf('Tsai-Hill Failure Criterion - Laminate %d', id))
hold on
tsai_hill_envelope(Xt, Xc, Yt, Yc, S)


ply_num = zeros(length(theta) * 2, 1);
flag_vec = zeros(length(theta) * 2, 1);
theta_c = theta(ceil((1:length(theta) * 2) / 2))';
fidx_vec = zeros(length(theta) * 2, 1);
position = repmat({'top surface'; 'bottom surface'}, length(theta), 1);

for ii = 1:size(ls, 1)
    s11 = ls(ii, 1);
    s22 = ls(ii, 2);
    s12 = ls(ii, 3);

    s__x = ( (sign(s11) + 1) / 2 ) * Xt + ( (sign(s11) - 1) / 2 ) * Xc;
    s__y = ( (sign(s22) + 1) / 2 ) * Yt + ( (sign(s22) - 1) / 2 ) * Yc;

    fidx = s11^2 / s__x^2 + s22^2 / s__y^2 - (s11 * s22) / s__x^2 + s12^2 / S^2; % failure index

    % no failure at top surface
    if (fidx <= 1) && ( mod(ii, 2) == 1 )
        flag = 0;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % no failure at bottom surface
    elseif (fidx <= 1) && ( mod(ii, 2) == 0 )
        flag = 0;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % failure at top surface
    elseif (fidx > 1) && ( mod(ii, 2) == 1 )
        flag = 1;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
        % failure at bottom surface
    else
        flag = 1;
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    end

    % collecting necessary outputs for failure reporting
    % collecting ply number
    ply_num(ii) = ceil(ii / 2);

    % collecting flag values
    flag_vec(ii) = flag;

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
ft_vec = repmat({'NA'}, length(theta) * 2, 1);
fail_tag = {'Ply no.', 'Ply angle', 'Position', 'Status', 'Failure index', 'Failure Type'};
fail_rpt = [fail_tag; ply_num, theta_c, position, flag_vec ,fidx_vec, ft_vec]; % failure report


% displaying failure report
fprintf('**************************************************************************************\n')
fprintf('\t\t Tsai-Hill Failure Criterion - Laminate %d\n', id)
fprintf('\t\t    FAILURE = 1     Without failure = 0\n')
fprintf('**************************************************************************************\n')
fprintf('Ply no. \t Ply angle \t Position \t\t Status \t Failure index \t Failure Type\n')

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
