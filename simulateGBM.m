function price = simulateGBM(S0, mu, sigma, T, N)
dt = T/N;
price = zeros(N+1,1);
price(1) = S0;
for i = 2:N+1
    dW = sqrt(dt)*randn;
    price(i) = price(i-1)*exp((mu - 0.5*sigma^2)*dt + sigma*dW);
end
end
