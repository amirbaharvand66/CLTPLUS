function cltplus_doc()
%                                                           CLTPLUS
% A Tool for the predicting First-Ply Failure (FPF) of laminated composite based on 
%                       Classical Laminate Plate Theory for Composites
% ----------------------------------------------------------------------------------------
% Start from either 
% 1. By inserting fiber/resin properties available in "/micro_mech_prop/fiber_resin_prop
% and selecting 
% 1.1 'ROM' rule of mixture (micro_cal = 'on')
% 1.2 'HT' Halpin-Tsai (micro = 'on')
% or
% 2. Turning off (micro_cal = 'off') and inserting lamina properties directly in "mat_prop" folder 
% 
% ------------------------------------------clt Module--------------------------------------------
% 
% The available options are
% 'load' = ‘nm’ force-moment
%             ‘ek’ strain-survature
% 'global' (plot global stress-strain) 'on' / 'off'
% 'local' (plot local stress-strain) 'on' / 'off'
% 'failure' = 'off' deafult value : no failure criterion
% N.B. for the failure criteria, s11 and mainly represent fiber and matrix
% failure, respectively.
%                  'mstrs' maximum stress failure criterion
%                  'mstrn' maximum strain failure criterion
%                  'TH' Tsai-Hill stress failure criterion
%                  'PHR' Puck (Hashin-Rotem) failure criterion
% report 'on' / 'off'
% save_output 'on' / 'off'
%
% --------------------------------------lekhnitskii Module----------------------------------------
% 
% type in "help lekhnitskii_doc" in command window for documentation, assumptions
% and application of the present code
