function [d_phi] = d_phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta)
% Phi_prime calculator
d_zeta = zeros(2, 1);
d_phi = zeroa(2, 1);

for k = 1:2
    d_zeta(k) = (1 / (1 + 1i *s_k(k))) * (1 - (z_k(k) / (sign_delta(k) * delta(k))));
    d_phi(k) = h_k(k) + c_k(k) * d_zeta(k);
end