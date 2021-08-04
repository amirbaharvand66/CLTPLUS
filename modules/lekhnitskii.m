clc
clear 
close all

laminate_name = 'mat2';

% load laminate data from CLTPLUS
load clt_output.mat

% read data from clt.m
h = laminate.(string(lamina_name)).ply.h; % h: laminate thickness
A = laminate.(string(lamina_name)).abd.A; % A: A part of the ABD matrix
p = mat.mat2.lekh.load; % load at infinity
p_h = mat.mat2.lekh.hole; % load on hole edge

% laminate compliance matrix
[S] = compliance_cal(h, A);

% directionality and angularity 
[r, a] = dir_ang_cal(S);

% characteristic equation roots
[s, alpha, beta] = char_eqn_root(r, a);

% Homogeneous Stress Field Constant
[h_k] = h_k_cal(p, s);

% Disturbance Field Constant
[c_k] = c_k_cal(p, p_h, s);