//+------------------------------------------------------------------+
//|                                           HVF profit manager.mq4 |
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
   
   CreateChartObjects2();   
   FibonacciTrailingSL();

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
   //---   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   FibonacciTrailingSL();
   
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Fibonacci rays trailing SL module                                |
//+------------------------------------------------------------------+

double   AlertPrice1, EntryPrice, Interception;
datetime AlertTime1;
bool     Bullish_HVF = 1;
int      Order_Ticket;
int      Object_Width = 3;

void FibonacciTrailingSL()
  {

   //--- AlertPrice1; 
      if(ObjectGet("AP1_obj", OBJPROP_PRICE1) > 0)
         {  
            AlertPrice1 = ObjectGet("AP1_obj", OBJPROP_PRICE1);         
            ObjectSet("AP1_obj", OBJPROP_COLOR, clrPowderBlue);
            ObjectSet("AP1_obj", OBJPROP_WIDTH, Object_Width);
         }
         
      if(ObjectGet("AP1_obj", OBJPROP_PRICE1) == 0)      
         {
            Alert("AP1_obj is NOT yet created on " + Symbol());
         }
   //--- 

   //--- EntryPoint; 
      if(ObjectGet("EP_obj", OBJPROP_PRICE1) > 0)
         {  
            EntryPrice = ObjectGet("EP_obj", OBJPROP_PRICE1);         
            ObjectSet("EP_obj", OBJPROP_COLOR, Green);
            ObjectSet("EP_obj", OBJPROP_WIDTH, Object_Width);
         }
         
      if(ObjectGet("EP_obj", OBJPROP_PRICE1) == 0)      
         {
            Alert("EP_obj is NOT yet created on " + Symbol());
         }
   //--- 
   
   //---
      if(EntryPrice && AlertPrice1 > 0)
         {
            if(AlertPrice1 > EntryPrice)
               {
                  Bullish_HVF = true;            
               }
            if(AlertPrice1 < EntryPrice)
               {
                  Bullish_HVF = false;
               }               
         }
   //---      
   
   //--- AlertTime1;
      AlertTime1 = Time[0];
      ObjectDelete(0, "AT1_obj");
      ObjectCreate("AT1_obj", OBJ_VLINE, 0, AlertTime1, Bid); // draw vert line
      ObjectSet("AT1_obj", OBJPROP_COLOR, clrPowderBlue);
      ObjectSet("AT1_obj", OBJPROP_WIDTH, Object_Width);     
   //---   

   //--- trendline and current time interception section;        
   
      if(ObjectGet("trendline" + UserDefiniedObjectName, OBJPROP_PRICE1) > 0)
         {  
            int TrendlineShift = ObjectGetShiftByValue("AT1_obj", AlertTime1);     
            Interception = ObjectGetValueByShift("trendline" + UserDefiniedObjectName, TrendlineShift);
            
            ObjectDelete("Interception_obj");
            ObjectCreate(0, "Interception_obj", OBJ_HLINE, 0, 0, Interception, 0);
         }
 
      if(ObjectGet("trendline" + UserDefiniedObjectName, OBJPROP_PRICE1) == 0)      
         {
            Alert("trendline is NOT yet created on " + Symbol());
         }     
   //---  

   //--- break even section
      if(ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1) > 0)
         {  
          double Order_Ticket_obj_dbl = ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1);
          Order_Ticket_obj_dbl = NormalizeDouble(Order_Ticket_obj_dbl, 0);
          Order_Ticket = Order_Ticket_obj_dbl;
             
          if(OrderSelect(Order_Ticket, SELECT_BY_TICKET)==true)
          if(OrderSymbol() == Symbol())
             {
               if(Bullish_HVF == false && Ask < AlertPrice1)
                  {
                     bool OrderModfied = OrderModify(Order_Ticket, Ask, EntryPrice, OrderTakeProfit(), 0, 0);
                     
                        if(OrderModfied == true)
                           {
                              Alert("Order stop loss successfully modified on " + Symbol() + " and moved to the break even point");   
                           }
                        else if(!Interception == OrderStopLoss()) 
                           {
                             Alert("OrderModify returned the error of ",GetLastError(), " on ", Symbol() + " when trying to move stop loss to break even point");
                           }                        
                  }
   
               if(Bullish_HVF == true && Bid > AlertPrice1)
                  {
                     
                     bool OrderModfied = OrderModify(Order_Ticket, Bid, Interception, OrderTakeProfit(), 0, 0);
                     
                        if(OrderModfied == true)
                           {
                              Alert("Order stop loss successfully modified on " + Symbol() + " and moved to the break even point");   
                           }
                        else if(!Interception == OrderStopLoss()) 
                           {
                             Alert("OrderModify returned the error of ",GetLastError(), " on ", Symbol() + " when trying to move stop loss to break even point");
                           }                        
                  }              
             }
          else
             {
               Alert("OrderSelect returned the error of ",GetLastError(), " on ", Symbol(), " (break even point");
             }
         }
 
      if(ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1) == 0)      
         {
            Alert("Order_Ticket_obj is NOT yet created on " + Symbol());
         }     
   //---     
   //---  

   //--- trailing SL section

      if(ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1) > 0)
         {  
          double Order_Ticket_obj_dbl = ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1);
          Order_Ticket_obj_dbl = NormalizeDouble(Order_Ticket_obj_dbl, 0);
          Order_Ticket = Order_Ticket_obj_dbl;
             
          if(OrderSelect(Order_Ticket, SELECT_BY_TICKET)==true)
          if(OrderSymbol() == Symbol())
             {
               if(Bullish_HVF == false && Ask < AlertPrice1)
               if(Interception < EntryPrice)
                  {
                     bool OrderModfied = OrderModify(Order_Ticket, Ask, Interception, OrderTakeProfit(), 0, 0);
                     
                        if(OrderModfied == true)
                           {
                              Alert("Order stop loss successfully modified on " + Symbol());   
                           }
                        else if(!Interception == OrderStopLoss()) 
                           {
                             Alert("OrderModify returned the error of ",GetLastError(), " on ", Symbol());
                           }                        
                  }
   
               if(Bullish_HVF == true && Bid > AlertPrice1)
               if(Interception > EntryPrice)
                  {
                     bool OrderModfied = OrderModify(Order_Ticket, Bid, Interception, OrderTakeProfit(), 0, 0);
                     
                        if(OrderModfied == true)
                           {
                              Alert("Order stop loss successfully modified on " + Symbol());   
                           }
                        else if(!Interception == OrderStopLoss()) 
                           {
                             Alert("OrderModify returned the error of ", GetLastError(), " on ", Symbol());
                           }                        
                  }              
             }
          else
             {
               Alert("OrderSelect returned the error of ",GetLastError(), " on ", Symbol());
             }
         }
 
      if(ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1) == 0)      
         {
            Alert("Order_Ticket_obj is NOT yet created on " + Symbol());
         }     
   //---  
     
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| Delete all objects                                          |
//+------------------------------------------------------------------+
void DeleteAllObjects()
  {
//---
   ObjectDelete(0, "AP1_obj");
   ObjectDelete(0, "AT1_obj");
   ObjectDelete(0, "Order_Ticket_obj");
   ObjectDelete(0, "trendline");
   ObjectDelete(0, "EP_obj");
   
      
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Create chart objects                                          |
//+------------------------------------------------------------------+

extern string UserDefiniedObjectName;
double Target1_obj, Label5_Price_obj, Label6_Price_obj, Label4_Price_obj;
datetime Label4_Time_obj, Label5_Time_obj;

void CreateChartObjects2()
  {

   //--- EP_obj        
   if(ObjectGet("EP_obj", OBJPROP_PRICE1) == 0)
      {
        if(ObjectGet("5" + UserDefiniedObjectName, OBJPROP_PRICE1) > 0)
         {
            Label5_Price_obj = ObjectGet("5" + UserDefiniedObjectName, OBJPROP_PRICE1);
            ObjectCreate("EP_obj", OBJ_HLINE, 0, 0, Label5_Price_obj, 0, 0 ,0, 0);          
         }
        else 
         {
            Alert("EP_obj is NOT yet created on " + Symbol() + ", or the UserDefiniedObjectName was not specified properly");
         }        
      }   
   //--- 

   //--- Order_Ticket_obj
   if(ObjectGet("Order_Ticket_obj", OBJPROP_PRICE1) == 0)
      {
        ObjectCreate("Order_Ticket_obj", OBJ_HLINE, 0, 0, Ask, 0, 0 ,0, 0);     
      }  
   //--- AP1_obj       
   if(ObjectGet("AP1_obj", OBJPROP_PRICE1) == 0)
      {   
        if(ObjectGet("Target1" + UserDefiniedObjectName, OBJPROP_PRICE1) > 0)
         {
            Target1_obj = ObjectGet("Target1" + UserDefiniedObjectName, OBJPROP_PRICE1);
            ObjectCreate("AP1_obj", OBJ_HLINE, 0, 0, Target1_obj, 0, 0 , 0, 0);          
         }
        else 
         {
            Alert("Target1 is NOT yet created on " + Symbol() + ", or the UserDefiniedObjectName was not specified properly");
         }
      } 

          
   }    
  
//+------------------------------------------------------------------+

