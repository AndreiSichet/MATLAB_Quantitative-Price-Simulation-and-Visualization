function signals = strategy_SMA(price, params)
window = params.window;
sma = computeSMA(price, window);
signals = zeros(length(price),1);

for i = 2:length(price)
    if price(i) > sma(i) && price(i-1) <= sma(i-1)
        signals(i) = 1;
    elseif price(i) < sma(i) && price(i-1) >= sma(i-1)
        signals(i) = -1;
    end
end
end
