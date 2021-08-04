function cltplus_doc()
%                                           CLTPLUS
% A Tool for th Classical Laminate Plate Theory for Composites
% ----------------------------------------------------------------
% Start from "mat_prop" folder by defining ply mechanical properties.
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
%                  'all' compare all failure criteria
% report 'on' / 'off'