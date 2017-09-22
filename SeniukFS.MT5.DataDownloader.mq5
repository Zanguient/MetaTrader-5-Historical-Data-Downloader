//+------------------------------------------------------------------+
//|                                             DataAquisitionV1.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- show the window of input parameters when launching the script
#property script_show_inputs

#define TIMEOUT 300000
//--- parameters for receiving data from the terminal
//input string          InpSymbolName="PETR4";            // asset code
input ENUM_TIMEFRAMES InpSymbolPeriod=PERIOD_D1;        // timeframe
input datetime        InpDateStart=D'2007.06.01';       // data copying start date
//--- parameters for writing data to the file
//input string          InpFileName="PETR4.csv";         // file name
input string          InpSymbolNamesFile="MT5-XMGlobalBroker-Stocks.txt";
input string          InpDirectoryName="Stocks";  // directory name
//+------------------------------------------------------------------+
//| Struct for storing candlestick data                              |
//+------------------------------------------------------------------+
struct candlestick
{
   double open;   // open price
   double close;  // close price
   double high;   // high price
   double low;    // low price
   long vol;       // real volume
   datetime date; // datetime
};
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   //datetime dateFinish=TimeCurrent();
   datetime dateFinish=D'2017.09.08';
   string symbolName;
   int symNamesFile = FileOpen(InpSymbolNamesFile,FILE_READ|FILE_COMMON|FILE_ANSI);
   if(symNamesFile != INVALID_HANDLE)
   {
      do
      {
         int size;
         uint startTime, timeElapsed = 0;
         datetime timeBuff[];
         double openBuff[];
         double closeBuff[];
         double highBuff[];
         double lowBuff[];
         long volBuff[];
         candlestick candBuff[];
         ZeroMemory(timeBuff);
         ZeroMemory(openBuff);
         ZeroMemory(closeBuff);
         ZeroMemory(highBuff);
         ZeroMemory(lowBuff);
         ZeroMemory(volBuff);
         ZeroMemory(candBuff);
         symbolName = FileReadString(symNamesFile);
         if(StringLen(symbolName) != 0)
         {
            string fileName = StringFormat("%s.csv",symbolName);
//--- reset the error value
            ResetLastError();
//--- receive the time of the arrival of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyTime = CopyTime(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,timeBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("Time buffer size: %d",ArraySize(timeBuff));
               copyTime = CopyTime(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,timeBuff);
               Sleep(500);
            }
            while(copyTime == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy time values of %s. Error code = %d",symbolName,GetLastError());
            }
//--- receive high prices of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyHigh = CopyHigh(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,highBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("High buffer size: %d",ArraySize(highBuff));
               copyHigh = CopyHigh(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,highBuff);
               Sleep(500);
            }
            while(copyHigh == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy values of high prices. Error code = %d",GetLastError());
            }
//--- receive low prices of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyLow = CopyLow(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,lowBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("Low buffer size: %d",ArraySize(lowBuff));
               copyLow = CopyLow(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,lowBuff);
               Sleep(500);
            }
            while(copyLow == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy values of low prices. Error code = %d",GetLastError());
            }
//--- receive open prices of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyOpen = CopyOpen(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,openBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("Open buffer size: %d",ArraySize(openBuff));
               copyOpen = CopyOpen(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,openBuff);
               Sleep(500);
            }
            while(copyOpen == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy values of open prices. Error code = %d",GetLastError());
            }
//--- receive close prices of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyClose = CopyClose(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,closeBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("Close buffer size: %d",ArraySize(closeBuff));
               copyClose = CopyClose(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,closeBuff);
               Sleep(500);
            }
            while(copyClose == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy values of close prices. Error code = %d",GetLastError());
            }
//--- receive real volumes of the bars from the range
            startTime = GetTickCount();
            Print("Fetching data...");
            int copyRealVolume = CopyRealVolume(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,volBuff);
            do
            {
               timeElapsed = GetTickCount() - startTime;
               PrintFormat("Volume buffer size: %d",ArraySize(volBuff));
               copyRealVolume = CopyRealVolume(symbolName,InpSymbolPeriod,InpDateStart,dateFinish,volBuff);
               Sleep(500);
            }
            while(copyRealVolume == -1 && timeElapsed < TIMEOUT);
            if(timeElapsed >= TIMEOUT)
            {
               PrintFormat("Failed to copy values of close prices. Error code = %d",GetLastError());
            }
//--- define dimension of the arrays
            size=ArraySize(closeBuff);
//--- save all data in the structure array
            ArrayResize(candBuff,size);
            for(int i=0; i<size; i++)
            {
               candBuff[i].open=openBuff[i];
               candBuff[i].close=closeBuff[i];
               candBuff[i].high=highBuff[i];
               candBuff[i].low=lowBuff[i];
               candBuff[i].vol=volBuff[i];
               candBuff[i].date=timeBuff[i];
            }
//--- open the file for writing the structure array to the file (if the file is absent, it
//--- will be created automatically)
            ResetLastError();
            int fileHandle = FileOpen(InpDirectoryName+"\\"+fileName,FILE_WRITE|FILE_COMMON);
            if(fileHandle!=INVALID_HANDLE)
            {
               PrintFormat("File %s is open for writing...",fileName);
               PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_COMMONDATA_PATH));
               //--- prepare the couter of the number of bytes
               uint counter=0;
               //--- write header at the first line of the file
               counter+=FileWriteString(fileHandle, "DATA,ABERTURA,FECHAMENTO,ALTA,BAIXA,VOLUME\r\n");
               //--- write array values in the loop
               for(int i=0; i<size; i++)
               {
                  counter+=FileWriteString(fileHandle,StringFormat("%s,", TimeToString(candBuff[i].date,TIME_DATE)));
                  counter+=FileWriteString(fileHandle,StringFormat("%.2f,", candBuff[i].open));
                  counter+=FileWriteString(fileHandle,StringFormat("%.2f,", candBuff[i].close));
                  counter+=FileWriteString(fileHandle,StringFormat("%.2f,", candBuff[i].high));
                  counter+=FileWriteString(fileHandle,StringFormat("%.2f,", candBuff[i].low));
                  counter+=FileWriteString(fileHandle,StringFormat("%d\r\n", candBuff[i].vol)); 
               }
               PrintFormat("%d bytes of information is written to file %s.",counter,fileName);
               //--- close the file
               FileClose(fileHandle);
               PrintFormat("Data is written, file %s is closed.",fileName);
               Sleep(500);
            }
            else
            {
               PrintFormat("Failed to open file %s, Error code = %d",fileName,GetLastError());
            }
         }
      }
      while(StringLen(symbolName) != 0); // DO line 48
   }
   else
   {
      PrintFormat("Failed to open file %s, Error code = %d",InpSymbolNamesFile,GetLastError());
   }
      FileClose(symNamesFile);
}
//+------------------------------------------------------------------+
