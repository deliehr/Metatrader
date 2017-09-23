//+------------------------------------------------------------------+
//|                                                          TOO.mqh |
//|                                                    Dominik Liehr |
//|                                            http://www.idragon.de |
//+------------------------------------------------------------------+
#property copyright "Dominik Liehr"
#property link      "http://www.idragon.de"
#property strict
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

int sendTrade(int cmd, double price, double volume, int slippage) {
   int ticket = 0;
   int n = OrdersTotal();
   
   while(OrdersTotal() != (n+1)) {
      if(IsTradeAllowed() && IsTradeContextBusy() == false) {
         // Versuche, Trade auszuführen
         ticket = OrderSend(Symbol(), cmd, volume, price, slippage, 0.0, 0.0, "");
         // Fehler entstanden?
         if(GetLastError() > 0) {
            Print("Fehler: " + IntegerToString(GetLastError()));
         }
      } else {
         // warte 100 ms
         Sleep(100);
      }
   }
   
   return(ticket);
}

bool closeTrade(int ticket) {
   bool success = false;
   int n = OrdersTotal();
   
   // Versuche Trade zu schließen
   while(OrdersTotal() != (n-1)) {
      // Trade-Markt verfügbar?
      if(IsTradeAllowed() && IsTradeContextBusy() == false) {
         // Versuche Trade zu selektieren
         if(OrderSelect(ticket, SELECT_BY_TICKET)) {
            OrderClose(ticket, OrderLots(), OrderClosePrice(), 10);
         }
      } else {
         // warte 100 ms
         Sleep(100);
      }
   }
   
   return(success);
}

void closeAllOrders() {
   // schließe alle trades
   while(OrdersTotal() > 0) {
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)) {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL){
            if(IsTradeAllowed() && IsTradeContextBusy() == false) {
               OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),666,CLR_NONE);
            }
         } else {
            if(IsTradeAllowed() && IsTradeContextBusy() == false) {
               OrderDelete(OrderTicket());
            }
         }
      }
      Sleep(100);
   }
}