function [a, b, c, d] = abd_inv(A, B, D)
% abd inverse matrices 

% INPUT(S)
% A : A matrix
% B : B matrix
% D : D matrix
% h : laminate total thickness

% originally coded by Amir Baharvand (08-20)

B_ = -A \ B; % - inv(A) * B
C_ = B / A; % B * inv(A)
D_ = D - C_ * B; % D - ( B * inv(A) ) * B
a = inv(A) - (B_ / D_) * C_; % inv(A) - ( B_ * inv(D_) ) * C_
b = B_ / D_; % B_ * inv(D_)
c = b'; % transpose(b)
d = inv(D_); % inc(D_)