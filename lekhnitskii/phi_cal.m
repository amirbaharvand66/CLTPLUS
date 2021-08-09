function [phi] = phi_cal(h_k, s_k, z_k, c_k, delta, sign_delta)
% Phi calculator

% INPUT(S)
% h_k: homogeneous stress field constant
% s_k: characteristic equation roots
% z_k = x + s_k * y
% c_k: mapped disturbance field constant
% delta = sqrt(z_k^2 - s_k^2 - 1)
% sign_delta: sign of delta

% OUTPUT(S)
% phi: Phi

zeta = zeros(2, 1);
phi = zeros(2, 1);

for k = 1:2
    zeta(k) = (z_k(k) + sign_delta(k) * delta(k)) / (1 - 1i * s_k(k));
    phi(k) = h_k(k) * z_k(k) + c_k(k) * zeta(k)^(-1);
end