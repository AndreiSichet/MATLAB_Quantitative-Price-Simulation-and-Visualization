function signals = strategy_EMA(price, params)
fast = params.fast;
slow = params.slow;

emaFast = computeEMA(price, fast);
emaSlow = computeEMA(price, slow);

signals = zeros(length(price),1);
for i = 2:length(price)
    if emaFast(i) > emaSlow(i) && emaFast(i-1) <= emaSlow(i-1)
        signals(i) = 1;
    elseif emaFast(i) < emaSlow(i) && emaFast(i-1) >= emaSlow(i-1)
        signals(i) = -1;
    end
end
end
