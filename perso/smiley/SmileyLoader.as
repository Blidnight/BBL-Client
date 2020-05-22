package perso.smiley
{
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class SmileyLoader extends EventDispatcher
   {
      
      public static var smileyList:Array = new Array();
      
      public static var smileyAdr:String = "../data/smiley/";
      
      public static var cacheVersion:uint = 0;
       
      
      public function SmileyLoader()
      {
         super();
      }
      
      public static function clearAll() : *
      {
         smileyList.splice(0,smileyList.length);
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < smileyList.length)
         {
            if(smileyList[_loc2_] == param1.currentTarget)
            {
               smileyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
      
      public function getSmileyById(param1:Number) : SmileyLoaderItem
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(_loc3_ < smileyList.length)
         {
            if(smileyList[_loc3_].id == param1)
            {
               _loc2_ = smileyList[_loc3_];
               smileyList.splice(_loc3_,1);
               smileyList.push(_loc2_);
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function loadPack(param1:Number) : SmileyPack
      {
         var _loc2_:SmileyLoaderItem = this.getSmileyById(param1);
         if(!_loc2_)
         {
            _loc2_ = new SmileyLoaderItem();
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
            _loc2_.id = param1;
            smileyList.push(_loc2_);
            GlobalProperties.assetsBridge.loadAsset(_loc2_);
         }
         var _loc3_:SmileyPack = new SmileyPack();
         _loc3_.loaderItem = _loc2_;
         return _loc3_;
      }
   }
}
