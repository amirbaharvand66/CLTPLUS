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

% type in "help lekhnitskii_doc" in command window for documentation, assumptions
% and application of the present code

laminate_name = 'mat2'; % laminate name as appeared in CLTPLUS
clt_output = 'clt_output'; % data from CLTPLUS

lekhnitskii(laminate_name, clt_output)


