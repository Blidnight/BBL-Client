package bbl
{
   import net.SocketMessage;
   
   public class BblObject extends BblContact
   {
       
      
      public var objectList:Array;
      
      public var smileyAllowList:Array;
      
      public function BblObject()
      {
         super();
         this.smileyAllowList = new Array();
         this.smileyAllowList.push(0);
      }
      
      override public function init() : *
      {
         this.objectList = new Array();
         super.init();
      }
      
      public function getObjectById(param1:Number) : UserObject
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.objectList.length)
         {
            if(this.objectList[_loc2_].id == param1)
            {
               return this.objectList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeObjectById(param1:Number) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.objectList.length)
         {
            if(this.objectList[_loc2_].id == param1)
            {
               this.objectList[_loc2_].dispose();
               this.objectList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function userObjectEvent(param1:SocketMessage) : *
      {
         var _loc2_:* = 0;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         while(param1.bitReadBoolean())
         {
            _loc2_ = uint(param1.bitReadUnsignedInt(8));
            if(_loc2_ == 0)
            {
               _loc4_ = new UserObject();
               _loc4_.id = param1.bitReadUnsignedInt(32);
               _loc4_.fxFileId = param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
               _loc4_.objectId = param1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
               _loc4_.count = param1.bitReadUnsignedInt(32);
               _loc4_.expire = param1.bitReadUnsignedInt(32) * 1000;
               _loc4_.visibility = param1.bitReadUnsignedInt(3);
               _loc4_.genre = param1.bitReadUnsignedInt(5);
               _loc4_.data = param1.bitReadBinaryData();
               this.objectList.push(_loc4_);
               _loc3_ = true;
            }
            else if(_loc2_ == 1)
            {
               _loc4_ = this.getObjectById(param1.bitReadUnsignedInt(32));
               if(_loc4_)
               {
                  _loc4_.count = param1.bitReadUnsignedInt(32);
                  _loc4_.expire = param1.bitReadUnsignedInt(32) * 1000;
                  _loc4_.data = param1.bitReadBinaryData();
                  _loc4_.dispatchEvent(new Event("onChanged"));
               }
            }
         }
         if(_loc3_)
         {
            this.dispatchEvent(new Event("onObjectListChange"));
         }
      }
   }
}
