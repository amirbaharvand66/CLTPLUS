function stress_on_distance(R)
mkr = {':', '--', '-'};
for ii = 1:length(R)
    sigma_r_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end

for ii = 1:length(R)
    sigma_theta_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end

for ii = 1:length(R)
    tau_rt_on_hole(epsilon, theta, R(ii), alpha, beta, s_k, h_k, c_k, mkr{ii})
end