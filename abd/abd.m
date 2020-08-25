function [A, B, D, Q, z] = abd(lam)
% ABD calculator for plane stress


% INPUT(S)
% A : A matrix
% B : B matrix
% D : D matrix
% Q : reduced stiffness matrix for plane stress
% z : laminate thickness coordinates


E11 = lam.mat.E11;
E22 = lam.mat.E22;
G12 = lam.mat.G12;
v12 = lam.mat.v12;


% Reuter matrix
R = reuter_matrix();


% solving for other constrants
v21 = E22 / E11 * v12;


% calculating the coordinate for each ply
h = sum(lam.ply.t); % sum of the laminate
z = zeros(1, length(lam.ply.t) +1 ); % ply coordinate
z(1) = -h / 2; % neural plane assumed at h/2


% N.B. that is not TRUE for asymmetric laminates, but
% this will be compensated by extension–bending
% coupling elements in the final “stiffness”
% matrix formulation
for ii = 1:length(lam.ply.t)
    z(ii + 1) = lam.ply.t(ii) + z(ii);
end


% solving for plane stress; therefore, the reduced stiffness matrix (Q)
% compromises of four independent elements
Q11 = E11 /  (1 - v21 * v12);
Q12 = v12 * E22 / (1 - v21 * v12);
Q22 = E22 / (1 - v21 * v12);
Q66 = G12;
Q = [Q11   Q12    0; ...
        Q12   Q22    0;...
        0        0        Q66];


% initial values for ABD matrices
A = zeros(3);
B = zeros(3);
D = zeros(3);

for ii = 1:length(lam.ply.theta)
    % transformation matrxi (M)
    M = transformation_matrix_plane_stress(lam.ply.theta(ii));
    
    % transformed reduced stiffness matrix
    q = M \ Q * R * M / R; % inv(M) * Q * R * M * inv(R)
    
    % filling the ABD matrices
    A = A + q * (z(ii + 1) - z(ii));
    B = B + 1 / 2 * q * (z(ii + 1)^2 - z(ii)^2);
    D = D + 1 / 3 * q * (z(ii + 1)^3 - z(ii)^3);
end






