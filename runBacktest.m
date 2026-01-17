function [equity, pnl, returns, sharpe, maxDD] = runBacktest(price, signals, capital)
position = 0; % 0 = cash, 1 = long
shares = 0; cash = capital;

N = length(price);
equity = zeros(N,1);
pnl = zeros(N,1);
returns = zeros(N,1);

for i = 1:N
    if signals(i) == 1 && position == 0
        shares = cash / price(i);
        cash = 0;
        position = 1;
    elseif signals(i) == -1 && position == 1
        cash = shares * price(i);
        shares = 0;
        position = 0;
    end
    equity(i) = cash + shares*price(i);
    if i>1
        pnl(i) = equity(i)-equity(i-1);
        returns(i) = pnl(i)/equity(i-1);
    end
end

sharpe = mean(returns)/std(returns + eps) * sqrt(252); % annualized
drawdown = max( cummax(equity) - equity );
maxDD = max(drawdown)/capital;
end
