package perso
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.Timer;
   
   public class SkinLoader extends EventDispatcher
   {
      
      public static var skinList:Array = new Array();
      
      public static var skinAdr:String = "../data/skin/";
      
      public static var cacheVersion:uint = 0;
       
      
      public var lastLoad:SkinLoaderItem;
      
      public var currentLoad:SkinLoaderItem;
      
      private var maxTry:uint;
      
      private var retryTimer:Timer;
      
      public function SkinLoader()
      {
         super();
         this.lastLoad = null;
         this.currentLoad = null;
         this.maxTry = 3;
         this.retryTimer = new Timer(4000);
         this.retryTimer.addEventListener("timer",this.retryTimerEvt);
      }
      
      public static function clearAll() : *
      {
         skinList.splice(0,skinList.length);
      }
      
      public static function clearById(param1:uint) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < skinList.length)
         {
            if(skinList[_loc2_].id == param1)
            {
               skinList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function initSkinEvent(param1:Event) : *
      {
         this.lastLoad = this.currentLoad;
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
         this.retryTimer.stop();
         this.dispatchEvent(new Event("onSkinLoaded"));
      }
      
      public function retryTimerEvt(param1:Event) : *
      {
         this.retryTimer.stop();
         if(this.currentLoad)
         {
            GlobalProperties.assetsBridge.loadAsset(this.currentLoad);
         }
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         var _loc2_:int = 0;
         if(this.currentLoad)
         {
            if(this.currentLoad.nbTry >= this.maxTry)
            {
               dispatchEvent(param1);
               _loc2_ = 0;
               while(_loc2_ < skinList.length)
               {
                  if(skinList[_loc2_] == this.currentLoad)
                  {
                     skinList.splice(_loc2_,1);
                     break;
                  }
                  _loc2_++;
               }
               this.removeItemListener(this.currentLoad);
               this.currentLoad = null;
            }
            else
            {
               this.currentLoad.nbTry++;
               this.retryTimer.reset();
               this.retryTimer.start();
            }
         }
      }
      
      public function getSkinById(param1:Number) : SkinLoaderItem
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(_loc3_ < skinList.length)
         {
            if(skinList[_loc3_].id == param1)
            {
               _loc2_ = skinList[_loc3_];
               skinList.splice(_loc3_,1);
               skinList.push(_loc2_);
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function loadSkin(param1:Number) : void
      {
         if(this.currentLoad)
         {
            this.removeItemListener(this.currentLoad);
            this.retryTimer.stop();
            this.currentLoad = null;
         }
         var _loc2_:SkinLoaderItem = this.getSkinById(param1);
         if(_loc2_)
         {
            if(_loc2_.loaded)
            {
               this.lastLoad = _loc2_;
               dispatchEvent(new Event("onSkinLoaded"));
            }
            else
            {
               this.currentLoad = _loc2_;
               this.addItemListener(this.currentLoad);
            }
         }
         else
         {
            this.currentLoad = new SkinLoaderItem();
            this.addItemListener(this.currentLoad);
            this.currentLoad.id = param1;
            skinList.push(this.currentLoad);
            GlobalProperties.assetsBridge.loadAsset(this.currentLoad);
         }
      }
      
      public function addItemListener(param1:SkinLoaderItem) : *
      {
         param1.addEventListener(Event.INIT,this.initSkinEvent,false,0,false);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function removeItemListener(param1:SkinLoaderItem) : *
      {
         param1.removeEventListener(Event.INIT,this.initSkinEvent,false);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
   }
}
