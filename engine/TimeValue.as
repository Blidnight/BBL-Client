package engine
{
   public class TimeValue
   {
       
      
      public var itemList:Array;
      
      private var lastIndex:uint;
      
      public function TimeValue()
      {
         super();
         this.itemList = new Array();
         this.lastIndex = 0;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:int = this.itemList.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.itemList.splice(_loc2_,1);
         }
      }
      
      public function addItem() : TimeValueItem
      {
         var _loc1_:* = new TimeValueItem();
         this.itemList.push(_loc1_);
         return _loc1_;
      }
      
      public function clearAllItem() : *
      {
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function order() : *
      {
         this.itemList.sortOn("time",16);
      }
      
      public function getSpeedAt(param1:Number = 0) : Number
      {
         var _loc2_:* = this.getInterval(param1);
         if(_loc2_.length <= 1)
         {
            return 0;
         }
         return (_loc2_[1].value - _loc2_[0].value) / ((_loc2_[1].time - _loc2_[0].time) / 1000);
      }
      
      public function getValue(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = this.getInterval(param1);
         if(_loc4_.length == 0)
         {
            return 0;
         }
         if(_loc4_.length == 1)
         {
            return _loc4_[0].value;
         }
         _loc2_ = _loc4_[1].value - _loc4_[0].value;
         _loc3_ = _loc4_[1].time - _loc4_[0].time;
         return _loc2_ * (param1 - _loc4_[0].time) / _loc3_ + _loc4_[0].value;
      }
      
      public function getInterval(param1:Number) : Array
      {
         var _loc2_:* = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.itemList.length == 0)
         {
            return [];
         }
         if(this.itemList.length == 1)
         {
            return [this.itemList[0]];
         }
         if(param1 >= this.itemList[this.itemList.length - 1].time)
         {
            this.lastIndex = this.itemList.length - 1;
            return [this.itemList[this.itemList.length - 1]];
         }
         if(param1 < this.itemList[0].time)
         {
            this.lastIndex = 0;
            return [this.itemList[0]];
         }
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(this.lastIndex >= this.itemList.length)
         {
            this.lastIndex = this.itemList.length - 1;
         }
         if(this.lastIndex < this.itemList.length - 1)
         {
            _loc2_ = uint(this.lastIndex);
            while(_loc2_ < this.itemList.length - 1)
            {
               _loc3_ = this.itemList[_loc2_];
               _loc4_ = this.itemList[_loc2_ + 1];
               if(_loc3_.time <= param1 && _loc4_.time > param1)
               {
                  _loc5_ = _loc3_;
                  _loc6_ = _loc4_;
                  this.lastIndex = _loc2_;
                  break;
               }
               _loc2_++;
            }
         }
         if(this.lastIndex > 0 && !_loc5_)
         {
            _loc2_ = uint(this.lastIndex - 1);
            while(_loc2_ >= 0)
            {
               _loc3_ = this.itemList[_loc2_];
               _loc4_ = this.itemList[_loc2_ + 1];
               if(_loc3_.time <= param1 && _loc4_.time > param1)
               {
                  _loc5_ = _loc3_;
                  _loc6_ = _loc4_;
                  this.lastIndex = _loc2_;
                  break;
               }
               _loc2_--;
            }
         }
         if(_loc5_)
         {
            return [_loc5_,_loc6_];
         }
         return [];
      }
      
      public function getLastValue() : Number
      {
         if(this.itemList.length == 0)
         {
            return 0;
         }
         return this.itemList[this.itemList.length - 1].value;
      }
      
      public function setSingleValue(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc4_:* = this.getValue(param1);
         this.clearAllItem();
         var _loc5_:* = this.addItem();
         _loc5_.time = param1;
         _loc5_.value = _loc4_;
         _loc5_ = this.addItem();
         _loc5_.time = param1 + param3;
         _loc5_.value = param2;
      }
   }
}
