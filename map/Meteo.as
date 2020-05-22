package map
{
   import engine.TimeValue;
   import engine.TimeValueItem;
   
   public class Meteo extends MeteoGenerator
   {
       
      
      public function Meteo()
      {
         super();
      }
      
      public function readDayTime(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:TimeValueItem = param1.addItem();
         _loc3_.time = startTime - startTime % dayCicleDelay;
         _loc3_.value = 0;
         if(serverId == 1)
         {
            _loc3_.time = _loc3_.time - 5400000;
         }
         while(_loc3_.time < endTime)
         {
            _loc2_ = _loc3_;
            _loc3_ = param1.addItem();
            _loc3_.time = _loc2_.time + dayCicleDelay;
            _loc3_.value = 1;
            _loc3_ = param1.addItem();
            _loc3_.time = _loc2_.time + dayCicleDelay + 1;
            _loc3_.value = 0;
         }
      }
      
      public function readCloud(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:* = new Tween();
         _loc3_.mode = 1;
         _loc3_.factor = 2;
         var _loc4_:int = 0;
         while(_loc4_ < cloudBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc4_ * pixelTime;
            _loc2_.value = _loc3_.generate((cloudBMD.getPixel(cloudBMD.width / 2,_loc4_) & 255) / 255);
            _loc4_++;
         }
      }
      
      public function readHumidity(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:int = 0;
         while(_loc3_ < humidityBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc3_ * pixelTime;
            _loc2_.value = (humidityBMD.getPixel(humidityBMD.width / 2,_loc3_) & 255) / 255;
            if(serverId == 2)
            {
               _loc2_.value = 0;
            }
            _loc3_++;
         }
      }
      
      public function readStormy(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:int = 0;
         while(_loc3_ < stormyBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc3_ * pixelTime;
            _loc2_.value = (stormyBMD.getPixel(stormyBMD.width / 2,_loc3_) & 255) / 255;
            if(serverId == 2)
            {
               _loc2_.value = 1;
            }
            _loc3_++;
         }
      }
      
      public function readFog(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:* = new Tween();
         _loc3_.mode = 1;
         _loc3_.factor = 3;
         var _loc4_:int = 0;
         while(_loc4_ < fogBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc4_ * pixelTime;
            _loc2_.value = _loc3_.generate((fogBMD.getPixel(fogBMD.width / 2,_loc4_) & 255) / 255);
            if(serverId == 2)
            {
               _loc2_.value = 0;
            }
            _loc4_++;
         }
      }
      
      public function readSeason(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         param1.clearAllItem();
         var _loc3_:int = 0;
         while(_loc3_ < fogBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc3_ * pixelTime;
            _loc2_.value = getSeason(_loc2_.time);
            _loc3_++;
         }
      }
      
      public function readTemperature(param1:TimeValue) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         param1.clearAllItem();
         var _loc6_:* = new Tween();
         _loc6_.mode = 6;
         _loc6_.factor = 2;
         var _loc7_:* = new Tween();
         _loc7_.mode = 6;
         _loc7_.factor = 5;
         var _loc8_:* = new Tween();
         _loc8_.mode = 2;
         _loc8_.factor = 2;
         var _loc9_:int = 0;
         while(_loc9_ < temperatureBMD.height)
         {
            _loc2_ = param1.addItem();
            _loc2_.time = startTime + _loc9_ * pixelTime;
            if(meteoId == 2)
            {
               _loc2_.value = Math.max(Math.min(-positionY / 40,1),0) * 0.3 + 0.7;
            }
            else
            {
               _loc3_ = _loc6_.generate((temperatureBMD.getPixel(temperatureBMD.width / 2,_loc9_) & 255) / 255) * 2 - 1;
               _loc4_ = getHeatSeason(_loc2_.time) * 2 - 1;
               _loc5_ = getSunTime(_loc2_.time) * 2 - 1;
               _loc2_.value = _loc4_ * 0.6 + _loc3_ * 0.25 + _loc5_ * 0.2;
               _loc2_.value = _loc2_.value / 2 + 0.5;
               _loc2_.value = _loc7_.generate(_loc2_.value) * 0.6 + _loc8_.generate(_loc2_.value) * 0.4;
               _loc2_.value = Math.max(Math.min(_loc2_.value,1),0);
               if(serverId == 2)
               {
                  _loc2_.value = 0.8;
               }
            }
            _loc9_++;
         }
      }
   }
}
