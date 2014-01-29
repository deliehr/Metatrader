//+------------------------------------------------------------------+
//|                                                       Upload.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   // get spread
   double spread = MarketInfo(Symbol(), MODE_SPREAD);
   //MessageBox(DoubleToStr(spread,1), "Spread", NULL);
   
   // generate time string
   string time_string = TimeYear(TimeLocal()) + "." + TimeMonth(TimeLocal()) + "." + TimeDay(TimeLocal()) + "." + TimeHour(TimeLocal()) + "." + TimeMinute(TimeLocal()) + "." + Seconds();
   //MessageBox(time_string, "timestring");
   
   // concat upload information
   string upload_information = Symbol() + ";" + time_string + ";" + DoubleToStr(Ask, 5) + ";" + DoubleToStr(Bid, 5) + ";" + DoubleToStr(spread, 1);
   
   // save data to file
   int file_handle = FileOpen("upload.txt", FILE_WRITE);
   if(file_handle < 1) {
      Print("cant open file file. error: ", GetLastError());
   } else {
      FileWrite(file_handle, upload_information);
      //Comment(upload_information);
   }
   FileClose(file_handle);
   
   return(0);
}
//+------------------------------------------------------------------+