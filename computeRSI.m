function rsi = computeRSI(price, period)
delta = diff(price);
gain = max(delta,0);
loss = max(-delta,0);

avgGain = movmean(gain, [period-1 0]);
avgLoss = movmean(loss, [period-1 0]);

rs = avgGain ./ (avgLoss + eps);
rsi = 100 - (100 ./ (1 + rs));

% Align size
rsi = [50; rsi];
end
