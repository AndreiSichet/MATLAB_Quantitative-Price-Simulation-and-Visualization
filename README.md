# Quant Trading Simulator (MATLAB)

A MATLAB-based quantitative trading simulator for modeling stochastic stock prices and evaluating trading strategies.  
This project demonstrates **quantitative trading concepts** including price simulation, technical indicators, signal generation, and backtesting with performance metrics.

---

## Features

- **Geometric Brownian Motion (GBM)** price simulation
- **Trading strategies**:
  - Simple Moving Average (SMA)
  - Exponential Moving Average (EMA)
  - Relative Strength Index (RSI)
- **Backtesting metrics**:
  - Equity curves
  - Profit & Loss (PnL)
  - Returns
  - Sharpe Ratio
  - Maximum Drawdown
- **3D Monte Carlo simulations** of multiple stochastic paths
- Compute **average PnL across all simulations**
- Interactive **GUI** for input parameters and strategy comparison
- Modular design: each strategy and utility has its own function file

---

## File Structure

| File | Description |
|------|-------------|
| `ProjectGUI.m` | Main GUI and workflow |
| `computeSMA.m` | Computes Simple Moving Average |
| `computeEMA.m` | Computes Exponential Moving Average |
| `computeRSI.m` | Computes Relative Strength Index |
| `strategy_SMA.m` | SMA trading signal generator |
| `strategy_EMA.m` | EMA trading signal generator |
| `strategy_RSI.m` | RSI trading signal generator |
| `runBacktest.m` | Backtesting engine (Equity, PnL, Returns, Sharpe, Max Drawdown) |
| `backtest3D.m` | Backtest across 3D Monte Carlo simulations |
| `simulateGBM.m` | Single GBM price path simulation |
| `simulateGBM_3D.m` | Multiple GBM paths for Monte Carlo analysis |
| `generateSignals.m` | (Optional) Utility to generate signals |

---

## How to Use

1. Open MATLAB and navigate to this repository folder.
2. Run `ProjectGUI.m` to launch the GUI.
3. Enter parameters:
   - **Initial Price S0**
   - **Drift mu**
   - **Volatility sigma**
   - **Time Horizon T** (in years)
   - **SMA Window**
   - **Number of Simulations** (for Monte Carlo)
4. Use buttons:
   - **Generate Price** — simulate a single GBM path
   - **Apply Strategy** — compute signals, equity curves, and stats (Sharpe & Max Drawdown) for SMA, EMA, and RSI
   - **3D Monte Carlo** — simulate multiple GBM paths and compute average PnL for each strategy
5. Strategy statistics are displayed in the GUI panel.

---
