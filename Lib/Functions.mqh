//+------------------------------------------------------------------+
//|                                                    Functions.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
#ifndef FUNCTIONS
#define FUNCTIONS_MQH
#endif

#include <Lib\Variables.mqh>

// Function to close all positions
void CloseAllPositions() {
for(int i = PositionsTotal() - 1; i >= 0; i--) // loop all Open Positions
   if(position.SelectByIndex(i)) { // Select a position
         trade.PositionClose(position.Ticket()); // then delete it --period
         Sleep(100); // Relax for 100 ms
     }
}

// Function to close all pending transactions
void CloseAllPendings() {
   for(int i = OrdersTotal() - 1; i >= 0; i--) // loop all orders available
      if(order.SelectByIndex(i)) { // Select an order
         trade.OrderDelete(order.Ticket()); // delete it --Period
         Sleep(100); // Relax for 100 ms
         
        }
}

// Define the function to check if the market is open
bool IsMarketOpen() {
    MqlDateTime currentTimeStruct;
    TimeToStruct(TimeCurrent(), currentTimeStruct);  // Convert current time to MqlDateTime structure
    if ((currentTimeStruct.day_of_week >= 1 && currentTimeStruct.day_of_week < 5) &&
        (currentTimeStruct.hour >= openHour && currentTimeStruct.hour <= closeHour)) {
      return true;
    }
    return false;
}

// Function to verify if market is open and reset trading week
void UpdateTradingCycle() {
    MqlDateTime currentTimeStruct;
    TimeToStruct(TimeCurrent(), currentTimeStruct);  // Convert current time to MqlDateTime structure
    marketOpen = IsMarketOpen();
    
    if (!marketOpen && openTrades && currentTimeStruct.day_of_week == 5 && currentTimeStruct.hour >= closeHour) {
      CloseAllPositions();
      CloseAllPendings();
      openTrades = false;
    }
}

// Function to get the latest closed candle data
Candle GetCandleByIndex(int idx) {
   Candle candle;
   candle.open = iOpen(NULL, 0, idx);
   candle.close = iClose(NULL, 0, idx);
   candle.high = iHigh(NULL, 0, idx);
   candle.low = iLow(NULL, 0, idx);
   return candle;
}

// Calculate the difference between 2 prices
double CalculatePipsDifference(double price1, double price2)
{
    double pointSize = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    return MathAbs(price1 - price2) / pointSize;
}

// Add pips to a given price
double AddPips(double price, int pips)
{
    double pointSize = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double newPrice = price + (pips * pointSize);
    return newPrice;
}

// Buy function for range pending strategy
bool InitiateBuyInRange(double entryPrice) {
   int orderId;
   double stopLoss = 0;
   double takeProfit = 0;
   // If the price is close to the pending, open live trade
   if (entryPrice >= SymbolInfoDouble(_Symbol, SYMBOL_ASK) ||
       CalculatePipsDifference(entryPrice, SymbolInfoDouble(_Symbol, SYMBOL_ASK)) <= liveTradeThreshold) {
       stopLoss = (noSL ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_ASK), -stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_ASK), takeProfitPips));
       orderId = trade.Buy(lotSize, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_ASK) , stopLoss, takeProfit, "Buy Order");
       if (!orderId) {
         return true;
       }
   } else {
       // Else place pending transaction
       stopLoss = (noSL ? 0 : AddPips(entryPrice, -stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(entryPrice, takeProfitPips));
       
       orderId = trade.BuyLimit(lotSize, entryPrice, _Symbol, stopLoss, takeProfit, ORDER_TIME_GTC, 0, "Buy limit Order");
          
       
       if (!orderId) {
         return true;
       }
   }
   return false;
}

