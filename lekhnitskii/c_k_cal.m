function [c_k] = c_k_cal(p, p_h, s_k)
% Mapped disturbance field constant

% INPUT(S)
% p: load at infinity
% p_h: load on hole edge
% s_k: characteristic equation roots

% OUTPUT(S)
% c_k: mapped disturbance field constant

syms c1 c2
p_x = p(1);
p_y = p(2);
p_xy = p(3);
Xc = p_h(1);
Xs = p_h(2);
Yc = p_h(3);
Ys = p_h(4);
s1 = s_k(1);
s2 = s_k(2);

[c1, c2]=solve( c1 + c2 == 1/2 * (1i * Yc - Ys - p_y + 1i * p_xy), ...
                        s1 * c1 + s2 * c2 == 1/2 * (Xs - 1i * Xc - 1i * p_x + p_xy) );
                    
c_k = [c1; c2];