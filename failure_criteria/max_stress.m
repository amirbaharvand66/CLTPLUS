function max_stress(theta, ls, Xt, Xc, Yt, Yc, S, id)
% maximum stress failure criterion


% INPUT(S)
% theta : ply angle
% ls : local stress for each ply
% Xt : longitudinal tensite strength
% Xc : longitudinal compression strength
% Yt : transverse tensite strength
% Yc : transverse compression strength
% S : shear strength


% originally coded by Amir Baharvand (08-2020)


fprintf('******************************************\n')
fprintf('Maximum Stress Failure Criterion - Laminate %d\n', id)
fprintf('     FAILURE = 1     Without failure = 0\n')
fprintf('******************************************\n')
fprintf('Ply no. \t Ply angle \t Failure occurrence \t Status \n')

figure()
max_stress_envelope(Xt, Xc, Yt, Yc, S, id)
hold on

for ii = 1:size(ls, 1)
    s11 = ls(ii, 1);
    s22 = ls(ii, 2);
    s12 = ls(ii, 3);
    
    s__x = ( (sign(s11) + 1) / 2 ) * Xt + ( (sign(s11) - 1) / 2 ) * -Xc;
    s__y = ( (sign(s22) + 1) / 2 ) * Yt + ( (sign(s22) - 1) / 2 ) * -Yc;
    
    if ( abs(s11) < s__x ) && ( abs(s22) < s__y ) && (abs(s12) < S) && ( mod(ii, 2) == 1 )
        flag = 0;
        fprintf('%d \t %d \t\t top surface \t\t %d \n', ceil(ii / 2), theta(ceil(ii / 2)), flag)
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    elseif ( abs(s11) < s__x ) && ( abs(s22) < s__y ) && (abs(s12) < S) && ( mod(ii, 2) == 0 )
        flag = 0;
        fprintf('%d \t %d \t\t bottom surface \t %d \n', ceil(ii / 2), theta(ceil(ii / 2)), flag)
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','g', 'MarkerFaceColor','g');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    elseif ( abs(s11) >= s__x ) && ( abs(s22) >= s__y ) && (abs(s12) >= S) && ( mod(ii, 2) == 1 )
        flag = 1;
        fprintf('%d \t %d \ttop surface \t\t %d \n', ceil(ii / 2), theta(ceil(ii / 2)), flag)
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^+)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    else
        flag = 1;
        fprintf('%d \t %d \t\t bottom surface \t %d \n', ceil(ii / 2), theta(ceil(ii / 2)), flag)
        scatter3(s11, s22, s12, 'o', 'MarkerEdgeColor','r', 'MarkerFaceColor','r');
        text(s11, s22, s12, sprintf('$%d(%d^-)$', ceil(ii / 2), theta(ceil(ii / 2))),'Interpreter','latex');
    end
end
title({'Ply number (Ply angle$^{+-}$)', ...
    '(+) Laminate top surface (-) Laminate bottom surface', ...
    'Units acoording to input values'}, 'Interpreter','latex', 'FontSize', 20)
grid on
box on
