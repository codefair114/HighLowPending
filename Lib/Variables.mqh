//+------------------------------------------------------------------+
//|                                                    Variables.mqh |
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
#ifndef VARIABLES_MQH
#define VARIABLES_MQH
#endif 

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\AccountInfo.mqh>

struct Candle {
    double open;
    double close;
    double high;
    double low;
};

input double lotSize = 0.01; // LOT SIZE
input int stopLossPips = 100; // SL Pips
input int takeProfitPips = 200; // TP Pips
input int openHour = 10; // Hour when opening trades
input int closeHour = 16; // Hour when closing trades
input int liveTradeThreshold = 10; // Threshold to open live trade
input bool outbreak = false; // Reverse transactions for outbreak
input bool noSL = false; // Set SL of trades to 0
input bool noTP = false; // Set TP of trades to 0

bool marketOpen = false;
bool openTrades = false;
CTrade         trade; // Trades Info and Executions library
COrderInfo     order; //Library for Orders information
CPositionInfo  position; // Library for all position features and information