# **Expert Advisor for MetaTrader 5 (MT5): High Low Pending Trades**

## **Overview**

This Expert Advisor (EA) for MetaTrader 5 (MT5) is designed to automate trading strategies based on the high and low of the previously closed candlestick. The EA allows traders to open pending trades, both limit and stop orders, at specified high and low levels, with additional options for setting stop-loss (SL) and take-profit (TP) values.

## **Features**

- Opens trades at the high and low of the last closed candlestick.
- Configurable lot size, SL, TP, open and close hours, and other parameters.
- Option to set SL and TP to 0 for specific trades.
- Ability to reverse transactions for breakout strategies.
- Automatic closing of positions and pending orders at the end of the trading week.

## **Installation**

1. Copy the Expert Advisor (**`.ex5`**) file to the "Experts" folder of your MetaTrader 5 installation.
2. Restart MetaTrader 5.
3. Attach the EA to the desired chart and configure the input parameters.

## **Input Parameters**

- **`lotSize`**: Lot size for trading.
- **`stopLossPips`**: Stop-loss distance in pips.
- **`takeProfitPips`**: Take-profit distance in pips.
- **`openHour`**: Hour when opening trades.
- **`closeHour`**: Hour when closing trades.
- **`liveTradeThreshold`**: Threshold to open live trades.
- **`outbreak`**: Set to true to reverse transactions for breakout strategies.
- **`noSL`**: Set to true to set SL of trades to 0.
- **`noTP`**: Set to true to set TP of trades to 0.

## **Functions**

- **`CloseAllPositions()`**: Closes all open positions.
- **`CloseAllPendings()`**: Deletes all pending orders.
- **`IsMarketOpen()`**: Checks if the market is open based on specified trading hours.
- **`UpdateTradingCycle()`**: Verifies if the market is open and resets the trading week.
- **`GetCandleByIndex(int idx)`**: Retrieves data for the latest closed candle.
- **`CalculatePipsDifference(double price1, double price2)`**: Calculates the difference in pips between two prices.
- **`AddPips(double price, int pips)`**: Adds a specified number of pips to a given price.
- Buy and sell initiation functions for both range and breakout pending strategies.
- **`OpenHLPendings()`**: Opens high and low pending trades based on the selected strategy.

## **Usage**

1. Attach the EA to a chart in MetaTrader 5.
2. Configure input parameters according to your trading preferences.
3. Monitor the EA's actions in the Experts and Journal tabs.
4. Analyze and adjust settings as needed.

## **Disclaimer**

Use this Expert Advisor at your own risk. Past performance is not indicative of future results. The author is not responsible for any financial losses incurred while using this EA.

## **Support**

For inquiries or issues, please contact the author at [contact@alexandrachirita.com].
