function [d_phi] = d_phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta)
% Phi_prime calculator

% INPUT(S)
% h_k: homogeneous stress field constant
% s_k: characteristic equation roots
% z_k = x + s_k * y
% c_k: mapped disturbance field constant
% delta = sqrt(z_k^2 - s_k^2 - 1)
% sign_delta: sign of delta

% OUTPUT(S)
% d_phi: Phi_prime

d_zeta = zeros(2, 1);
d_phi = zeros(2, 1);

for k = 1:2
    d_zeta(k) = -((1 - 1i * s_k(k)) * (1 + z_k(k) / (sign_delta(k) * delta(k))) / (z_k(k) + sign_delta(k) * delta(k))^2);
    d_phi(k) = h_k(k) + c_k(k) * d_zeta(k);
end