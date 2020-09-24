function [lam_typ] = lam_type(t, theta)
% detect laminate type, symmetric_balanced, symmetric, balanced or asymmetric
% required for membrane and bending laminate stiffness

% INPUTS(S)
% theta : ply angle
% t : ply thickness

% originally coded by Amir Baharvand (AB) (08-20)

cnt = 0;
lam_stck = zeros(1, ceil(length(theta) / 2));

while cnt <= floor(length(theta) / 2)
    cnt = cnt + 1;
    lam_stck(cnt) = ( theta(cnt + 1) == theta( end - cnt) );
end

if isequal(t / max(t), ones(1, length(t))) == 1
    
    if isequal( lam_stck, ones(1, length(lam_stck)) ) && length(theta(theta < 0)) == length(theta(theta > 0))
        lam_typ = 'symmetric-balanced';
    elseif isequal( lam_stck, ones(1, length(lam_stck)) )
        lam_typ = 'symmetric';
    elseif length(theta(theta < 0)) == length(theta(theta > 0))
        lam_typ = 'balanced';
    else
        lam_typ = 'asymmetric';
    end
    
else
    lam_typ = 'asymmetric';
end