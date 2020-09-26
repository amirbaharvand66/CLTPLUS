function cltplus_doc()
% composite laminate theory - v 0.0.3
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
% report 'on' / 'off'