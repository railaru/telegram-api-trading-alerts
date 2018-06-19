//+------------------------------------------------------------------+
//|                                                       HVF EA.mq4 |
//|                                   Copyright 2018, Rutenis Raila. |
//|                                     https://www.rutenisraila.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Rutenis Raila."
#property link      "https://www.rutenisraila.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   DetermineTrend();
   HvfFinder();

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   DeleteAllObjects();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   DetermineTrend();
   HvfFinder();

   Comment( "TrendIsBullish: " + DoubleToStr(TrendIsBullish, 0));

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DeleteAllObjects section                                             |
//+------------------------------------------------------------------+
void DeleteAllObjects()
  {
//---
   
   ObjectDelete("Label1_Price" + UserDefiniedObjectName);
   ObjectDelete("Label2_Price" + UserDefiniedObjectName);
   ObjectDelete("Label3_Price" + UserDefiniedObjectName);
   ObjectDelete("Label4_Price" + UserDefiniedObjectName);
   ObjectDelete("Label5_Price" + UserDefiniedObjectName);
   ObjectDelete("Label6_Price" + UserDefiniedObjectName);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Trend determination section                                     |
//+------------------------------------------------------------------+
enum Trend_Determination_enumeration
{
  Trend_Determination_1          = 1,  // Bullish
  Trend_Determination_2          = 2,  // Bearish
  Trend_Determination_3          = 3,  // Use EA to determine
};

input Trend_Determination_enumeration  Trend_Determination = 3;

int MA_Period = 200; 
bool TrendIsBullish = true;

void DetermineTrend()
  {
//--- 

  if(Trend_Determination == 1) {TrendIsBullish = true;}
  if(Trend_Determination == 2) {TrendIsBullish = false;}
  if(Trend_Determination == 3)
    {
     if(Ask > iMA(Symbol(), 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE, 0)) // bullish
        {
           TrendIsBullish = true;
        }     
     if(Bid < iMA(Symbol(), 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE, 0)) // bearish
        {
           TrendIsBullish = false;
        }        
    }
           
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| HVF Finder function section                                      |
//+------------------------------------------------------------------+
#import "user32.dll"
   int MessageBoxA(int Ignore, string Caption, string Title, int Icon);
#import

extern color LabelPointColor = Gray;
extern string UserDefiniedObjectName;
extern int BarCheckLimit = 2190; 
datetime StartDate, EndDate;

int      Label1_Price_shift, Label2_Price_shift, Label3_Price_shift, Label4_Price_shift, Label5_Price_shift, Label6_Price_shift, oldTime;
double   Label1_Price, Label2_Price, Label3_Price, Label4_Price, Label5_Price, Label6_Price, IOpenWhenDrawingFirstHVF;
datetime Label1_Time, Label2_Time, Label3_Time, Label4_Time, Label5_Time, Label6_Time;
bool     Label1_IsInPlace = 0, Label2_IsInPlace = 0, Label3_IsInPlace = 0, Label4_IsInPlace = 0
         , Label5_IsInPlace = 0, Label6_IsInPlace = 0;

void HvfFinder()
  {
//--- 

   int CurrentDistance = 0; 
   int CheckStart      = 0;    

         if(ObjectGet("StartDate", OBJPROP_TIME1) > 0)
            {                 
               StartDate = ObjectGet("StartDate", OBJPROP_TIME1);
               CurrentDistance = iBarShift(Symbol(), 0, StartDate);                     
            }     

         if(ObjectGet("EndDate", OBJPROP_TIME1) > 0)
            {                 
               EndDate = ObjectGet("EndDate", OBJPROP_TIME1);
               CheckStart = iBarShift(Symbol(), 0, EndDate);                     
            }    

   if(CurrentDistance < BarCheckLimit)
     {
          
            
          if(TrendIsBullish == true)
               {

                 // reset Label Values /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                  
                    Label1_Price_shift = 0; Label2_Price_shift = 0; Label3_Price_shift = 0; Label4_Price_shift = 0; Label5_Price_shift = 0; Label6_Price_shift = 0;
                    Label1_Price = 0; Label2_Price = 0; Label3_Price = 0; Label4_Price = 0; Label5_Price = 0; Label6_Price = 0;
                    Label1_Time = 0; Label2_Time = 0; Label3_Time = 0; Label4_Time = 0; Label5_Time = 0; Label6_Time = 0;
                    Label1_IsInPlace = 0; Label2_IsInPlace = 0; Label3_IsInPlace = 0; Label4_IsInPlace = 0; Label5_IsInPlace = 0; Label6_IsInPlace = 0;

                 // Label 1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   Label1_Price_shift = iHighest(Symbol(), 0, MODE_HIGH, CurrentDistance, CheckStart);
                   Label1_Price = iHigh(Symbol(), 0, Label1_Price_shift);
                   Label1_Time = iTime(Symbol(), 0, Label1_Price_shift);
                   
                   Label1_IsInPlace = true;                 

                 // Label 2 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
                 
                   Label2_Price_shift = iLowest(Symbol(), 0, MODE_LOW, Label1_Price_shift, CheckStart);
                   Label2_Price = iLow(Symbol(), 0, Label2_Price_shift);
                   Label2_Time = iTime(Symbol(), 0, Label2_Price_shift);

                   if(Label2_Price < Label1_Price)
                   if(Label1_Time < Label2_Time)
                    {
                                  
                     Label2_IsInPlace = true; 
                    }

                   if(Label2_Price > Label1_Price) {Print("Label 2 is not in place on a bullish HVF on: " + Symbol() + ", because Label2_Price > Label1_Price");}                 
                   if(Label1_Time > Label2_Time) {Print("Label 2 is not in place on a bullish HVF on: " + Symbol() + ", because Label1_Time > Label2_Time");}    

                 // Label 3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label2_IsInPlace == true)
                    {
                     Label3_Price_shift = iHighest(Symbol(), 0, MODE_HIGH, Label2_Price_shift, CheckStart);
                     Label3_Price = iHigh(Symbol(), 0, Label3_Price_shift);
                     Label3_Time = iTime(Symbol(), 0, Label3_Price_shift);

                     if(Label3_Price > Label2_Price)
                     if(Label2_Time < Label3_Time)
                      {

                       Label3_IsInPlace = true;                        
                      }
                     if(Label3_Price < Label2_Price) {Print("Label 3 is not in place on a bullish HVF on: " + Symbol() + ", because Label3_Price < Label2_Price");}   
                     if(Label2_Time > Label3_Time) {Print("Label 3 is not in place on a bullish HVF on: " + Symbol() + ", because Label2_Time > Label3_Time");}         
                    }

                 // Label 4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

                   if(Label3_IsInPlace == true)
                    {
                     Label4_Price_shift = iLowest(Symbol(), 0, MODE_LOW, Label3_Price_shift, CheckStart);
                     Label4_Price = iLow(Symbol(), 0, Label4_Price_shift);
                     Label4_Time = iTime(Symbol(), 0, Label4_Price_shift);

                     if(Label4_Price < Label3_Price)
                     if(Label3_Time < Label4_Time)
                      {   
                     
                       Label4_IsInPlace = true;
                      }
                     if(Label4_Price > Label3_Price) {Print("Label 4 is not in place on a bullish HVF on: " + Symbol() + ", because Label4_Price > Label3_Price");}   
                     if(Label3_Time > Label4_Time) {Print("Label 4 is not in place on a bullish HVF on: " + Symbol() + ", because Label3_Time > Label4_Time");}        
                    }
                                 
                 // Label 5 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label4_IsInPlace == true)
                    {
                     Label5_Price_shift = iHighest(Symbol(), 0, MODE_HIGH, Label4_Price_shift, CheckStart);
                     Label5_Price = iHigh(Symbol(), 0, Label5_Price_shift);
                     Label5_Time = iTime(Symbol(), 0, Label5_Price_shift);

                     if(Label4_Price < Label5_Price)
                     if(Label5_Time > Label4_Time)
                      {
                          
                       Label5_IsInPlace = true;
                      }
                     if(Label4_Price > Label5_Price) {Print("Label 5 is not in place on a bullish HVF on: " + Symbol() + ", because Label4_Price > Label5_Price");}   
                     if(Label5_Time < Label4_Time) {Print("Label 5 is not in place on a bullish HVF on: " + Symbol() + ", because Label5_Time < Label4_Time");}                    
                    }  

                 // Label 6 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              
                   if(Label5_IsInPlace == true)
                    {
                     Label6_Price_shift = iLowest(Symbol(), 0, MODE_LOW, Label5_Price_shift, CheckStart);
                     Label6_Price = iLow(Symbol(), 0, Label6_Price_shift);
                     Label6_Time = iTime(Symbol(), 0, Label6_Price_shift);

                     if(Label6_Price < Label5_Price)
                     if(Label6_Time > Label5_Time)
                      {
 
                       Label6_IsInPlace = true;                       
                      }
                     if(Label6_Price > Label5_Price) {Print("Label 6 is not in place on a bullish HVF on: " + Symbol() + ", because Label6_Price > Label5_Price");}   
                     if(Label6_Time < Label5_Time) {Print("Label 6 is not in place on a bullish HVF on: " + Symbol() + ", because Label6_Time < Label5_Time");}     

                     if(Label6_IsInPlace == false)
                      {
                       Label6_Price = iLow(Symbol(), 0, 0);
                       Label6_Time = iTime(Symbol(), 0, 0);    
                       Print("Using the Low of the current bar for Label 6 on: " + Symbol() + ", ");                        
                      }
                
                    } // end of if(Label5_IsInPlace == true)

                 // Create Chart Objects //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label1_IsInPlace == true)
                   if(Label2_IsInPlace == true)
                   if(Label3_IsInPlace == true)
                   if(Label4_IsInPlace == true)
                   if(Label5_IsInPlace == true)
                   if(Label6_IsInPlace == true)
                    {

                      if(HVF_is_Valid() == true)
                        {

                         // Label1  
                           ObjectDelete("1" + UserDefiniedObjectName);                
                           ObjectCreate("1" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);
                           ObjectSet("1" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);                    

                         // Label2
                           ObjectDelete("2" + UserDefiniedObjectName);                
                           ObjectCreate("2" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
                           ObjectSet("2" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor); 

                         // Label3
                           ObjectDelete("3" + UserDefiniedObjectName);                
                           ObjectCreate("3" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
                           ObjectSet("3" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);  
                         
                         // Label4
                           ObjectDelete("4" + UserDefiniedObjectName);                
                           ObjectCreate("4" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
                           ObjectSet("4" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);        

                         // Label5          
                           
                           ObjectDelete("5" + UserDefiniedObjectName);                
                           ObjectCreate("5" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
                           ObjectSet("5" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);         
                         // Label6

                           ObjectDelete("6" + UserDefiniedObjectName);                
                           ObjectCreate("6" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);
                           ObjectSet("6" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);  

                         // Create_Ghost_Drawings#

                           if(IsTesting() == false)
                            {                             
                              Create_Ghost_Drawings();
                              if(oldTime != Time[0] ) // first tick of the new bar found
                                {
                                  SendTelegramMessages();
                                  oldTime = Time[0];
                                }
                        
                            }

                           if(IsTesting() == true)
                            {
                              Create_Ghost_Drawings();
                              if(oldTime != Time[0] ) // first tick of the new bar found
                                {
                                  //MessageBoxA(0, "Bearish HVF detected", "Pausing the tester...", 64);
                                  oldTime = Time[0];

                                }
                            } 

                        } // end of if(HVF_is_Valid() == true)

                      if(HVF_is_Valid() == false)
                        {
                          Alert("Bullish HVF is not valid on: " + Symbol() + ", chart labels will not be created");   

                        } // end of if(HVF_is_Valid() == true)

                    } // end of if Labels are in place
                 
               } // end of if(TrendIsBullish == true)

          if(TrendIsBullish == false)
               {

                 // reset Label Values /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                  
                    Label1_Price_shift = 0; Label2_Price_shift = 0; Label3_Price_shift = 0; Label4_Price_shift = 0; Label5_Price_shift = 0; Label6_Price_shift = 0;
                    Label1_Price = 0; Label2_Price = 0; Label3_Price = 0; Label4_Price = 0; Label5_Price = 0; Label6_Price = 0;
                    Label1_Time = 0; Label2_Time = 0; Label3_Time = 0; Label4_Time = 0; Label5_Time = 0; Label6_Time = 0;
                    Label1_IsInPlace = 0; Label2_IsInPlace = 0; Label3_IsInPlace = 0; Label4_IsInPlace = 0; Label5_IsInPlace = 0; Label6_IsInPlace = 0;

                 // Label 1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   Label1_Price_shift = iLowest(Symbol(), 0, MODE_LOW, CurrentDistance, CheckStart);
                   Label1_Price = iLow(Symbol(), 0, Label1_Price_shift);
                   Label1_Time = iTime(Symbol(), 0, Label1_Price_shift);
                   
                   Label1_IsInPlace = true;                 

                 // Label 2 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
                 
                   Label2_Price_shift = iHighest(Symbol(), 0, MODE_HIGH, Label1_Price_shift, CheckStart);
                   Label2_Price = iHigh(Symbol(), 0, Label2_Price_shift);
                   Label2_Time = iTime(Symbol(), 0, Label2_Price_shift);

                   if(Label2_Price > Label1_Price)
                   if(Label1_Time < Label2_Time)
                    {
                                  
                     Label2_IsInPlace = true; 
                    }

                   if(Label2_Price < Label1_Price) {Print("Label 2 is not in place on a bearish HVF on: " + Symbol() + ", because Label2_Price < Label1_Price");}                 
                   if(Label1_Time > Label2_Time) {Print("Label 2 is not in place on a bearish HVF on: " + Symbol() + ", because Label1_Time > Label2_Time");}    

                 // Label 3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label2_IsInPlace == true)
                    {
                     Label3_Price_shift = iLowest(Symbol(), 0, MODE_LOW, Label2_Price_shift, CheckStart);
                     Label3_Price = iLow(Symbol(), 0, Label3_Price_shift);
                     Label3_Time = iTime(Symbol(), 0, Label3_Price_shift);

                     if(Label3_Price < Label2_Price)
                     if(Label2_Time < Label3_Time)
                      {

                       Label3_IsInPlace = true;                        
                      }
                     if(Label3_Price > Label2_Price) {Print("Label 3 is not in place on a bearish HVF on: " + Symbol() + ", because Label3_Price > Label2_Price");}   
                     if(Label2_Time > Label3_Time) {Print("Label 3 is not in place on a bearish HVF on: " + Symbol() + ", because Label2_Time > Label3_Time");}         
                    }

                 // Label 4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

                   if(Label3_IsInPlace == true)
                    {
                     Label4_Price_shift = iHighest(Symbol(), 0, MODE_LOW, Label3_Price_shift, CheckStart);
                     Label4_Price = iHigh(Symbol(), 0, Label4_Price_shift);
                     Label4_Time = iTime(Symbol(), 0, Label4_Price_shift);

                     if(Label4_Price > Label3_Price)
                     if(Label3_Time < Label4_Time)
                      {   
                     
                       Label4_IsInPlace = true;
                      }
                     if(Label4_Price < Label3_Price) {Print("Label 4 is not in place on a bearish HVF on: " + Symbol() + ", because Label4_Price < Label3_Price");}   
                     if(Label3_Time > Label4_Time) {Print("Label 4 is not in place on a bearish HVF on: " + Symbol() + ", because Label3_Time > Label4_Time");}        
                    }
                                 
                 // Label 5 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label4_IsInPlace == true)
                    {
                     Label5_Price_shift = iLowest(Symbol(), 0, MODE_LOW, Label4_Price_shift, CheckStart);
                     Label5_Price = iLow(Symbol(), 0, Label5_Price_shift);
                     Label5_Time = iTime(Symbol(), 0, Label5_Price_shift);

                     if(Label4_Price > Label5_Price)
                     if(Label5_Time > Label4_Time)
                      {
                          
                       Label5_IsInPlace = true;
                      }
                     if(Label4_Price < Label5_Price) {Print("Label 5 is not in place on a bearish HVF on: " + Symbol() + ", because Label4_Price < Label5_Price");}   
                     if(Label5_Time < Label4_Time) {Print("Label 5 is not in place on a bearish HVF on: " + Symbol() + ", because Label5_Time < Label4_Time");}                    
                    }  

                 // Label 6 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              
                   if(Label5_IsInPlace == true)
                    {
                     Label6_Price_shift = iHighest(Symbol(), 0, MODE_HIGH, Label5_Price_shift, CheckStart);
                     Label6_Price = iHigh(Symbol(), 0, Label6_Price_shift);
                     Label6_Time = iTime(Symbol(), 0, Label6_Price_shift);

                     if(Label6_Price > Label5_Price)
                     if(Label6_Time > Label5_Time)
                      {
 
                       Label6_IsInPlace = true;                       
                      }
                     if(Label6_Price < Label5_Price) {Print("Label 6 is not in place on a bearish HVF on: " + Symbol() + ", because Label6_Price < Label5_Price");}   
                     if(Label6_Time < Label5_Time) {Print("Label 6 is not in place on a bearish HVF on: " + Symbol() + ", because Label6_Time < Label5_Time");}     

                     if(Label6_IsInPlace == false)
                      {
                       Label6_Price = iHigh(Symbol(), 0, 0);
                       Label6_Time = iTime(Symbol(), 0, 0);    
                       Print("Using the High of the current bar for Label 6 on: " + Symbol() + ", ");                        
                      }
                
                    } // end of if(Label5_IsInPlace == true)

                 // Create Chart Objects //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                   if(Label1_IsInPlace == true)
                   if(Label2_IsInPlace == true)
                   if(Label3_IsInPlace == true)
                   if(Label4_IsInPlace == true)
                   if(Label5_IsInPlace == true)
                   if(Label6_IsInPlace == true)
                    {

                      if(HVF_is_Valid() == true)
                        {

                         // Label1  
                           ObjectDelete("1" + UserDefiniedObjectName);                
                           ObjectCreate("1" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);
                           ObjectSet("1" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);                    

                         // Label2
                           ObjectDelete("2" + UserDefiniedObjectName);                
                           ObjectCreate("2" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
                           ObjectSet("2" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor); 

                         // Label3
                           ObjectDelete("3" + UserDefiniedObjectName);                
                           ObjectCreate("3" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
                           ObjectSet("3" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);  
                         
                         // Label4
                           ObjectDelete("4" + UserDefiniedObjectName);                
                           ObjectCreate("4" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
                           ObjectSet("4" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);        

                         // Label5          
                           
                           ObjectDelete("5" + UserDefiniedObjectName);                
                           ObjectCreate("5" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
                           ObjectSet("5" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);         
                         // Label6

                           ObjectDelete("6" + UserDefiniedObjectName);                
                           ObjectCreate("6" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);
                           ObjectSet("6" + UserDefiniedObjectName, OBJPROP_COLOR, LabelPointColor);  

                         // Create_Ghost_Drawings#

                           if(IsTesting() == false)
                            {                             
                              Create_Ghost_Drawings();
                              if(oldTime != Time[0] ) // first tick of the new bar found
                                {
                                  SendTelegramMessages();
                                  oldTime = Time[0];
                                }

                            }

                           if(IsTesting() == true)
                            {
                              Create_Ghost_Drawings();
                              if(oldTime != Time[0] ) // first tick of the new bar found
                                {
                                  //MessageBoxA(0, "Bearish HVF detected", "Pausing the tester...", 64);
                                  oldTime = Time[0];
                                }
                            } 
                            
                        } // end of if(HVF_is_Valid() == true)

                      if(HVF_is_Valid() == false)
                        {
                          Alert("Bullish HVF is not valid on: " + Symbol() + ", chart labels will not be created");   

                        } // end of if(HVF_is_Valid() == true)

                    } // end of if Labels are in place
                 
               } // end of if(TrendIsBullish == false)


         } // end of if(CurrentDistance < BarCheckLimit)
     

  } // end of void HvfFinder()
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| HVF_is_Valid funtion section                                     |
//+------------------------------------------------------------------+

extern double UserDefiniedRRR = 3;
extern bool UseCondition1 = true;
extern bool UseCondition2 = false;
extern bool UseCondition3 = false;

bool HVF_is_Valid()
  {
   
   double HVF_Axis, Target3, SL_InPips, TP_InPips, RRR;
   HVF_Axis  = (Label5_Price + Label6_Price) / 2;
  
   if(TrendIsBullish == true)
      {

       // condition 1: RRR presented in the HVF setup must be equal or higher than the one determined by user
         Target3 = (Label1_Price - Label2_Price) + HVF_Axis;
         SL_InPips = Label5_Price - Label6_Price;
         TP_InPips = Target3 - Label5_Price;
         RRR       = TP_InPips / SL_InPips;    

       // condition 2: the distance between EP and SL must be at least 3x the spread
         double Distance_Between_EP_SL = Label5_Price - Label6_Price;
         Distance_Between_EP_SL = Distance_Between_EP_SL * Point();

         double Spread = Ask - Bid;
         Spread = Spread * Point();

       // condition 3: the HVF axis must be in between Labels 5 and 6 when calculated using the values of all 6 labels
         double HVF_Axis_6_Labels = (Label1_Price + Label2_Price + Label3_Price + Label4_Price + Label5_Price + Label6_Price) / 6;

          if(RRR >= UserDefiniedRRR) // condition 1
          if(Distance_Between_EP_SL >= Spread * 3) // condition 2 
          if(HVF_Axis_6_Labels > Label6_Price && HVF_Axis_6_Labels < Label5_Price) // Condition 3
            {
              return(true);
            }
          if(RRR < UserDefiniedRRR) // condition 1
          if(Distance_Between_EP_SL < Spread * 3) // condition 2
          if(HVF_Axis_6_Labels < Label6_Price || HVF_Axis_6_Labels > Label5_Price) // Condition 3 
            {
              return(false);
            }  
      }

   if(TrendIsBullish == false)
      {

       // condition 1: RRR presented in the HVF setup must be equal or higher than the one determined by user 
         Target3   = HVF_Axis - (Label2_Price - Label1_Price);
         SL_InPips = Label5_Price - Label6_Price;
         TP_InPips = Target3 - Label5_Price;
         RRR       = TP_InPips / SL_InPips;

       // condition 2: the distance between EP and SL must be at least 3x the spread
         double Distance_Between_EP_SL = Label6_Price - Label5_Price;
         Distance_Between_EP_SL = Distance_Between_EP_SL * Point();

         double Spread = Ask - Bid;
         Spread = Spread * Point();

       // condition 3: the HVF axis must be in between Labels 5 and 6 when calculated using the values of all 6 labels
         double HVF_Axis_6_Labels = (Label1_Price + Label2_Price + Label3_Price + Label4_Price + Label5_Price + Label6_Price) / 6;

          if(RRR >= UserDefiniedRRR) // condition 1
          if(Distance_Between_EP_SL >= Spread * 3) // condition 2 
          if(HVF_Axis_6_Labels < Label6_Price && HVF_Axis_6_Labels > Label5_Price) // condition 3
            {
              return(true);
            }
          if(RRR < UserDefiniedRRR) // condition 1
          if(Distance_Between_EP_SL < Spread * 3) // condition 2 
          if(HVF_Axis_6_Labels > Label6_Price && HVF_Axis_6_Labels < Label5_Price) // condition 3
            {
              return(false);
            }             
      }

      return(false);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Create_Ghost_Drawings section                                    |
//+------------------------------------------------------------------+
void Create_Ghost_Drawings()
  {


    // Set ghost name /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      string GhostName = "_" + TimeToStr(TimeCurrent(), TIME_DATE);

    // end of Set ghost name /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      double HVF_Axis;
      double Target3;
      double Target2;
      double Target1;


        //HVF_Axis = (Label1_Price + Label2_Price + Label3_Price + Label4_Price + Label5_Price + Label6_Price)/6;
          HVF_Axis = (HVF_Axis = Label5_Price + Label6_Price) / 2;
          ObjectDelete("HVF_Axis" + GhostName);

          ObjectCreate("HVF_Axis" + GhostName,OBJ_TREND, 0, Label1_Time, HVF_Axis, Label6_Time + (Label6_Time - Label5_Time), HVF_Axis, 0, 0);
          ObjectSet("HVF_Axis" + GhostName, OBJPROP_COLOR, clrDarkGoldenrod);
          ObjectSet("HVF_Axis" + GhostName, OBJPROP_RAY, 0);
          ObjectSet("HVF_Axis" + GhostName, OBJPROP_HIDDEN, true);


          if(TrendIsBullish == true)
            {

             // Label1  
               ObjectDelete("1" + GhostName);                
               ObjectCreate("1" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);
               ObjectSet("1" + GhostName, OBJPROP_COLOR, LabelPointColor);                    

             // Label2
               ObjectDelete("2" + GhostName);                
               ObjectCreate("2" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
               ObjectSet("2" + GhostName, OBJPROP_COLOR, LabelPointColor); 

             // Label3
               ObjectDelete("3" + GhostName);                
               ObjectCreate("3" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
               ObjectSet("3" + GhostName, OBJPROP_COLOR, LabelPointColor);  
             
             // Label4
               ObjectDelete("4" + GhostName);                
               ObjectCreate("4" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
               ObjectSet("4" + GhostName, OBJPROP_COLOR, LabelPointColor);        

             // Label5          
               
               ObjectDelete("5" + GhostName);                
               ObjectCreate("5" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
               ObjectSet("5" + GhostName, OBJPROP_COLOR, LabelPointColor);         
             // Label6

               ObjectDelete("6" + GhostName);                
               ObjectCreate("6" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);
               ObjectSet("6" + GhostName, OBJPROP_COLOR, LabelPointColor); 

              Target3 = (Label1_Price - Label2_Price) + HVF_Axis;

              ObjectDelete("Target3" + GhostName);
              ObjectCreate("Target3" + GhostName,OBJ_TREND, 0, Label6_Time, Target3, (Label6_Time - Label1_Time) + Label6_Time, Target3, 0, 0);
              ObjectSet("Target3" + GhostName, OBJPROP_COLOR, clrRoyalBlue);
              ObjectSet("Target3" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target3" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target3" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target3" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target3" + GhostName, OBJPROP_WIDTH, 2);

              Target2 = (Label3_Price - Label4_Price) + HVF_Axis;

              ObjectDelete("Target2" + GhostName);
              ObjectCreate("Target2" + GhostName,OBJ_TREND, 0, Label6_Time, Target2, (Label6_Time - Label1_Time) + Label6_Time, Target2, 0, 0);
              ObjectSet("Target2" + GhostName, OBJPROP_COLOR, clrCornflowerBlue);
              ObjectSet("Target2" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target2" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target2" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target2" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target2" + GhostName, OBJPROP_WIDTH, 1.5);

              Target1 = (Label5_Price - Label6_Price) + HVF_Axis;

              ObjectDelete("Target1" + GhostName);
              ObjectCreate("Target1" + GhostName,OBJ_TREND, 0, Label6_Time, Target1, (Label6_Time - Label1_Time) + Label6_Time, Target1, 0, 0);
              ObjectSet("Target1" + GhostName, OBJPROP_COLOR, clrPowderBlue);
              ObjectSet("Target1" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target1" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target1" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target1" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target1" + GhostName, OBJPROP_WIDTH, 1);


              ObjectDelete("1_3" + GhostName);
              ObjectCreate("1_3" + GhostName, OBJ_TREND, 0, Label1_Time, Label1_Price, Label3_Time, Label3_Price, 0, 0);
              ObjectSet("1_3" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("1_3" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("1_3" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("1_3" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("1_3" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("1_3" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("2_4" + GhostName);
              ObjectCreate("2_4" + GhostName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label4_Time, Label4_Price, 0, 0);
              ObjectSet("2_4" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("2_4" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("2_4" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("2_4" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("2_4" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("2_4" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("3_5" + GhostName);
              ObjectCreate("3_5" + GhostName, OBJ_TREND, 0, Label3_Time, Label3_Price, Label5_Time, Label5_Price, 0, 0);
              ObjectSet("3_5" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("3_5" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("3_5" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("3_5" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("3_5" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("3_5" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("4_6" + GhostName);
              ObjectCreate("4_6" + GhostName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label6_Time, Label6_Price, 0, 0);
              ObjectSet("4_6" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("4_6" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("4_6" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("4_6" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("4_6" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("4_6" + GhostName, OBJPROP_SELECTED, false);

     
              ObjectDelete("EntryPoint" + GhostName);
              ObjectCreate("EntryPoint" + GhostName, OBJ_TREND, 0, Label5_Time, Label5_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label5_Price, 0, 0);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_COLOR, clrDarkGreen);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_RAY, 0);


              ObjectDelete("StopLoss" + GhostName);
              ObjectCreate("StopLoss" + GhostName, OBJ_TREND, 0, Label6_Time, Label6_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label6_Price, 0, 0);
              ObjectSet("StopLoss" + GhostName, OBJPROP_COLOR, Red);
              ObjectSet("StopLoss" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("StopLoss" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("StopLoss" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("StopLoss" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("StopLoss" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("StopLoss" + GhostName, OBJPROP_RAY, 0);


              datetime Target1TimeStop;
              datetime Target2TimeStop;
              datetime Target3TimeStop;
                
              Target1TimeStop = (Label6_Time - Label5_Time) + Label6_Time;
              Target2TimeStop = (Label6_Time - Label3_Time) + Label6_Time;
              Target3TimeStop = (Label6_Time - Label1_Time) + Label6_Time;

              // target 1

              ObjectDelete("Target1TimeStop" + GhostName);
              ObjectCreate("Target1TimeStop" + GhostName, OBJ_TREND, 0, Target1TimeStop, Label5_Price, Target1TimeStop, Target1, 0, 0);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_COLOR, clrPowderBlue);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_SELECTED, false);

              // target 2 

              ObjectDelete("Target2TimeStop" + GhostName);
              ObjectCreate("Target2TimeStop" + GhostName, OBJ_TREND, 0, Target2TimeStop, Target1, Target2TimeStop, Target2, 0, 0);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_COLOR, clrCornflowerBlue);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_WIDTH, 1.5);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_SELECTED, false);

              // target 3 

              ObjectDelete("Target3TimeStop" + GhostName);
              ObjectCreate("Target3TimeStop" + GhostName, OBJ_TREND, 0, Target3TimeStop, Target2, Target3TimeStop, Target3, 0, 0);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_COLOR, clrRoyalBlue);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_WIDTH, 2);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_SELECTED, false);  

            } // end of if(TrendIsBullish == true)

          if(TrendIsBullish == false)
            {

             // Label1  
               ObjectDelete("1" + GhostName);                
               ObjectCreate("1" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);
               ObjectSet("1" + GhostName, OBJPROP_COLOR, LabelPointColor);                    

             // Label2
               ObjectDelete("2" + GhostName);                
               ObjectCreate("2" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
               ObjectSet("2" + GhostName, OBJPROP_COLOR, LabelPointColor); 

             // Label3
               ObjectDelete("3" + GhostName);                
               ObjectCreate("3" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
               ObjectSet("3" + GhostName, OBJPROP_COLOR, LabelPointColor);  
             
             // Label4
               ObjectDelete("4" + GhostName);                
               ObjectCreate("4" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
               ObjectSet("4" + GhostName, OBJPROP_COLOR, LabelPointColor);        

             // Label5          
               
               ObjectDelete("5" + GhostName);                
               ObjectCreate("5" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
               ObjectSet("5" + GhostName, OBJPROP_COLOR, LabelPointColor);         
             // Label6

               ObjectDelete("6" + GhostName);                
               ObjectCreate("6" + GhostName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);
               ObjectSet("6" + GhostName, OBJPROP_COLOR, LabelPointColor); 

              Target3 = HVF_Axis - (Label2_Price - Label1_Price);

              ObjectDelete("Target3" + GhostName);
              ObjectCreate("Target3" + GhostName,OBJ_TREND, 0, Label6_Time, Target3, (Label6_Time - Label1_Time) + Label6_Time, Target3, 0, 0);
              ObjectSet("Target3" + GhostName, OBJPROP_COLOR, clrRoyalBlue);
              ObjectSet("Target3" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target3" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target3" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target3" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target3" + GhostName, OBJPROP_WIDTH, 2);

              Target2 = HVF_Axis - (Label4_Price - Label3_Price);

              ObjectDelete("Target2" + GhostName);
              ObjectCreate("Target2" + GhostName,OBJ_TREND, 0, Label6_Time, Target2, (Label6_Time - Label1_Time) + Label6_Time, Target2, 0, 0);
              ObjectSet("Target2" + GhostName, OBJPROP_COLOR, clrCornflowerBlue);
              ObjectSet("Target2" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target2" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target2" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target2" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target2" + GhostName, OBJPROP_WIDTH, 1.5);

              Target1 = HVF_Axis - (Label6_Price - Label5_Price);

              ObjectDelete("Target1" + GhostName);
              ObjectCreate("Target1" + GhostName,OBJ_TREND, 0, Label6_Time, Target1, (Label6_Time - Label1_Time) + Label6_Time, Target1, 0, 0);
              ObjectSet("Target1" + GhostName, OBJPROP_COLOR, clrPowderBlue);
              ObjectSet("Target1" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target1" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target1" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target1" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("Target1" + GhostName, OBJPROP_WIDTH, 1);


              ObjectDelete("1_3" + GhostName);
              ObjectCreate("1_3" + GhostName, OBJ_TREND, 0, Label1_Time, Label1_Price, Label3_Time, Label3_Price, 0, 0);
              ObjectSet("1_3" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("1_3" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("1_3" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("1_3" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("1_3" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("1_3" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("2_4" + GhostName);
              ObjectCreate("2_4" + GhostName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label4_Time, Label4_Price, 0, 0);
              ObjectSet("2_4" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("2_4" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("2_4" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("2_4" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("2_4" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("2_4" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("3_5" + GhostName);
              ObjectCreate("3_5" + GhostName, OBJ_TREND, 0, Label3_Time, Label3_Price, Label5_Time, Label5_Price, 0, 0);
              ObjectSet("3_5" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("3_5" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("3_5" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("3_5" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("3_5" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("3_5" + GhostName, OBJPROP_SELECTED, false);


              ObjectDelete("4_6" + GhostName);
              ObjectCreate("4_6" + GhostName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label6_Time, Label6_Price, 0, 0);
              ObjectSet("4_6" + GhostName, OBJPROP_COLOR, clrGainsboro);
              ObjectSet("4_6" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("4_6" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("4_6" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("4_6" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("4_6" + GhostName, OBJPROP_SELECTED, false);

     
              ObjectDelete("EntryPoint" + GhostName);
              ObjectCreate("EntryPoint" + GhostName, OBJ_TREND, 0, Label5_Time, Label5_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label5_Price, 0, 0);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_COLOR, clrDarkGreen);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("EntryPoint" + GhostName, OBJPROP_RAY, 0);


              ObjectDelete("StopLoss" + GhostName);
              ObjectCreate("StopLoss" + GhostName, OBJ_TREND, 0, Label6_Time, Label6_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label6_Price, 0, 0);
              ObjectSet("StopLoss" + GhostName, OBJPROP_COLOR, Red);
              ObjectSet("StopLoss" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("StopLoss" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("StopLoss" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("StopLoss" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("StopLoss" + GhostName, OBJPROP_SELECTED, false);
              ObjectSet("StopLoss" + GhostName, OBJPROP_RAY, 0);


              datetime Target1TimeStop;
              datetime Target2TimeStop;
              datetime Target3TimeStop;
                
              Target1TimeStop = (Label6_Time - Label5_Time) + Label6_Time;
              Target2TimeStop = (Label6_Time - Label3_Time) + Label6_Time;
              Target3TimeStop = (Label6_Time - Label1_Time) + Label6_Time;

              // target 1

              ObjectDelete("Target1TimeStop" + GhostName);
              ObjectCreate("Target1TimeStop" + GhostName, OBJ_TREND, 0, Target1TimeStop, Label5_Price, Target1TimeStop, Target1, 0, 0);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_COLOR, clrPowderBlue);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_WIDTH, 1);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target1TimeStop" + GhostName, OBJPROP_SELECTED, false);

              // target 2 

              ObjectDelete("Target2TimeStop" + GhostName);
              ObjectCreate("Target2TimeStop" + GhostName, OBJ_TREND, 0, Target2TimeStop, Target1, Target2TimeStop, Target2, 0, 0);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_COLOR, clrCornflowerBlue);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_WIDTH, 1.5);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target2TimeStop" + GhostName, OBJPROP_SELECTED, false);

              // target 3 

              ObjectDelete("Target3TimeStop" + GhostName);
              ObjectCreate("Target3TimeStop" + GhostName, OBJ_TREND, 0, Target3TimeStop, Target2, Target3TimeStop, Target3, 0, 0);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_COLOR, clrRoyalBlue);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_WIDTH, 2);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_RAY, 0);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_HIDDEN, true);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_SELECTABLE, false);
              ObjectSet("Target3TimeStop" + GhostName, OBJPROP_SELECTED, false);  

            } // end of if(TrendIsBullish == true)
 

            

  } // end of Create_Ghost_Drawing

//+------------------------------------------------------------------+
//| SendTelegramMessages section                                     |
//+------------------------------------------------------------------+
void SendTelegramMessages()
  {
   
    if(TrendIsBullish == true)
      {
        tms_send(StringFormat("%s Bullish HVF detected ",Symbol()));
      }
    
    if(TrendIsBullish == false)
      {
        tms_send(StringFormat("%s Bearish HVF detected ",Symbol()));
      }

  } // end of SendTelegramMessages section

//+------------------------------------------------------------------+
//| tms_send section                                                 |
//+------------------------------------------------------------------+
datetime _tms_last_time_messaged;
bool tms_send(string message, string token="{530572534:e8776b5d}"){  // You can set token here for simply usage tms_send("you message");
   const string url = "https://tmsrv.pw/send/v1";   
   
   string response,headers; 
   int result;
   char post[],res[]; 
   
   if(IsTesting() || IsOptimization()) return true;
   if(_tms_last_time_messaged == Time[0]) return false; // do not send twice at the same candle;  

   string spost = StringFormat("message=%s&token=%s&code=MQL",message,token);
   

   ArrayResize(post,StringToCharArray(spost,post,0,WHOLE_ARRAY,CP_UTF8)-1);

   result = WebRequest("POST",url,"",NULL,3000,post,ArraySize(post),res,headers); 
   _tms_last_time_messaged = Time[0];
       
   if(result==-1) {  // WebRequest filed
         if(GetLastError() == 4060) {
            printf("tms_send() | Add the address %s in the list of allowed URLs on tab 'Expert Advisors'",url);
         } else {
            printf("tms_send() | webrequest filed - error № %i", GetLastError());
         }
         return false;
   } else { 
      response = CharArrayToString(res,0,WHOLE_ARRAY);
     
      if(StringFind(response,"\"ok\":true")==-1) { // check server response

         printf("tms_send() return an error - %s",response);
         return false;
      }
   }
  
  Sleep(1000); //to prevent sending more than 1 message per seccond
  return true;
}