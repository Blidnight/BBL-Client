package map.noel
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   public class GuirlandeItem
   {
      
      private static var spotColorList:Array;
       
      
      public var source:MovieClip;
      
      public var GB:Object;
      
      public var camera:Object;
      
      public var spotSize:Number;
      
      private var spotPositionList:Array;
      
      private var ecran:BitmapData;
      
      private var lastStep:int;
      
      private var lastStepA:int;
      
      public function GuirlandeItem()
      {
         super();
         this.spotSize = 10;
      }
      
      public function init() : *
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         this.lastStep = -1;
         this.spotPositionList = new Array();
         this.source.visible = true;
         var _loc3_:Rectangle = this.source.getBounds(this.source);
         _loc3_.left = _loc3_.left - 10;
         _loc3_.right = _loc3_.right + 10;
         _loc3_.top = _loc3_.top - 10;
         _loc3_.bottom = _loc3_.bottom + 10;
         this.ecran = new BitmapData(Math.ceil(_loc3_.width),Math.ceil(_loc3_.height),true,0);
         if(!spotColorList)
         {
            spotColorList = new Array();
            this.addSpotColor(new ColorTransform(0,1,1));
            this.addSpotColor(new ColorTransform(1,1,0));
            this.addSpotColor(new ColorTransform(1,0,0));
            this.addSpotColor(new ColorTransform(1,0,1));
            this.addSpotColor(new ColorTransform(1,1,1));
            this.addSpotColor(new ColorTransform(0.2,0.2,1));
            this.addSpotColor(new ColorTransform(0,1,0));
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.source.numChildren)
         {
            _loc1_ = this.source.getChildAt(_loc4_);
            if(_loc1_ is MovieClip && _loc1_.name != "nospot")
            {
               this.spotPositionList.push(new Point(_loc1_.x - _loc3_.left,_loc1_.y - _loc3_.top));
               this.source.removeChildAt(_loc4_);
               _loc4_--;
            }
            _loc4_++;
         }
         var _loc5_:* = new Bitmap(this.ecran);
         _loc5_.x = _loc3_.left - this.spotSize / 2;
         _loc5_.y = _loc3_.top - this.spotSize / 2;
         _loc5_.blendMode = "hardlight";
         this.source.addChild(_loc5_);
         if(this.camera.lightEffect)
         {
            _loc2_ = this.camera.lightEffect.addItem(this.source);
            _loc2_.invertLight = true;
            _loc2_.redraw();
         }
         this.source.addEventListener("enterFrame",this.enterF,false);
      }
      
      public function enterF(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = Number(NaN);
         var _loc4_:Number = NaN;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(this.GB.noelFx.noelLight)
         {
            _loc2_ = this.source.name.split("_");
            _loc3_ = 0;
            if(_loc2_.length >= 2)
            {
               _loc3_ = Number(Math.round(Number(_loc2_[1])));
            }
            _loc4_ = this.GB.serverTime;
            _loc5_ = uint(_loc4_ % 60000);
            if(_loc5_ < 20000)
            {
               _loc6_ = 0;
            }
            else if(_loc5_ < 40000)
            {
               _loc6_ = 1;
            }
            else if(_loc5_ < 60000)
            {
               _loc6_ = 2;
            }
            _loc6_ = uint(_loc6_ + _loc3_);
            _loc6_ = uint(_loc6_ % 3);
            if(_loc6_ == 0)
            {
               this.doStepA(_loc4_,this.lastStep != _loc6_);
            }
            else if(_loc6_ == 1)
            {
               this.doStepB(_loc4_,this.lastStep != _loc6_);
            }
            else if(_loc6_ == 2)
            {
               this.doStepC(_loc4_,this.lastStep != _loc6_);
            }
            this.lastStep = _loc6_;
         }
      }
      
      public function addSpotColor(param1:ColorTransform) : *
      {
         var _loc2_:Number = 4278190080 + Math.round(param1.redMultiplier * 16711680) + Math.round(param1.greenMultiplier * 65280) + Math.round(param1.blueMultiplier * 255);
         var _loc3_:BitmapData = new BitmapData(this.spotSize,this.spotSize,true,0);
         var _loc4_:Rectangle = _loc3_.rect;
         _loc4_.left = _loc4_.left + 4;
         _loc4_.right = _loc4_.right - 4;
         _loc4_.top = _loc4_.top + 4;
         _loc4_.bottom = _loc4_.bottom - 4;
         _loc3_.fillRect(_loc4_,_loc2_);
         _loc3_.applyFilter(_loc3_,_loc3_.rect,new Point(),new GlowFilter(_loc2_,1,5,5,10,3));
         spotColorList.push(_loc3_);
      }
      
      public function dispose() : *
      {
         if(this.camera.lightEffect)
         {
            this.camera.lightEffect.removeItemByTarget(this.source);
         }
         this.source.removeEventListener("enterFrame",this.enterF,false);
      }
      
      public function doStepA(param1:Number, param2:Boolean) : *
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc6_:uint = Math.floor(param1 / 2000);
         if(_loc6_ != this.lastStepA || param2)
         {
            _loc3_ = uint(_loc6_ % spotColorList.length);
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < this.spotPositionList.length)
            {
               _loc4_.push(new Point(_loc5_,_loc3_));
               _loc5_++;
            }
            this.redraw(_loc4_);
            this.lastStepA = _loc6_;
         }
      }
      
      public function doStepB(param1:Number, param2:Boolean) : *
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc6_:uint = Math.floor(param1 / 1000);
         if(_loc6_ != this.lastStepA || param2)
         {
            _loc3_ = uint(Math.floor(param1 / 5000) % spotColorList.length);
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < this.spotPositionList.length)
            {
               if((_loc6_ + _loc5_) % 3 == 0)
               {
                  _loc4_.push(new Point(_loc5_,_loc3_));
               }
               _loc5_++;
            }
            this.redraw(_loc4_);
            this.lastStepA = _loc6_;
         }
      }
      
      public function doStepC(param1:Number, param2:Boolean) : *
      {
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc5_:uint = Math.floor(param1 / 2000);
         if(_loc5_ != this.lastStepA || param2)
         {
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < this.spotPositionList.length)
            {
               _loc3_.push(new Point(_loc4_,(_loc5_ + _loc4_ % 2) % spotColorList.length));
               _loc4_++;
            }
            this.redraw(_loc3_);
            this.lastStepA = _loc5_;
         }
      }
      
      public function redraw(param1:Array) : *
      {
         var _loc2_:* = null;
         this.ecran.lock();
         this.ecran.colorTransform(this.ecran.rect,new ColorTransform(0,0,0,0));
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = spotColorList[param1[_loc3_].y];
            this.ecran.copyPixels(_loc2_,_loc2_.rect,this.spotPositionList[param1[_loc3_].x],null,null,true);
            _loc3_++;
         }
         this.ecran.unlock();
      }
   }
}
