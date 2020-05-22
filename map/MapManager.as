package map
{
   import bbl.Quality;
   import engine.MultiBitmapData;
   import engine.Physic;
   import engine.Scroller;
   import engine.ScrollerItem;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MapManager extends Sprite
   {
       
      
      public var data:Object;
      
      public var persistentData:Object;
      
      public var currentMap:Object;
      
      public var serverId:int;
      
      public var mapReady:Boolean;
      
      public var mapLoader:MapLoader;
      
      public var mapPreloader:MapLoader;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var defaultScreenWidth:Number;
      
      public var defaultScreenHeight:Number;
      
      public var scroller:Scroller;
      
      public var physic:Physic;
      
      public var userContent:Sprite;
      
      public var userContentList:Array;
      
      public var bulleContent:Sprite;
      
      public var lightContent:Sprite;
      
      public var preloadList:Array;
      
      private var _quality:Quality;
      
      private var _mapFileId:Object;
      
      public function MapManager()
      {
         super();
         this.defaultScreenWidth = 950;
         this.defaultScreenHeight = 425;
         this.mapFileId = 0;
         this.preloadList = new Array();
         this.data = new Object();
         this.persistentData = new Object();
         this.mapReady = false;
         this.mapLoader = new MapLoader();
         this.mapLoader.addEventListener("onMapLoaded",this.onMapLoaded,false,0,true);
         this.mapPreloader = new MapLoader();
         this.mapPreloader.addEventListener("onMapLoaded",this.onMapPreloaded,false,0,true);
         this.scroller = new Scroller();
         this.setDefaultScreenSize();
         this.userContent = null;
         this.bulleContent = null;
         this.quality = new Quality();
         this.userContentList = new Array();
      }
      
      public function init() : *
      {
         this.onChangeScreenSize();
      }
      
      public function onQualitySoundChange(param1:Event) : *
      {
      }
      
      public function onQualityChange(param1:Event) : *
      {
         this.mapManagerUpdateQuality();
      }
      
      public function mapManagerUpdateQuality() : *
      {
         this.scroller.scrollMode = this._quality.scrollMode == 1?0:1;
      }
      
      public function onMapReady(param1:Event = null) : *
      {
         this.currentMap.removeEventListener("onMapReady",this.onMapReady,false);
         this.mapReady = true;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(0,100);
         _loc2_.graphics.lineTo(this.screenWidth,0);
         _loc2_.graphics.lineTo(this.screenWidth,this.screenHeight);
         _loc2_.graphics.lineTo(0,this.screenHeight);
         _loc2_.graphics.lineTo(0,0);
         _loc2_.graphics.endFill();
         this.currentMap.addChildAt(_loc2_,0);
         this.currentMap.graphic.mask = _loc2_;
      }
      
      public function rebuildMapCollision() : *
      {
         if(this.physic)
         {
            this.physic.dispose();
            this.physic = null;
         }
         this.physic = new Physic();
         this.physic.readMap(this.currentMap.physic.surfaceMap,this.currentMap.physic.environmentMap,this.currentMap.mapWidth,this.currentMap.mapHeight);
      }
      
      public function updateMapCollision() : *
      {
         this.physic.updateCollisionMap(this.currentMap.physic.surfaceMap,this.currentMap.mapWidth,this.currentMap.mapHeight);
      }
      
      public function getUserContentByName(param1:String) : Sprite
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.userContentList.length)
         {
            if(this.userContentList[_loc2_].name == "userContent_" + param1)
            {
               return this.userContentList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function onChangeScreenSize() : *
      {
         this.scroller.screenWidth = this.screenWidth;
         this.scroller.screenHeight = this.screenHeight;
      }
      
      public function setDefaultScreenSize() : *
      {
         this.screenWidth = this.defaultScreenWidth;
         this.screenHeight = this.defaultScreenHeight;
         if(this.currentMap)
         {
            if(this.currentMap.mapWidth < this.defaultScreenWidth)
            {
               this.screenWidth = this.currentMap.mapWidth;
            }
            if(this.currentMap.mapHeight < this.defaultScreenHeight)
            {
               this.screenHeight = this.currentMap.mapHeight;
            }
         }
         this.onChangeScreenSize();
      }
      
      public function setScreenSize(param1:Number, param2:Number) : *
      {
         this.screenWidth = param1;
         this.screenHeight = param2;
         this.onChangeScreenSize();
      }
      
      public function abortPreload(param1:int = -1) : *
      {
         if(this.mapPreloader)
         {
            if(this.mapPreloader.currentLoad)
            {
               if(this.mapPreloader.currentLoad.id != param1)
               {
                  this.mapPreloader.abortLoad();
               }
            }
         }
         this.preloadList.splice(0,this.preloadList.length);
      }
      
      public function onMapPreloaded(param1:Event = null) : *
      {
         var _loc2_:* = 0;
         if(this.preloadList.length && !this.mapPreloader.currentLoad)
         {
            _loc2_ = uint(this.preloadList.shift());
            this.mapPreloader.loadMap(_loc2_);
         }
      }
      
      public function addPreloadList(param1:uint) : *
      {
         if(!this.mapPreloader.getMapById(param1))
         {
            this.preloadList.push(param1);
            this.onMapPreloaded();
         }
      }
      
      public function optimizeClipCreateBitmap(param1:Array) : *
      {
         var _loc7_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc5_)
            {
               _loc5_ = _loc5_.union(param1[_loc2_].getBounds(param1[_loc2_].parent));
            }
            else
            {
               _loc5_ = param1[_loc2_].getBounds(param1[_loc2_].parent);
            }
            _loc2_++;
         }
         var _loc6_:MultiBitmapData = new MultiBitmapData(Math.ceil(_loc5_.width),Math.ceil(_loc5_.height),true,0);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Matrix();
            _loc3_.translate(param1[_loc2_].x - _loc5_.x,param1[_loc2_].y - _loc5_.y);
            _loc4_ = new Matrix();
            _loc4_.scale(param1[_loc2_].scaleX,param1[_loc2_].scaleY);
            _loc3_.concat(_loc4_);
            _loc6_.draw(param1[_loc2_],_loc3_);
            _loc2_++;
         }
         _loc7_ = _loc6_.getSprite();
         _loc7_.x = _loc5_.x;
         _loc7_.y = _loc5_.y;
         _loc7_.transform.colorTransform = new ColorTransform(1,0,0,1,0,0,0,0);
         param1[0].parent.addChildAt(_loc7_,param1[0].parent.getChildIndex(param1[0]));
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].parent.removeChild(param1[_loc2_]);
            _loc2_++;
         }
         param1.splice(0,param1.length);
      }
      
      public function optimizeClip(param1:DisplayObjectContainer, param2:Boolean = false, param3:uint = 0) : Boolean
      {
         var _loc4_:* = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Array = new Array();
         var _loc10_:Boolean = true;
         var _loc11_:int = param1.numChildren - 1;
         while(_loc11_ >= 0)
         {
            _loc4_ = param1.getChildAt(_loc11_);
            _loc5_ = false;
            _loc6_ = false;
            _loc7_ = true;
            _loc8_ = false;
            if(_loc4_ is MovieClip)
            {
               if(MovieClip(_loc4_).totalFrames > 1)
               {
                  _loc5_ = true;
                  _loc10_ = false;
               }
            }
            if(_loc4_.name.split("rainMask").length == 2)
            {
               _loc10_ = false;
               _loc8_ = true;
            }
            if(_loc4_.name.split("instance").length != 2)
            {
               _loc10_ = false;
               _loc6_ = true;
            }
            if(!_loc5_ && !_loc8_)
            {
               if(_loc4_ is DisplayObjectContainer)
               {
                  _loc7_ = this.optimizeClip(DisplayObjectContainer(_loc4_),false,param3 + 1);
               }
               if(!_loc7_)
               {
                  _loc10_ = false;
               }
               if(_loc7_ && !_loc6_)
               {
                  _loc9_.push(_loc4_);
               }
            }
            if(_loc9_.length && (_loc6_ || _loc5_ || !_loc7_ || _loc8_))
            {
               this.optimizeClipCreateBitmap(_loc9_);
            }
            _loc11_--;
         }
         if((param2 || param1.name.split("instance").length != 2) && _loc9_.length)
         {
            this.optimizeClipCreateBitmap(_loc9_);
         }
         return _loc10_;
      }
      
      public function onMapLoaded(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = Number(NaN);
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = null;
         this.data = new Object();
         this.currentMap = new this.mapLoader.lastLoad.classRef();
         this.setDefaultScreenSize();
         addChild(DisplayObject(this.currentMap));
         this.currentMap.addEventListener("onMapReady",this.onMapReady,false,0,true);
         this.scroller.mapWidth = this.currentMap.mapWidth;
         this.scroller.mapHeight = this.currentMap.mapHeight;
         this.scroller.depthScrollEffect = !!this.currentMap.depthScrollEffect?true:false;
         this.scroller.relativeObject = this.currentMap.graphic;
         this.rebuildMapCollision();
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.currentMap.graphic.getChildAt(_loc2_);
            _loc2_--;
         }
         var _loc9_:* = null;
         var _loc10_:* = null;
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.currentMap.graphic.getChildAt(_loc2_);
            _loc5_ = _loc4_.name.split("plan_");
            if(_loc5_.length == 2)
            {
               if(_loc5_[1] == 5 && !_loc9_)
               {
                  _loc9_ = _loc4_;
                  _loc6_ = this.getChildList(_loc4_,10);
                  _loc3_ = 0;
                  while(_loc3_ < _loc6_.length)
                  {
                     if(_loc6_[_loc3_].target.name.split("_")[0] == "userContent")
                     {
                        this.userContentList.push(_loc6_[_loc3_].target);
                     }
                     _loc3_++;
                  }
               }
               if(_loc5_[1] > 5 && !_loc10_)
               {
                  _loc10_ = _loc4_;
               }
            }
            _loc2_--;
         }
         if(!_loc9_ && !this.userContentList.length)
         {
            _loc9_ = new Sprite();
            _loc9_.name = "plan_5";
            if(!_loc10_)
            {
               this.currentMap.graphic.addChild(_loc9_);
            }
            else
            {
               _loc7_ = this.currentMap.graphic.getChildIndex(_loc10_);
               this.currentMap.graphic.addChildAt(_loc9_,_loc7_ + 1);
            }
         }
         if(_loc9_ && !this.userContentList.length)
         {
            this.userContent = new Sprite();
            _loc9_.addChild(this.userContent);
            this.userContentList.push(this.userContent);
         }
         this.userContentList.sortOn("name",Array.CASEINSENSITIVE);
         this.userContent = this.userContentList[0];
         this.lightContent = new Sprite();
         _loc2_ = this.userContent.parent.getChildIndex(this.userContent);
         this.userContent.parent.addChildAt(this.lightContent,_loc2_ + 1);
         this.bulleContent = new Sprite();
         this.userContent.parent.addChild(this.bulleContent);
         var _loc11_:* = 5;
         _loc2_ = this.currentMap.graphic.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.currentMap.graphic.getChildAt(_loc2_);
            _loc5_ = _loc4_.name.split("plan_");
            if(_loc5_.length == 2)
            {
               _loc11_ = Number(_loc5_[1]);
            }
            _loc8_ = this.scroller.addItem();
            _loc8_.plan = _loc11_;
            _loc8_.target = _loc4_;
            _loc2_--;
         }
         this.mapManagerUpdateQuality();
         this.dispatchEvent(new Event("onMapLoaded"));
      }
      
      public function getChildList(param1:DisplayObjectContainer, param2:Number = 0, param3:Class = null, param4:Array = null, param5:Number = 0, param6:Number = 0) : Array
      {
         var _loc7_:* = null;
         var _loc8_:* = undefined;
         var _loc9_:* = null;
         if(!param4)
         {
            param4 = new Array();
         }
         if(!param3)
         {
            param3 = DisplayObjectContainer;
         }
         param2--;
         param6++;
         var _loc10_:int = 0;
         while(_loc10_ < param1.numChildren && param2 >= -1)
         {
            _loc7_ = param1.getChildAt(_loc10_);
            if(param6 == 1)
            {
               _loc8_ = _loc7_.name.split("plan_");
               if(_loc8_.length == 2)
               {
                  param5 = _loc8_[1];
               }
            }
            if(_loc7_ is param3)
            {
               _loc9_ = new ScrollerItem();
               _loc9_.plan = param5;
               _loc9_.target = _loc7_;
               param4.push(_loc9_);
            }
            if(_loc7_ is DisplayObjectContainer)
            {
               this.getChildList(DisplayObjectContainer(_loc7_),param2,param3,param4,param5,param6);
            }
            _loc10_++;
         }
         return param4;
      }
      
      public function dispose() : *
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this.abortPreload();
         this.unloadMap();
         this.mapLoader.removeEventListener("onMapLoaded",this.onMapLoaded,false);
         this.mapPreloader.removeEventListener("onMapLoaded",this.onMapPreloaded,false);
         this._quality.removeEventListener("onChanged",this.onQualityChange,false);
         this._quality.removeEventListener("onSoundChanged",this.onQualitySoundChange,false);
         this.dispatchEvent(new Event("onDisposed"));
      }
      
      public function unloadMap() : *
      {
         this.scroller.clearAllItem();
         this.scroller.relativeObject = null;
         this.mapReady = false;
         if(this.currentMap)
         {
            removeChild(DisplayObject(this.currentMap));
            this.currentMap.removeEventListener("onMapReady",this.onMapReady,false);
            this.currentMap.dispose();
         }
         this.currentMap = null;
         this.userContent = null;
         this.userContentList = new Array();
         this.bulleContent = null;
         if(this.physic)
         {
            this.physic.dispose();
            this.physic = null;
         }
         this.dispatchEvent(new Event("onUnloadMap"));
      }
      
      public function loadMap(param1:int) : *
      {
         this.abortPreload(param1);
         this.unloadMap();
         this.mapFileId = param1;
         this.mapLoader.loadMap(param1);
      }
      
      public function set mapFileId(param1:int) : *
      {
         this._mapFileId = {"val":param1};
      }
      
      public function get mapFileId() : int
      {
         return this._mapFileId.val;
      }
      
      public function get quality() : Quality
      {
         return this._quality;
      }
      
      public function set quality(param1:Quality) : *
      {
         if(param1 != this._quality)
         {
            if(this._quality)
            {
               this._quality.removeEventListener("onChanged",this.onQualityChange,false);
               this._quality.removeEventListener("onSoundChanged",this.onQualitySoundChange,false);
            }
            this._quality = param1;
            this._quality.addEventListener("onChanged",this.onQualityChange,false,0,true);
            this._quality.addEventListener("onSoundChanged",this.onQualitySoundChange,false,0,true);
            this.onQualityChange(null);
            this.onQualitySoundChange(null);
         }
      }
   }
}
