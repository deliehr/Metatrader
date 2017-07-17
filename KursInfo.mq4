//+------------------------------------------------------------------+
//|                                                     KursInfo.mq4 |
//|                                                    Dominik Liehr |
//|                                            http://www.idragon.de |
//+------------------------------------------------------------------+
// Version 1.2
#property copyright "Dominik Liehr"
#property link "http://www.idragon.de"

int globalFontSize = 25;
int globalDistanceX1 = 20;
int globalDistanceX2 = 150;

int init() {
  // Objekte erzeugen
  ObjectCreate("label_ask1", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_ask1", "Ask:", globalFontSize, "Arial", DeepSkyBlue);
  ObjectSet("label_ask1", OBJPROP_XDISTANCE, globalDistanceX1);
  ObjectSet("label_ask1", OBJPROP_YDISTANCE, 100);

  ObjectCreate("label_bid1", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_bid1", "Bid:", globalFontSize, "Arial", Red);
  ObjectSet("label_bid1", OBJPROP_XDISTANCE, globalDistanceX1);
  ObjectSet("label_bid1", OBJPROP_YDISTANCE, 130);

  ObjectCreate("label_spread1", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_spread1", "Spread:", globalFontSize, "Arial", LawnGreen);
  ObjectSet("label_spread1", OBJPROP_XDISTANCE, globalDistanceX1);
  ObjectSet("label_spread1", OBJPROP_YDISTANCE, 160);

  ObjectCreate("label_ask2", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_ask2", ".", globalFontSize, "Arial", DeepSkyBlue);
  ObjectSet("label_ask2", OBJPROP_XDISTANCE, globalDistanceX2);
  ObjectSet("label_ask2", OBJPROP_YDISTANCE, 100);

  ObjectCreate("label_bid2", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_bid2", ".", globalFontSize, "Arial", Red);
  ObjectSet("label_bid2", OBJPROP_XDISTANCE, globalDistanceX2);
  ObjectSet("label_bid2", OBJPROP_YDISTANCE, 130);

  ObjectCreate("label_spread2", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_spread2", ".", globalFontSize, "Arial", LawnGreen);
  ObjectSet("label_spread2", OBJPROP_XDISTANCE, 233);
  ObjectSet("label_spread2", OBJPROP_YDISTANCE, 160);
 
  return(0);
}

// arrow code
// 225 / 233 / 241 - oben
// 226 / 234 / 242 - unten

double lastValue;
double valuesFive[5];
int zeiger=0;

int start() {
  double val = Ask - Bid;
  double spread = MarketInfo(Symbol(), MODE_SPREAD);
  spread = spread / 10.0;
  Comment("Spread: " + DoubleToStr(spread, 1) + " (" + DoubleToStr(val, 5) +  ")");

  // bool ObjectCreate(string name, int type, int window, datetime time1, double price1, datetime time2=0, double price2=0, datetime time3=0, double price3=0)
  ObjectSetText("label_ask2", DoubleToStr(Ask, 5), globalFontSize, "Arial", DeepSkyBlue);
  ObjectSetText("label_bid2", DoubleToStr(Bid, 5), globalFontSize, "Arial", Red);
  ObjectSetText("label_spread2", "" + DoubleToStr(MarketInfo("EURUSD", MODE_SPREAD), 0), globalFontSize, "Arial", LawnGreen);

  /*

  // set current value
  valuesFive[zeiger] = Ask;

  analyzeLast();
  analyzeLastFive();   

  // change zeiger
  zeiger = zeiger + 1;
  if(zeiger > 4) { zeiger =0; }
  */

  return(0);
}

void analyzeLast() {
  // analyze last
  if(zeiger == 0) {
     if(Ask > valuesFive[4]) {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 233);
     } else if(Ask < valuesFive[4]) {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 234);
     } else {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 167);
     }
  } else {
     if(Ask > valuesFive[zeiger-1]) {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 233);
     } else if(Ask < valuesFive[zeiger-1]) {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 234);
     } else {
        ObjectSet("arrow1", OBJPROP_ARROWCODE, 167);
     }
  }
}

void analyzeLastFive() {
   // analyze last 5
  double tempValues[5];

  if(zeiger == 0) {
     tempValues[0] = valuesFive[zeiger];
     int j=1;

     for(int i=4;i >= 1;i--) {
        tempValues[j] = valuesFive[i];
        j++;   
     }
  } else if(zeiger == 4) {
     int k=0;

     for(int l=4;l >= 0;l--) {
        tempValues[k] = valuesFive[l];
        k++;
     }
  } else {
     int t=0;

     for(int f=zeiger;f >= 0;f--) {
        tempValues[t] = valuesFive[f];
        t++;
     }

     for(int g=4;g >= (zeiger+1);g--) {
        tempValues[t] = valuesFive[g];
        t++;
     }
  }

  // analyzing
  double mw = mittelwert(tempValues);
  if(tempValues[0] < mw) {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 234);
  } else if(tempValues[0] == mw) {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 167);
  } else {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 233);
  }
}

void analyzeLastTen() {
   // analyze last 5
  double tempValues[10];

  if(zeiger == 0) {
     tempValues[0] = valuesFive[zeiger];
     int j=1;

     for(int i=4;i >= 1;i--) {
        tempValues[j] = valuesFive[i];
        j++;   
     }
  } else if(zeiger == 4) {
     int k=0;

     for(int l=4;l >= 0;l--) {
        tempValues[k] = valuesFive[l];
        k++;
     }
  } else {
     int t=0;

     for(int f=zeiger;f >= 0;f--) {
        tempValues[t] = valuesFive[f];
        t++;
     }

     for(int g=4;g >= (zeiger+1);g--) {
        tempValues[t] = valuesFive[g];
        t++;
     }
  }

  // analyzing
  double mw = mittelwert(tempValues);
  if(tempValues[0] < mw) {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 234);
  } else if(tempValues[0] == mw) {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 167);
  } else {
     ObjectSet("arrow2", OBJPROP_ARROWCODE, 233);
  }
}

double mittelwert(double values[]) {
  double sum = 0.0;

  for(int i=0;i < ArraySize(values);i++) {
     sum = sum + values[i];
  }

  return(sum / ArraySize(values));
}

int deinit() {
  ObjectDelete("label_ask");
  ObjectDelete("label_spread");
 // ObjectDelete("arrow1");
  //ObjectDelete("arrow2");

  return(0);
}