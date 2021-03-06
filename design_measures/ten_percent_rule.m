function [tag, zero_of_tot, p45_of_tot, m45_of_tot, ninty_of_tot] = ten_percent_rule(t, theta)
% monitoring 10-percent rule
% 10% rule is disregarded. At least plies with angles of{0, 45, ${\pm}$45, 90} should
% share 10% of laminate total thickness for various load cases so that in case of
% failure, a brittle incautious will not happen.

% INPUT(S)
% mat: material properties

% originally coded by Amir Baharvand (08-20)

tag = {'0 deg'; '45 deg'; '-45 deg'; '90 deg'};
zero = find(theta == 0); % 0 degree
p_fourty_five = find(theta == 45); % plus 45 degree
m_fourty_five = find(theta == -45); % minus 45 degree
ninty = find(theta == 90); % 90 degree
zero_of_tot = length(zero) / (length(t) * 2) * 100; % percent of 0 degree plies of total
p45_of_tot = length(p_fourty_five) / (length(t) * 2) * 100; % percent of 45 degree plies of total
m45_of_tot = length(m_fourty_five) / (length(t) * 2) * 100; % percent of -45 degree plies of total
ninty_of_tot = length(ninty) / (length(t) * 2) * 100; % percent of 90 degree plies of total

% pop-up message for 10-percent rule in case of invasion
if ( zero_of_tot + p45_of_tot + m45_of_tot + ninty_of_tot ) <= 10
    ten_p_msg = ['10% rule is disregarded. At least plies with angles ', ...
        'of{0, 45, ${\pm}$45, 90} should share 10% of laminate total thickness for various load cases ', ...
        'so that in case of failure, a brittle incautious will not happen.'];
    msgbox(ten_p_msg, '10% rule warning!');
end