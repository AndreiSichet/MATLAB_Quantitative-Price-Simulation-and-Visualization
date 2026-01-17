function ema = computeEMA(price, window)
% Exponential moving average
alpha = 2/(window+1);
ema = zeros(size(price));
ema(1) = price(1);
for i = 2:length(price)
    ema(i) = alpha*price(i) + (1-alpha)*ema(i-1);
end
end
