function signals = strategy_RSI(price, params)
period = params.period;
lower = params.lower;
upper = params.upper;

rsi = computeRSI(price, period);
signals = zeros(length(price),1);

for i = 2:length(price)
    if rsi(i) < lower && rsi(i-1) >= lower
        signals(i) = 1;
    elseif rsi(i) > upper && rsi(i-1) <= upper
        signals(i) = -1;
    end
end
end
