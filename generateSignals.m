function signals = generateSignals(price, sma)
    signals = zeros(size(price));
    for i = 2:length(price)
        if price(i-1) < sma(i-1) && price(i) > sma(i)
            signals(i) = 1; % Buy
        elseif price(i-1) > sma(i-1) && price(i) < sma(i)
            signals(i) = -1; % Sell
        end
    end
end
