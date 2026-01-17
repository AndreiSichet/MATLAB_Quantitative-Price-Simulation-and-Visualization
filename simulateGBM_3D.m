function S = simulateGBM_3D(S0, mu, sigma, T, N, M)
dt = T/N;
S = zeros(N+1,M);
S(1,:) = S0;
for j = 1:M
    for i = 2:N+1
        dW = sqrt(dt)*randn;
        S(i,j) = S(i-1,j)*exp((mu-0.5*sigma^2)*dt + sigma*dW);
    end
end
end
