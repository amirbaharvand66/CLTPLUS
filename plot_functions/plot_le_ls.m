function plot_le_ls(le, ls, zc, t, theta, id)
% plot local stress-strain


% INPUT(S)
% le : laminate local strain
% ls : laminate local stress
% t : ply thickness
% theta : ply angle
% id : laminate id


% originally coded by Amir Baharvand (08-2020)


% plotting local strain
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf, 'NumberTitle','off')
set(gcf, 'Name', sprintf('Local Strain and Stress Distribution - Laminate %d', id))

le_label = {'$\epsilon_{11}$', '$\epsilon_{22}$', '$\epsilon_{12}$'};


for ii = 1:3
    subplot(2, 3, ii)
    plot(le(:, ii), zc(:), 'k', 'LineWidth', 2)
    set(gca, 'FontSize', 16)
    xlabel(le_label{ii},'Interpreter','latex', 'FontSize', 20)
    ylabel('Thickness [mm]','Interpreter','latex', 'FontSize', 15)
    
    
    % displaying layers
    hold on
    max_le= max(abs(le(:, ii)));
    for jj = 1:length(zc)
        if max_le ~= 0
            plot([-max_le, max_le], [0, 0] + zc(jj), 'b')
            xlim([-max_le, max_le])
        else
            plot([-1, 1], [0, 0] + zc(jj), 'b')
        end
    end
    
    plot([0, 0], [zc(1), zc(end)], 'r')
    disp_ply_angle(t, theta, zc)
end


ls_label = {'$\sigma_{11}$', '$\sigma_{22}$', '$\sigma_{12}$'};
for ii = 1:3
    subplot(2, 3, ii + 3)
    plot(ls(:, ii), zc(:), 'k', 'LineWidth', 2)
    set(gca, 'FontSize', 16)
    xlabel(ls_label{ii},'Interpreter','latex', 'FontSize', 20)
    ylabel('Thickness [mm]','Interpreter','latex', 'FontSize', 15)
    
    
    % displaying layers
    hold on
    max_ls= max(abs(ls(:, ii)));
    for jj = 1:length(zc)
        if max_ls ~= 0
            plot([-max_ls, max_ls], [0, 0] + zc(jj), 'b')
            xlim([-max_ls, max_ls])
        else
            plot([-1, 1], [0, 0] + zc(jj), 'b')
        end
    end
    
    plot([0, 0], [zc(1), zc(end)], 'r')
    disp_ply_angle(t, theta, zc)
end






