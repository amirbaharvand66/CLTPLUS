function [lam_typ] = lam_type(t, theta)
% detect laminate type, symmetric_balanced, symmetric, balanced or asymmetric
% required for membrane and bending laminate stiffness

% INPUTS(S)
% theta : ply angle
% t : ply thickness

% OUTPUT(S)
% lam_type : laminate type

% originally coded by Amir Baharvand (AB) (08-20)
% fixed for single and double lamina(e) by AB (09-20)

n_ply = length(t); % number of plies
cnt = 0;
lam_stck = zeros(1, ceil(length(theta) / 2)); % laminate stacking sequence

switch n_ply
    case 1 % single lamina
        lam_typ = 'symmetric';
    case 2 % double laminae
        if theta(1) == theta(end)
            lam_typ = 'unidirectional';
        elseif theta(1) == -theta(end)
            lam_typ = 'symmetric-balanced';
        else
            lam_typ = 'asymmetric';
        end
    otherwise % more than two laminae
        
        while cnt <= floor(length(theta) / 2)
            lam_stck(cnt + 1) = ( theta(cnt + 1) == theta( end - cnt) );
            cnt = cnt + 1;
        end
        if isequal(t / max(t), ones(1, length(t))) == 1 % if all plies are from the same thickness
            
            if isequal( lam_stck, ones(1, length(lam_stck)) ) && length(theta(theta < 0)) == length(theta(theta > 0))
                lam_typ = 'symmetric-balanced';
            elseif isequal( lam_stck, ones(1, length(lam_stck)) )
                lam_typ = 'symmetric';
            elseif length(theta(theta < 0)) == length(theta(theta > 0))
                lam_typ = 'balanced';
            else
                lam_typ = 'asymmetric';
            end
            
        else % if all plies are NOT from the same thickness
            lam_typ = 'asymmetric';
        end
end