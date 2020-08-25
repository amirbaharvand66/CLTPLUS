function plot_ge_gs(ge, gs, zc, t, theta, id)
% plot global stress-strain


% INPUT(S)
% ge : laminate global strain
% gs : laminate global stress
% t : ply thickness
% theta : ply angle
% id : laminate id


% originally coded by Amir Baharvand (08-2020)


% plotting local strain
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', sprintf('Global Strain and Stress Distribution - Laminate %d', id))

ge_label = {'$\epsilon_{xx}$', '$\epsilon_{yy}$', '$\epsilon_{xy}$'};


for ii = 1:3
    subplot(2, 3, ii)
    plot(ge(:, ii), zc(:), 'k', 'LineWidth', 2)
    set(gca, 'FontSize', 16)
    xlabel(ge_label{ii},'Interpreter','latex', 'FontSize', 20)
    ylabel('Thickness [mm]','Interpreter','latex', 'FontSize', 15)
    
    
    % displaying layers
    hold on
    max_ge= max(abs(ge(:, ii)));
    for jj = 1:length(zc)
        if max_ge ~= 0
            plot([-max_ge, max_ge], [0, 0] + zc(jj), 'b')
            xlim([-max_ge, max_ge])
        else
            plot([-1, 1], [0, 0] + zc(jj), 'b')
        end
    end
    
    plot([0, 0], [zc(1), zc(end)], 'r')
    disp_ply_angle(t, theta, zc)
end


gs_label = {'$\sigma_{xx}$', '$\sigma_{yy}$', '$\sigma_{xy}$'};
for ii = 1:3
    subplot(2, 3, ii + 3)
    plot(gs(:, ii), zc(:), 'k', 'LineWidth', 2)
    set(gca, 'FontSize', 16)
    xlabel(gs_label{ii},'Interpreter','latex', 'FontSize', 20)
    ylabel('Thickness [mm]','Interpreter','latex', 'FontSize', 15)
    
    
    % displaying layers
    hold on
    max_gs= max(abs(gs(:, ii)));
    for jj = 1:length(zc)
        if max_gs ~= 0
            plot([-max_gs, max_gs], [0, 0] + zc(jj), 'b')
            xlim([-max_gs, max_gs])
        else
            plot([-1, 1], [0, 0] + zc(jj), 'b')
        end
    end
    
    plot([0, 0], [zc(1), zc(end)], 'r')
    disp_ply_angle(t, theta, zc)
end






