clc
clear 
close all

addpath(genpath('./preamble'));
initials()

% type in "help lekhnitskii_doc" in command window for documentation, assumptions
% and application of the present code

laminate_name = 'mat2'; % laminate name as appeared in CLTPLUS
clt_output = 'clt_output'; % data from CLTPLUS

lekhnitskii(laminate_name, clt_output)