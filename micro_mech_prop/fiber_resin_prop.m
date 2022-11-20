% fiber micro-mechanical properties
micro.fiber.name = "Carbon AS4"; % N.B. with underscore and no space / hyphen
micro.fiber.rho = 1.79e-9; % fiber density [tonne/mm3]
micro.fiber.El = 235e3; % fiber longitudinal modulus [MPa]
micro.fiber.Et = 15e3; % fiber transverse modulus [MPa]
micro.fiber.G = 27e3; % fiber in-plane shear modulus [MPa]
micro.fiber.nu = 0.2; % fiber in-plane Poisson's ratio
micro.fiber.Vf = 0.6; % fiber volume fraction

% resin micro-mechanical properties
micro.resin.name = "35016 Epoxy"; % N.B. with underscore and no space / hyphen
micro.resin.rho = 1.27e-9; % resin density [tonne/mm3]
micro.resin.E = 4.3e3; % resin modulus [MPa]
micro.resin.nu = 0.35; % resin Poisson's ratio
micro.resin.G = micro.resin.E / (2 * (1 + micro.resin.nu)); % resin shear modulus [MPa]

% Halpin-Tsai parameters
micro.ht.xi = 1; % compaction 
% xi = 1 for glass and carbon (Daniel, I. M., & Ishai, O. (2006). Engineering Mechanics 
% of Composite Materials. (Second ed.) Oxford University Press.)

% lamina name
lamina_name = strrep(strcat(micro.fiber.name, micro.resin.name), ' ', '');