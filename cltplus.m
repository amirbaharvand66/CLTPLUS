clc
clear
close all

addpath(genpath('./preamble'));
initials()

% material properties
mat2  

% composite laminate theory
% type in "help cltplus_doc" in command window for documentation on input
% parameters
[laminate.(string(lamina_name))] = ...
    clt(mat, 'load', 'nm', 'global', 'off', 'local', 'off', 'failure', 'TH', 'report', 'off');




