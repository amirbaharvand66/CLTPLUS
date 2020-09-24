clc
clear
close all


% Latex for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');


% add paths of functions
addpath(genpath('./abd'));
addpath(genpath('./failure_criteria'));
addpath(genpath('./mat_prop'));
addpath(genpath('./moduli'));
addpath(genpath('./plot_functions'));
addpath(genpath('./report'));
addpath(genpath('./design_measures'));
addpath(genpath('./modules'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% material properties

mat2 % for example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% composite laminate theory module

% 'load' = �nm� force-moment
%             �ek� strain-survature

% 'global' (plot global stress-strain) 'on' / 'off'

% 'local' (plot local stress-strain) 'on' / 'off'

% 'failure' = '' deafult value : no failure criterion
% N.B. for the failure criteria, s11 and mainly represent fiber and matrix
% failure, respectively.
%                  'mstrs' maximum stress failure criterion
%                  'mstrn' maximum strain failure criterion
%                  'TH' Tsai-Hill stress failure criterion
%                  'PHR' Puck (Hashin-Rotem) failure criterion
%                  'all' compare all failure criteria

% report 'on' / 'off'

[laminate.(string(lamina_name))] = ...
    clt(mat, 'load', 'nm', 'global', 'off', 'local', 'off', 'failure', 'TH', 'report', 'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% failure criteria fixed in case of user typo
% laminate structure improved
% laminates and materials now can be accessed by their names based on user input e.g 'E_glass_Epoxy'
% lamainate type detector added for membrane and bending laminate stiffness



