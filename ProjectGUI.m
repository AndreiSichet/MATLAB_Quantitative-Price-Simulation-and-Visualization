function ProjectGUI()
% ============================================================
% Quant Trading Simulator
% - GBM price simulation
% - SMA, EMA, RSI strategies
% - Backtesting: Equity, PnL, Returns, Sharpe, Max Drawdown
% - 3D Monte Carlo visualization
% ============================================================

    %% === CREATE GUI ===
    f = figure('Position',[100 100 1000 550], ...
               'Name','Quant Trading Simulator', ...
               'NumberTitle','off');

    ax = axes('Parent',f,'Position',[0.35 0.15 0.6 0.75]);

    %% === INPUT FIELDS ===
    uicontrol('Style','text','Position',[20 450 100 20],'String','Initial Price S0');
    S0Field = uicontrol('Style','edit','Position',[130 450 100 25],'String','100');

    uicontrol('Style','text','Position',[20 410 100 20],'String','Drift mu');
    muField = uicontrol('Style','edit','Position',[130 410 100 25],'String','0.05');

    uicontrol('Style','text','Position',[20 370 120 20],'String','Volatility sigma');
    sigmaField = uicontrol('Style','edit','Position',[130 370 100 25],'String','0.2');

    uicontrol('Style','text','Position',[20 330 120 20],'String','Time Horizon T');
    TField = uicontrol('Style','edit','Position',[130 330 100 25],'String','1');

    uicontrol('Style','text','Position',[20 290 120 20],'String','SMA Window');
    SMAField = uicontrol('Style','edit','Position',[130 290 100 25],'String','20');

    uicontrol('Style','text','Position',[20 250 120 20],'String','Nr. Simulations');
    SimField = uicontrol('Style','edit','Position',[130 250 100 25],'String','20');

    %% === BUTTONS ===
    uicontrol('Style','pushbutton','Position',[50 200 150 30], ...
        'String','Generate Price','Callback',@generatePrice);

    uicontrol('Style','pushbutton','Position',[50 160 150 30], ...
        'String','Apply Strategy','Callback',@applyStrategy);

    uicontrol('Style','pushbutton','Position',[50 120 150 30], ...
        'String','3D Monte Carlo','Callback',@plot3D);

    %% === PANEL FOR STATISTICS ===
    statsPanel = uipanel('Title','Strategy Stats','Position',[0.02 0.06 0.3 0.15]); 
    statsText = uicontrol('Parent',statsPanel,'Style','text','Units','normalized', ...
                          'Position',[0.05 0.05 0.9 0.9],'String','', 'FontSize',10, ...
                          'HorizontalAlignment','left');

    %% === DATA STORAGE ===
    data.price = [];

    %% =========================================================
    %% === CALLBACK FUNCTIONS ===
    %% =========================================================

    function generatePrice(~,~)
        S0 = str2double(S0Field.String);
        mu = str2double(muField.String);
        sigma = str2double(sigmaField.String);
        T = str2double(TField.String);

        N = 200;
        data.price = simulateGBM(S0,mu,sigma,T,N);
        t = linspace(0,T,N+1);

        cla(ax);
        plot(ax,t,data.price,'b','LineWidth',1.5);
        grid(ax,'on');
        xlabel(ax,'Time (years)');
        ylabel(ax,'Price');
        title(ax,'Simulated GBM Price');
    end

    function applyStrategy(~,~)
        if isempty(data.price)
            errordlg('Generate price first!');
            return;
        end

        T = str2double(TField.String);
        N = length(data.price)-1;
        t = linspace(0,T,N+1);
        initialCapital = 10000;

        %% === SMA Strategy ===
        smaParams.window = str2double(SMAField.String);
        signals_SMA = strategy_SMA(data.price, smaParams);
        [equity_SMA,~,~,sharpe_SMA,maxDD_SMA] = runBacktest(data.price, signals_SMA, initialCapital);

        %% === EMA Strategy ===
        emaParams.fast = 12; emaParams.slow = 26;
        signals_EMA = strategy_EMA(data.price, emaParams);
        [equity_EMA,~,~,sharpe_EMA,maxDD_EMA] = runBacktest(data.price, signals_EMA, initialCapital);

        %% === RSI Strategy ===
        rsiParams.period = 14; rsiParams.lower = 30; rsiParams.upper = 70;
        signals_RSI = strategy_RSI(data.price, rsiParams);
        [equity_RSI,~,~,sharpe_RSI,maxDD_RSI] = runBacktest(data.price, signals_RSI, initialCapital);

        %% === Plot Equity Curves ===
        figure('Name','Equity Curve Comparison','Position',[300 200 900 450]);
        plot(t, equity_SMA,'LineWidth',2); hold on;
        plot(t, equity_EMA,'LineWidth',2);
        plot(t, equity_RSI,'LineWidth',2);
        grid on;
        xlabel('Time (years)');
        ylabel('Equity');
        title('Strategy Comparison');
        legend('SMA','EMA','RSI','Location','best');

        %% === Update stats panel ===
        statsStr = sprintf(['SMA: Sharpe %.2f, MaxDD %.2f%%\n', ...
                            'EMA: Sharpe %.2f, MaxDD %.2f%%\n', ...
                            'RSI: Sharpe %.2f, MaxDD %.2f%%'], ...
                            sharpe_SMA,maxDD_SMA*100, ...
                            sharpe_EMA,maxDD_EMA*100, ...
                            sharpe_RSI,maxDD_RSI*100);
        set(statsText,'String',statsStr);
    end

function plot3D(~,~)
    % --- Read GUI parameters ---
    S0 = str2double(S0Field.String);
    mu = str2double(muField.String);
    sigma = str2double(sigmaField.String);
    T = str2double(TField.String);
    M = str2double(SimField.String);  % number of Monte Carlo simulations
    initialCapital = 10000;           % starting capital for backtest

    N = 200;  % number of steps
    t = linspace(0,T,N+1);

    % --- Generate 3D GBM simulations ---
    S = simulateGBM_3D(S0, mu, sigma, T, N, M);

    % --- Plot 3D Monte Carlo paths ---
    figure('Name','3D Monte Carlo','Position',[200 200 800 500]);
    ax3 = axes;
    hold(ax3,'on'); grid(ax3,'on'); view(ax3,3);

    for j = 1:M
        plot3(ax3, t, j*ones(size(t)), S(:,j));
    end

    xlabel('Time (years)');
    ylabel('Simulation');
    zlabel('Price');
    title('3D Monte Carlo GBM Paths');

    % --- BACKTEST ON ALL SIMULATIONS ---
    % SMA
    smaParams.window = str2double(SMAField.String);
    avgPnL_SMA = backtest3D(S, @strategy_SMA, smaParams, initialCapital);

    % EMA
    emaParams.fast = 12; 
    emaParams.slow = 26;
    avgPnL_EMA = backtest3D(S, @strategy_EMA, emaParams, initialCapital);

    % RSI
    rsiParams.period = 14; 
    rsiParams.lower = 30; 
    rsiParams.upper = 70;
    avgPnL_RSI = backtest3D(S, @strategy_RSI, rsiParams, initialCapital);

    % --- SHOW RESULTS ---
    msgbox(sprintf('Average PnL over %d Monte Carlo simulations:\n\nSMA: %.2f\nEMA: %.2f\nRSI: %.2f', ...
            M, avgPnL_SMA, avgPnL_EMA, avgPnL_RSI), '3D Monte Carlo PnL');

    hold(ax3,'off');
end
end
