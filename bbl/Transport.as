package bbl
{
   import engine.TimeValue;
   import engine.TimeValueItem;
   import map.ServerMap;
   import net.Binary;
   
   public class Transport
   {
       
      
      public var id:uint;
      
      public var mapTimeValue:TimeValue;
      
      public var mapList:Array;
      
      public var periode:uint;
      
      public function Transport()
      {
         super();
         this.id = 0;
         this.periode = 0;
         this.mapTimeValue = new TimeValue();
         this.mapList = new Array();
      }
      
      public function getMapTimeLeftAt(param1:uint, param2:Number) : Number
      {
         var _loc3_:* = null;
         var _loc4_:uint = param2 % this.periode;
         var _loc5_:int = -1;
         var _loc6_:int = 0;
         while(_loc6_ < this.mapTimeValue.itemList.length)
         {
            _loc3_ = this.mapList[this.mapTimeValue.itemList[_loc6_].value];
            if(_loc3_.id == param1)
            {
               if(_loc5_ < 0)
               {
                  _loc5_ = this.mapTimeValue.itemList[_loc6_].time;
               }
               if(this.mapTimeValue.itemList[_loc6_].time > _loc4_)
               {
                  if(_loc6_ > 0)
                  {
                     if(this.mapList[this.mapTimeValue.itemList[_loc6_ - 1].value].id == param1)
                     {
                        return 0;
                     }
                  }
                  return this.mapTimeValue.itemList[_loc6_].time - _loc4_;
               }
            }
            _loc6_++;
         }
         return _loc5_ + this.periode - _loc4_;
      }
      
      public function getMapDistanceAt(param1:uint, param2:Number) : Number
      {
         var _loc3_:uint = param2 % this.periode;
         var _loc4_:Number = this.mapTimeValue.getValue(_loc3_);
         var _loc5_:ServerMap = this.mapList[Math.floor(_loc4_)];
         var _loc6_:ServerMap = this.mapList[Math.ceil(_loc4_)];
         if(_loc5_.id == param1)
         {
            return _loc4_ - Math.floor(_loc4_);
         }
         if(_loc6_.id == param1)
         {
            return Math.ceil(_loc4_) - _loc4_;
         }
         return 1;
      }
      
      public function readBinary(param1:Binary) : *
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this.id = param1.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID);
         var _loc5_:* = 0;
         while(param1.bitReadBoolean())
         {
            _loc2_ = uint(param1.bitReadUnsignedInt(4));
            if(_loc2_ == 0)
            {
               while(param1.bitReadBoolean())
               {
                  _loc3_ = new ServerMap();
                  _loc3_.id = param1.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                  this.mapList.push(_loc3_);
               }
            }
            else if(_loc2_ == 1)
            {
               while(param1.bitReadBoolean())
               {
                  _loc4_ = this.mapTimeValue.addItem();
                  _loc5_ = uint(_loc5_ + param1.bitReadUnsignedInt(10) * 1000);
                  _loc4_.time = _loc5_;
                  _loc4_.value = param1.bitReadUnsignedInt(5);
               }
               continue;
            }
         }
         this.periode = _loc5_;
      }
   }
}
