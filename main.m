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


% material properties
mat3 % for example


% composite laminate theory

% 'load' = ‘nm’ force-moment
%             ‘ek’ strain-survature

% 'global' (plot global stress-strain) 'on' / 'off'

% 'local' (plot local stress-strain) 'on' / 'off'

% 'failure' = '' deafult value : no failure criterion
%                  'mstrn' maximum stress failure criterion
%                  'TH' Tsai-Hill stress failure criterion

[laminate(n).abd.A, laminate(n).abd.B, laminate(n).abd.D, laminate(n).abd.Q, ...
    laminate(n).abd.a, laminate(n).abd.b, laminate(n).abd.c, laminate(n).abd.d, ...
    laminate(n).prop.mbrn, laminate(n).prop.bnd, ...
    laminate(n).ply.z, laminate(n).ply.zc, ...
    laminate(n).strsstrn.me0k0, ...
    laminate(n).strsstrn.gblstrn, laminate(n).strsstrn.lclstrn, ...
    laminate(n).strsstrn.gblstr, laminate(n).strsstrn.lclstr] = ...
    clt(mat(n), 'load', 'nm', 'global', 'on', 'local', 'on', 'failure', 'TH');

