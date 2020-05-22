package bbl
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ExternalLoader extends EventDispatcher
   {
      
      public static var external:Loader = new Loader();
      
      public static var loadStep:Number = 0;
      
      public static var externalAdr:String = "../data/external.swf";
      
      public static var cacheVersion:uint = 0;
       
      
      public function ExternalLoader()
      {
         super();
      }
      
      public function load() : *
      {
         external.contentLoaderInfo.addEventListener(Event.INIT,this.onLoaded,false,0,true);
         if(loadStep == 2)
         {
            this.onLoaded(null);
         }
         else if(loadStep == 0)
         {
            loadStep = 1;
            GlobalProperties.assetsBridge.loadAsset(this);
         }
      }
      
      public function getClass(param1:String) : Object
      {
         return external.contentLoaderInfo.applicationDomain.getDefinition(param1);
      }
      
      public function onLoaded(param1:Event) : *
      {
         var _loc2_:* = [208,48,101,0,96,5,48,96,101,48];
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            if(external.contentLoaderInfo.bytes[458000 + _loc4_] != _loc2_[_loc4_])
            {
               _loc3_ = false;
               break;
            }
            _loc4_++;
         }
         loadStep = 2;
         if(_loc3_)
         {
            this.dispatchEvent(new Event("onReady"));
         }
      }
   }
}
