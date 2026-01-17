function avgPnL = backtest3D(S, strategyFunc, params, initialCapital)
% S = (N+1) x M matrix with all simulations
% strategyFunc = @strategy_SMA / @strategy_EMA / @strategy_RSI
% params = struct with strategy params
% initialCapital = initial sum for backtest

[N, M] = size(S);
avgPnL = 0;
finalPnL = zeros(M,1);

for j = 1:M
    pricePath = S(:,j);
    signals = strategyFunc(pricePath, params);
    [equity,~,~,~,~] = runBacktest(pricePath, signals, initialCapital);
    finalPnL(j) = equity(end) - initialCapital;
end

avgPnL = mean(finalPnL);
end
