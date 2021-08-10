function [sign_delta] = sign_func(theta, alpha, beta, x, y, delta)
% delta sign function
% reference
% 1. Koussios. Continuity of the solutions obtained by lekhnitskii’s theory for anisotropic
% plates:Sign selection strategies. In TE Lacy, R Sullivan, and AJ Vizzini, editors,
% Proceedings ofthe American Society of Composites, pages 1–20. DEStech 
% publications, Inc., 2008. null ;Conference date: 09-09-2008 Through 11-09-2008.

% 2. Koussios, S.Stress Concentrations around Holes Lecture Notes. Faculty of Aerospace 
%Engineering, Delft University of Technology, Delft, 2015

% INPUT(S)
% sign_delta: sign of delta

% OUTPUT(S)
% alpha: real part of s1 and s2
% beta: imaginary part of s1 and s2
% x = cosd(theta);
% y = sind(theta);
% delta = sqrt(z_k^2 - s_k^2 - 1)

sign_delta = zeros(2, 1);

switch x
    % N.B. the sign algorithm cannot handle case "x = 0" at the same
    % time; therefore, we need to differentiate between the zero and
    % non-zero x values.
    case 0
        for k = 1:2
            switch k
                case 1 % k = 1
                    if sign(y) == sign(imag(delta(k)))
                        sign_delta(k) = 1;
                    else
                        sign_delta(k) = -1;
                    end
                case 2 % k = 2
                    if sign(y) == sign(imag(delta(k)))
                        sign_delta(k) = 1;
                    else
                        sign_delta(k) = -1;
                    end
            end
        end
    otherwise
        for k = 1:2
            switch k
                case 1 % k = 1
                    if mod(theta, 90) == 0
                        if sign(y - alpha * x) == sign(imag(delta(k)))
                            sign_delta(k) = 1;
                        else
                            sign_delta(k) = -1;
                        end
                    else
                        if sign(beta * x) == sign(real(delta(k)))
                            sign_delta(k) = 1;
                        else
                            sign_delta(k) = -1;
                        end
                    end
                case 2 % k = 2
                    if mod(theta, 90) == 0
                        if sign(y - alpha * x) == sign(imag(delta(k)))
                            sign_delta(k) = 1;
                        else
                            sign_delta(k) = -1;
                        end
                    else
                        if sign(beta * x) == sign(real(delta(k)))
                            sign_delta(k) = 1;
                        else
                            sign_delta(k) = -1;
                        end
                    end
            end
        end
end