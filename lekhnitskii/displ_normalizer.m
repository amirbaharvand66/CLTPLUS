function [split_tmp_con, d] = displ_normalizer(displ)
% extract the scientific part of maximum total displacement (sqrt(c^2 + v^2))

% INPUT(S)
% displ: displacement around hole 

% OUTPUT(S)
% split_tmp_con: scientific part of maximum total displacement
% d: resultant displacement

u = displ(:, 1);
v = displ(:, 2);

d = sqrt(u.^2 + v.^2);
tmp = max(d);
str_tmp = sprintf("%0.5e", tmp)
split_tmp = strsplit(str_tmp, 'e');
split_tmp_con = str2double(split_tmp{2});