package fx
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class FxLoader extends EventDispatcher
   {
      
      public static var fxList:Array = new Array();
      
      public static var fxAdr:String = "../data/fx/";
      
      public static var cacheVersion:uint = 0;
       
      
      public var lastLoad:FxLoaderItem;
      
      public var currentLoad:FxLoaderItem;
      
      public var initData:Object;
      
      public var clearInitData:Boolean;
      
      public function FxLoader()
      {
         super();
         this.lastLoad = null;
         this.currentLoad = null;
         this.clearInitData = true;
      }
      
      public static function clearAll() : *
      {
         fxList.splice(0,fxList.length);
      }
      
      public static function clearById(param1:uint) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < fxList.length)
         {
            if(fxList[_loc2_].id == param1)
            {
               fxList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function initFxEvent(param1:Event) : *
      {
         this.lastLoad = this.currentLoad;
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
         this.doAtInit();
         this.dispatchEvent(new Event("onFxLoaded"));
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
         var _loc2_:int = 0;
         while(_loc2_ < fxList.length)
         {
            if(fxList[_loc2_] == this.currentLoad)
            {
               fxList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
      }
      
      public function doAtInit() : *
      {
         var _loc1_:* = null;
         if(this.lastLoad && this.initData)
         {
            _loc1_ = new this.lastLoad.classRef();
            _loc1_.initFx(this.initData);
            if(this.clearInitData)
            {
               this.initData = null;
            }
         }
      }
      
      public function getFxById(param1:Number) : FxLoaderItem
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(_loc3_ < fxList.length)
         {
            if(fxList[_loc3_].id == param1)
            {
               _loc2_ = fxList[_loc3_];
               fxList.splice(_loc3_,1);
               fxList.push(_loc2_);
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function loadFx(param1:Number) : FxLoaderItem
      {
         if(this.currentLoad)
         {
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
         }
         var _loc2_:FxLoaderItem = this.getFxById(param1);
         if(_loc2_)
         {
            if(_loc2_.loaded)
            {
               this.lastLoad = _loc2_;
               this.doAtInit();
               dispatchEvent(new Event("onFxLoaded"));
               return _loc2_;
            }
            this.currentLoad = _loc2_;
            this.addItemListener(this.currentLoad);
         }
         else
         {
            this.currentLoad = new FxLoaderItem();
            this.addItemListener(this.currentLoad);
            this.currentLoad.id = param1;
            fxList.push(this.currentLoad);
            GlobalProperties.assetsBridge.loadAsset(this.currentLoad);
         }
         return null;
      }
      
      public function addItemListener(param1:FxLoaderItem) : *
      {
         param1.addEventListener(Event.INIT,this.initFxEvent,false,0,false);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function removeItemListener(param1:FxLoaderItem) : *
      {
         param1.removeEventListener(Event.INIT,this.initFxEvent,false);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
   }
}
