//+------------------------------------------------------------------+
//|                                                    TwoOnOnce.mq4 |
//|                                                    Dominik Liehr |
//|                                            http://www.idragon.de |
//+------------------------------------------------------------------+
#property copyright "Dominik Liehr"
#property link      "http://www.idragon.de"
#property version   "1.01"
#property strict

#include <TOO.mqh>

int ticketBuy;
int ticketSell;
int max_wait = 25;
double volume = 0.01;
bool trade_init = false;

int OnInit() {
   init_();
   
   // erzeuge Labels
   ObjectCreate(0, "lblStatus", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("lblStatus", "Status", 20, "Arial", clrRed);
   ObjectSet("lblStatus",OBJPROP_XDISTANCE,10);
   ObjectSet("lblStatus",OBJPROP_YDISTANCE,20);
   
   return(INIT_SUCCEEDED);
}

void init_() {
   // erzeuge zwei gegensätzliche trades
   // BUY = Ask-Preis, SELL = Bid-Preis
   ticketBuy = sendTrade(OP_BUY, Ask, volume, 10);
   ticketSell = sendTrade(OP_SELL, Bid, volume, 10);
   
   // init Variable setzen
   trade_init = true;
}

void OnDeinit(const int reason) {
   // lösche alle Trades
   //closeAllOrders();
   
   // lösche Labels
   ObjectDelete("lblStatus");
}

bool closed = false;
int ticketToWatch = 0;
void OnTick() {
   // prüfen, ob Trades gerade mal initialisiert worden sind
   if(trade_init) {
      // trades wurden initialisiert 
      // oder befinden sich noch nicht im plus
      // Label: Info an User geben
      ObjectSetText("lblStatus", "Status: init-Phase", 20, "Arial", clrRed);
      
      // BUY überprüfen
      OrderSelect(ticketBuy, SELECT_BY_TICKET);
      
      if(OrderProfit() >= 0.1) {
         // BUY ist im Plus, andere Position verkaufen
         closeTrade(ticketSell);
         closed = true;
         trade_init = false;
         ticketToWatch = ticketBuy;
      }
      
      // SELL überprüfen
      if(closed == false) {
         OrderSelect(ticketSell, SELECT_BY_TICKET);
         
         if(OrderProfit() >= 0.1) {
            // SELL ist im Plus, andere Position verkaufen
            closeTrade(ticketBuy);
            trade_init = false;
            ticketToWatch = ticketSell;
         }
      }
   } else {
      // einer der beiden Trades wurde bereits geschlossen, den anderen überwachen 
      // überprüfen, ob überhaupt noch Trades vorhanden sind
      if(OrdersTotal() > 0) {
         // Trades sind noch im Rennen
         // Label: Info an User geben
         ObjectSetText("lblStatus", "Status: Überwachungsphase", 20, "Arial", clrRed);
         //watch(ticketToWatch);
      } else {
         // keine Trades mehr vorhanden
         // INIT-Phase wieder einleiteun und Variablen zurücksetzen
         lastBestY_BUY = 0.0;
         lastBestY_SELL = 2.0;
         closed = false;
         init_();
      }      
   }
}

double lastBestY_BUY = 0.0;
double lastBestY_SELL = 2.0;
void watch(int ticket) {
   // erstmal selektieren (Vorsichtsmaßnahme)
   OrderSelect(ticket, SELECT_BY_TICKET);
   
   // zwischen BUY und SELL unterscheiden
   if(OrderType() == OP_BUY) {
      // BUY
      if(Ask >= lastBestY_BUY) {
         // der BUY-Trade hat sich, in die passende Richtung verbessert, nachziehen
         lastBestY_BUY = Ask;
         
         // ändere Trade
         OrderModify(OrderTicket(), OrderOpenPrice(), Ask - 0.00020, Ask + 0.00020, 0, clrBlue);
         
         Alert("Order Modified");
         
         if(GetLastError() > 0) {
            Print("Fehler:");
            Print(GetLastError());
         }
      }
   } else if(OrderType() == OP_SELL) {
      // SELL
      // ÜBERDENKEN: ASK ODER BID NEHMEN?
      if(Ask <= lastBestY_SELL) {
         // der SELL-Trade hat sich, in die passende Richtung verbessert, nachziehen
         lastBestY_SELL = Ask;
         
         // ändere Trade
         OrderModify(OrderTicket(), OrderOpenPrice(), Ask + 0.00020, Ask - 0.00020, 0, clrBlue);
         
         Alert("Order Modified");
         
         if(GetLastError() > 0) {
            Print("Fehler:");
            Print(GetLastError());
         }
      }
   }
   
   /* 
   Erinnerung an Programmierer:
   
   Da z.B. der BUY immer nachgezogen wird (TAKE Profit und STOPP Loss), kann ein BUY nie durch seine TAKE-Profit-Grenze geschlossen werden (da sie ja immer nachgezogen wird).
   Ein BUY kann dadurch immer nur Verlustbehaftet durch seinen STOPP Loss geschlossen werden
   */
}