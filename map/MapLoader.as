package map
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class MapLoader extends EventDispatcher
   {
      
      public static var mapList:Array = new Array();
      
      public static var mapAdr:String = "../data/map/";
      
      public static var cacheVersion:uint = 0;
       
      
      public var lastLoad:MapLoaderItem;
      
      public var currentLoad:MapLoaderItem;
      
      public function MapLoader()
      {
         super();
         this.lastLoad = null;
         this.currentLoad = null;
      }
      
      public static function clearAll() : *
      {
         mapList.splice(0,mapList.length);
      }
      
      public static function clearById(param1:uint) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < mapList.length)
         {
            if(mapList[_loc2_].id == param1)
            {
               mapList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function initMapEvent(param1:Event) : *
      {
         this.lastLoad = this.currentLoad;
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
         this.dispatchEvent(new Event("onMapLoaded"));
      }
      
      public function errLoader(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
         this.removeById(this.currentLoad.id);
         this.removeItemListener(this.currentLoad);
         this.currentLoad = null;
      }
      
      public function removeById(param1:Number) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < mapList.length)
         {
            if(mapList[_loc2_].id == param1)
            {
               mapList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getMapById(param1:Number) : MapLoaderItem
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(_loc3_ < mapList.length)
         {
            if(mapList[_loc3_].id == param1)
            {
               _loc2_ = mapList[_loc3_];
               mapList.splice(_loc3_,1);
               mapList.push(_loc2_);
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function abortLoad() : *
      {
         if(this.currentLoad)
         {
            this.removeItemListener(this.currentLoad);
            if(this.currentLoad.instance == 0)
            {
               this.removeById(this.currentLoad.id);
               try
               {
                  this.currentLoad.urlLoader.close();
               }
               catch(e:*)
               {
               }
            }
            this.currentLoad = null;
         }
      }
      
      public function loadMap(param1:Number) : void
      {
         this.abortLoad();
         var _loc2_:MapLoaderItem = this.getMapById(param1);
         if(_loc2_)
         {
            if(_loc2_.loaded)
            {
               this.lastLoad = _loc2_;
               dispatchEvent(new Event("onMapLoaded"));
            }
            else
            {
               this.currentLoad = _loc2_;
               this.addItemListener(this.currentLoad);
            }
         }
         else
         {
            this.currentLoad = new MapLoaderItem();
            this.addItemListener(this.currentLoad);
            this.currentLoad.id = param1;
            mapList.push(this.currentLoad);
            GlobalProperties.assetsBridge.loadAsset(this.currentLoad);
         }
      }
      
      public function addItemListener(param1:MapLoaderItem) : *
      {
         param1.instance++;
         param1.addEventListener(Event.INIT,this.initMapEvent,false,0,false);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      public function removeItemListener(param1:MapLoaderItem) : *
      {
         param1.instance--;
         param1.removeEventListener(Event.INIT,this.initMapEvent,false);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
      }
   }
}
