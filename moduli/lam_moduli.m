function [a, b, c, d, lam_mbrn, lam_bnd] = lam_moduli(A, B, D, h)
% abd matrices and laminate stiffness properties (membrane and bending)


% INPUT(S)
% A : A matrix
% B : B matrix
% D : D matrix
% h : laminate total thickness


% originally coded by Amir Baharvand (08-2020)


B_ = -A \ B; % - inv(A) * B
C_ = B / A; % B * inv(A)
D_ = D - C_ * B; % D - ( B * inv(A) ) * B
a = inv(A) - (B_ / D_) * C_; % inv(A) - ( B_ * inv(D_) ) * C_
b = B_ / D_; % B_ * inv(D_)
c = b'; % transpose(b)
d = inv(D_); % inc(D_)


mbrn_tag = {'E1m', 'E2m', 'G12m', 'v12m', '21m'};
mbrn = zeros(1, 5); % membrane


bnd_tag = {'E1b', 'E2b', 'G12b', 'v12b', '21b'};
bnd = zeros(1, 5); % bending


mbrn(1) = 1 / (h * a(1, 1)); % E1m
mbrn(2) = 1 / (h * a(2, 2)); % E2m
mbrn(3) = 1 / (h * a(3, 3)); % G12m
mbrn(4) = -a(2, 1) / a(1, 1); % v12m
mbrn(5) = -a(1, 2) / a(2, 2); % 21m


bnd(1) = 12 / ((h^3) * d(1, 1)); % E1b
bnd(2) = 12 / (h^3 * d(2, 2)); % E2b
bnd(3) = 12 / (h^3 * d(3, 3)); % G12b
bnd(4) = d(2, 1) / d(1, 1); % v12b
bnd(5) = d(1, 2) / d(2, 2); % 21b


lam_mbrn = [mbrn_tag; num2cell(mbrn)];
lam_bnd = [bnd_tag; num2cell(bnd)];