// Sell function for range pending strategy
bool InitiateBuyOutbreak(double entryPrice) {
   int orderId;
   double stopLoss = 0;
   double takeProfit = 0;
   // If the price is close to the pending, open live trade
   if (entryPrice <= SymbolInfoDouble(_Symbol, SYMBOL_ASK) ||
       CalculatePipsDifference(entryPrice, SymbolInfoDouble(_Symbol, SYMBOL_ASK)) <= liveTradeThreshold) {
       stopLoss = (noSL ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_ASK), -stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_ASK), takeProfitPips));
       orderId = trade.Buy(lotSize, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_ASK) , stopLoss, takeProfit, "Buy Order");
       if (!orderId) {
         return true;
       }
   } else {
       // Else place pending transaction
       stopLoss = (noSL ? 0 : AddPips(entryPrice, -stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(entryPrice, takeProfitPips));
       
       orderId = trade.BuyStop(lotSize, entryPrice, _Symbol, stopLoss, takeProfit, ORDER_TIME_GTC, 0, "Buy stop Order");
          
       
       if (!orderId) {
         return true;
       }
   }
   return false;
}

// Buy function for range outbreak pending strategy
bool InitiateSellInRange(double entryPrice) {
   int orderId;
   double stopLoss = 0;
   double takeProfit = 0;
   // If the price is close to the pending, open live trade
   if (entryPrice <= SymbolInfoDouble(_Symbol, SYMBOL_BID) ||
       CalculatePipsDifference(entryPrice, SymbolInfoDouble(_Symbol, SYMBOL_BID)) <= liveTradeThreshold) {
       stopLoss = (noSL ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_BID), stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_BID), -takeProfitPips));
       orderId = trade.Sell(lotSize, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_BID), stopLoss, takeProfit, "Sell Order");
       if (!orderId) {
         return true;
       }
   } else {
       // Else place pending transaction
       stopLoss = (noSL ? 0 : AddPips(entryPrice, stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(entryPrice, -takeProfitPips));
       
       orderId = trade.SellLimit(lotSize, entryPrice, _Symbol, stopLoss, takeProfit, ORDER_TIME_GTC, 0, "Sell limit Order");
      
       if (!orderId) {
         return true;
       }
   }
   return false;
}

// Sell function for range outbreak pending strategy
bool InitiateSellOutbreak(double entryPrice) {
   int orderId;
   double stopLoss = 0;
   double takeProfit = 0;
   // If the price is close to the pending, open live trade
   if (entryPrice >= SymbolInfoDouble(_Symbol, SYMBOL_BID) ||
       CalculatePipsDifference(entryPrice, SymbolInfoDouble(_Symbol, SYMBOL_BID)) <= liveTradeThreshold) {
       stopLoss = (noSL ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_BID), stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(SymbolInfoDouble(_Symbol, SYMBOL_BID), -takeProfitPips));
       orderId = trade.Sell(lotSize, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_BID), stopLoss, takeProfit, "Sell Order");
       if (!orderId) {
         return true;
       }
   } else {
       // Else, place pending transaction
       stopLoss = (noSL ? 0 : AddPips(entryPrice, stopLossPips));
       takeProfit = (noTP ? 0 : AddPips(entryPrice, -takeProfitPips));
       
       orderId = trade.SellStop(lotSize, entryPrice, _Symbol, stopLoss, takeProfit, ORDER_TIME_GTC, 0, "Sell stop Order");
      
       if (!orderId) {
         return true;
       }
   }
   return false;
}

// Function to open the high & low pending trades
void OpenHLPendings() {
   Candle candle = GetCandleByIndex(1);
   bool buyInitiated = false;
   bool sellInitiated = false;
   // If market not open or have open trades, open no pendings
   if (!marketOpen || openTrades) {
       return;
   }
   if (marketOpen && !openTrades) {
      // If the outbreak strategy is used
      if (!outbreak) {
         buyInitiated = InitiateBuyInRange(candle.low);
         sellInitiated = InitiateSellInRange(candle.high);
      } else {
         // If the range strategy is used
         buyInitiated = InitiateBuyOutbreak(candle.high);
         sellInitiated = InitiateSellOutbreak(candle.low);
      }
      if (buyInitiated && sellInitiated) {
         openTrades = true;
      }
   }
}
