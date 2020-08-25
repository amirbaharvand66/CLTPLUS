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

% 'load' = ‘nm’ force-moment
%             ‘ek’ strain-survature

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


[laminate(n).abd.A, laminate(n).abd.B, laminate(n).abd.D, laminate(n).abd.Q, ...
    laminate(n).abd.a, laminate(n).abd.b, laminate(n).abd.c, laminate(n).abd.d, ...
    laminate(n).prop.mbrn, laminate(n).prop.bnd, ...
    laminate(n).ply.z, laminate(n).ply.zc, ...
    laminate(n).strsstrn.me0k0, ...
    laminate(n).strsstrn.gblstrn, laminate(n).strsstrn.lclstrn, ...
    laminate(n).strsstrn.gblstrs, laminate(n).strsstrn.lclstrs, ...
    laminate(n).rpt.failure] = ...
    clt(mat(n), 'load', 'nm', 'global', 'on', 'local', 'on', 'failure', 'PHR', 'report', 'on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




