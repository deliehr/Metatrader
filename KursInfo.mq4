//+------------------------------------------------------------------+
//|                                                         Info.mq4 |
//|                                                    Dominik Liehr |
//|                                            http://www.idragon.de |
//+------------------------------------------------------------------+
// Version 1.1
#property copyright "Dominik Liehr"
#property link "http://www.idragon.de"

int init() {
  // Objekte erzeugen
  ObjectCreate("label_ask", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_ask", "ask", 30, "Arial", DeepSkyBlue);
  ObjectSet("label_ask", OBJPROP_XDISTANCE, 20);
  ObjectSet("label_ask", OBJPROP_YDISTANCE, 100);

  ObjectCreate("label_bid", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_bid", "bid", 25, "Arial", Red);
  ObjectSet("label_bid", OBJPROP_XDISTANCE, 29);
  ObjectSet("label_bid", OBJPROP_YDISTANCE, 125);

  ObjectCreate("label_spread", OBJ_LABEL, 0, 0, 0, 0, 0, 0, 0);
  ObjectSetText("label_spread", ".", 30, "Arial", LawnGreen);
  ObjectSet("label_spread", OBJPROP_XDISTANCE, 48);
  ObjectSet("label_spread", OBJPROP_YDISTANCE, 150);

  /*
  ObjectCreate ("arrow1",OBJ_ARROW, 0, Time[180], Low[10]);
  ObjectSet("arrow1",OBJPROP_COLOR,DeepSkyBlue);
  ObjectSet("arrow1",OBJPROP_WIDTH,20.0);
  ObjectSet("arrow1",OBJPROP_ARROWCODE,242);

  ObjectCreate("arrow2",OBJ_ARROW, 0, Time[160], Low[10]);
  ObjectSet("arrow2",OBJPROP_COLOR,DeepSkyBlue);
  ObjectSet("arrow2",OBJPROP_WIDTH,20.0);
  ObjectSet("arrow2",OBJPROP_ARROWCODE,242);

  ObjectCreate("arrow3",OBJ_ARROW, 0, Time[140], Low[10]);
  ObjectSet("arrow3",OBJPROP_COLOR,DeepSkyBlue);
  ObjectSet("arrow3",OBJPROP_WIDTH,20.0);
  ObjectSet("arrow3",OBJPROP_ARROWCODE,242);
  */

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
  ObjectSetText("label_ask", "Ask: "+DoubleToStr(Ask, 5), 20, "Arial", DeepSkyBlue);
   ObjectSetText("label_bid", "Bid: "+DoubleToStr(Bid, 5), 20, "Arial", Red);
  ObjectSetText("label_spread", "Spread: "+DoubleToStr(MarketInfo("EURUSD", MODE_SPREAD), 2), 20, "Arial", LawnGreen);

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