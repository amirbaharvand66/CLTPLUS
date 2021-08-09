function [displ] = displ_cal(S, s_k, phi)
% displacement 

% INPUT(S)
% S: compliance matrix
% s_k: characteristic equation roots
% phi: Phi

% OUTPUT(S)
% displ: displacement


S22 = S(2, 2);
S11 = S(1, 1);
S12 = S(1, 2);

% initializing
u12 = zeros(2, 1);
v12 = zeros(2, 1);

for k = 1:2
    u12(k) = S11 * s_k(k)^2 + S12;
    v12(k) = (S12 * s_k(k)^2 + S22) / s_k(k);
end

u = 2 * real(sum(u12 .* phi));
v = 2 * real(sum(v12 .* phi));

displ = [u, v];