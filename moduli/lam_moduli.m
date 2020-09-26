function [mbrn, bnd] = lam_moduli(B, D, a, d, h, lam_typ)
% laminate stiffness properties (membrane and bending)
% only for symmetric and balanced laminate
% a symmetric laminate has a symmetric stacking sequence of the same
% material and thickness, e.g., [0, 45, -30, -30, 45, 0]
% a balanced laminate has the same number of positive and negative
% stacking of the same material and thickness, e.g., [0, -45, -30, 30, 45, 0]

% INPUT(S)
% B : B matrix
% D : D matrix
% a : A inverse matrix
% d : D inverse matrix
% h : laminate total thickness

% originally coded by Amir Baharvand (AB) (08-20)
% modified for a symmetric laminate by AB (08-20)

% membrane stiffness
mbrn_tag = {'E1m', 'E2m', 'G12m', 'v12m', 'v21m'};
mbrn = zeros(1, 5);

% bending stiffness
bnd_tag = {'E1b', 'E2b', 'G12b', 'v12b', 'v21b'};
bnd = zeros(1, 5);

% check if laminate is symmetric and balanced
switch lam_typ
    case 'symmetric'
        mbrn(1) = 1 / (h * a(1, 1)); % E1m
        mbrn(2) = 1 / (h * a(2, 2)); % E2m
        mbrn(3) = 1 / (h * a(3, 3)); % G12m
        mbrn(4) = -a(2, 1) / a(1, 1); % v12m
        mbrn(5) = -a(1, 2) / a(2, 2); % 21m
        mbrn = [mbrn_tag; num2cell(mbrn)];
        
    case 'symmetric-balanced'
        mbrn(1) = 1 / (h * a(1, 1)); % E1m
        mbrn(2) = 1 / (h * a(2, 2)); % E2m
        mbrn(3) = 1 / (h * a(3, 3)); % G12m
        mbrn(4) = -a(2, 1) / a(1, 1); % v12m
        mbrn(5) = -a(1, 2) / a(2, 2); % 21m
        mbrn = [mbrn_tag; num2cell(mbrn)];
        
        bnd(1) = 12 / ((h^3) * d(1, 1)); % E1b
        bnd(2) = 12 / (h^3 * d(2, 2)); % E2b
        bnd(3) = 12 / (h^3 * d(3, 3)); % G12b
        bnd(4) = d(2, 1) / d(1, 1); % v12b
        bnd(5) = d(1, 2) / d(2, 2); % 21b
        bnd = [bnd_tag; num2cell(bnd)];
        
    otherwise
        fprintf('Invalid membrane and bending stiffness. Laminate is NOT symmetric / balanced!!! \n')
        mbrn = [mbrn_tag; repmat({'NA'}, 1, 5)];
        bnd = [bnd_tag; repmat({'NA'}, 1, 5)];
end
