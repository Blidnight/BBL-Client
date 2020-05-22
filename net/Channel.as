package net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Channel extends EventDispatcher
   {
      
      public static var channelList:Object = new Object();
      
      public static var nextId:uint = 1000;
       
      
      public var message:Binary;
      
      private var _id:uint;
      
      public function Channel()
      {
         super();
         this._id = 0;
         var _loc1_:int = 0;
         while(channelList["id_" + nextId] && _loc1_ < 2)
         {
            nextId++;
            if(nextId >= 65534)
            {
               nextId = 1000;
               _loc1_++;
            }
         }
         if(!channelList["id_" + nextId])
         {
            this.id = nextId;
            nextId++;
         }
      }
      
      public static function clearAll() : *
      {
         nextId = 1000;
         channelList = new Object();
      }
      
      public static function dispatchMesage(param1:uint, param2:Binary) : *
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:Array = channelList["id_" + param1];
         if(_loc6_)
         {
            _loc6_ = _loc6_.slice();
            _loc3_ = uint(param2.bitPosition);
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               _loc5_ = new Event("onMessage");
               _loc6_[_loc4_].message = param2;
               _loc6_[_loc4_].dispatchEvent(_loc5_);
               param2.bitPosition = _loc3_;
               _loc4_++;
            }
         }
      }
      
      public function dispose() : *
      {
         this.id = 0;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Array = channelList["id_" + this._id];
         if(this._id && _loc3_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(_loc3_[_loc2_] == this)
               {
                  _loc3_.splice(_loc2_,1);
                  if(!_loc3_.length)
                  {
                     delete channelList["id_" + this._id];
                     break;
                  }
                  break;
               }
               _loc2_++;
            }
         }
         this._id = param1;
         if(param1)
         {
            _loc3_ = channelList["id_" + this._id];
            if(!_loc3_)
            {
               _loc3_ = new Array();
               channelList["id_" + this._id] = _loc3_;
            }
            _loc3_.push(this);
         }
      }
   }
}
