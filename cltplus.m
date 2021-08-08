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
    clt(mat, 'load', 'nm', 'global', 'off', 'local', 'off', 'failure', 'off', 'report', 'off', 'save_output', 'off');

% Lekhnitskii theory for orthotrpic plate with a circular hole
% type in "help lekhnitskii_doc" in command window for documentation, assumptions
% and application of the present code
lekhnitskii(lamina_name, mat, laminate)