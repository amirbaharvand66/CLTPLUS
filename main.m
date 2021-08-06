clc
clear 
close all

addpath(genpath('./preamble'));
initials()

% type in "help lekhnitskii_doc" in command window for documentation, assumptions
% and application of the present code

laminate_name = 'mat2'; % laminate name as appeared in CLTPLUS
load clt_output.mat; % load laminate data from CLTPLUS

lekhnitskii