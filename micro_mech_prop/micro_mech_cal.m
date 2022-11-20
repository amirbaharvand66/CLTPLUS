function [rho, E11, E22, G12, v12] = micro_mech_cal(micro, method)
% calculating lamina properties
% N.B. void content is assumed to be zero
% N.B. rule of mixture (ROM) is always used for lamina density

% INPUT(S)
% micro: micro-mechanical properties of fiber and resin
% method = 'ROM' (rule of mixture)
%              = 'HT' (Halpin-Tsai)

% extracting fiber micro-mechanical properties
rho_f = micro.fiber.rho;
Ef_l = micro.fiber.El;
Ef_t = micro.fiber.Et;
Gf = micro.fiber.G;
nu_f = micro.fiber.nu;
Vf = micro.fiber.Vf;

% extracting resin micro-mechanical properties
rho_m = micro.resin.rho;
Em = micro.resin.E;
Gm = micro.resin.G;
nu_m = micro.resin.nu;
Vm = 1 - Vf;

% lamina mechanical properties
rho = Vf * rho_f + Vm * rho_m; % density
E11 = Vf * Ef_l + Vm * Em; % longitudinal Young's modulus
v12 = Vf * nu_f + Vm * nu_m; % in-plane Poisson's ratio
switch method
    case 'ROM'
        E22 = Ef_t * Em / (Vf * Em + Vm * Ef_t); % transverse Young's modulus
        G12 = Gf * Gm / (Vf * Gm + Vm * Gf); % in-plane shear modulus
    case 'HT'
        % Halpin-Tsai parameters
        xi = micro.ht.xi;
        eta = (Ef_t - Em) / (Ef_t + xi * Em);
        E22 = Em * (1 + xi * eta * Vf) / (1 - eta * Vf); % transverse Young's modulus
        eta = (Gf - Gm) / (Gf + xi * Gm);
        G12 = Gm * (1 + xi * eta * Vf) / (1 - eta * Vf); % in-plane shear modulus
end