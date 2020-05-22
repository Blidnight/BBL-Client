package engine
{
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MultiBitmapData
   {
       
      
      public var matrix:Array;
      
      public var mapWidth:uint;
      
      public var mapHeight:uint;
      
      public var width:uint;
      
      public var height:uint;
      
      private var nbX:uint;
      
      private var nbY:uint;
      
      public function MultiBitmapData(param1:int, param2:int, param3:Boolean = true, param4:uint = 4.294967295E9)
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         super();
         this.width = param1;
         this.height = param2;
         this.mapWidth = 2800;
         this.mapHeight = 2800;
         this.matrix = new Array();
         this.nbX = Math.ceil(this.width / this.mapWidth);
         this.nbY = Math.ceil(this.height / this.mapHeight);
         var _loc7_:int = 0;
         while(_loc7_ < this.nbX)
         {
            this.matrix.push(new Array());
            _loc5_ = 0;
            while(_loc5_ < this.nbY)
            {
               param1 = (_loc7_ + 1) * this.mapWidth <= this.width?int(int(this.mapWidth)):int(int(this.width - _loc7_ * this.mapWidth));
               param2 = (_loc5_ + 1) * this.mapHeight <= this.height?int(int(this.mapHeight)):int(int(this.height - _loc5_ * this.mapHeight));
               _loc6_ = new BitmapData(param1,param2,param3,param4);
               this.matrix[_loc7_].push(_loc6_);
               _loc5_++;
            }
            _loc7_++;
         }
      }
      
      public function getSprite() : Sprite
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:int = 0;
         while(_loc4_ < this.nbX)
         {
            _loc1_ = 0;
            while(_loc1_ < this.nbY)
            {
               _loc2_ = new Bitmap(this.matrix[_loc4_][_loc1_],"auto",false);
               _loc3_.addChild(_loc2_);
               _loc2_.x = _loc4_ * this.mapWidth;
               _loc2_.y = _loc1_ * this.mapHeight;
               _loc1_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getPixel(param1:int, param2:int) : uint
      {
         var _loc3_:* = undefined;
         var _loc4_:* = Math.floor(param1 / this.mapWidth);
         var _loc5_:* = Math.floor(param2 / this.mapHeight);
         if(_loc4_ >= this.nbX)
         {
            _loc4_ = this.nbX - 1;
         }
         if(_loc5_ >= this.nbY)
         {
            _loc5_ = this.nbY - 1;
         }
         var _loc6_:* = param1 - _loc4_ * this.mapWidth;
         var _loc7_:* = param2 - _loc5_ * this.mapHeight;
         var _loc8_:* = this.matrix[_loc4_];
         if(_loc8_)
         {
            _loc3_ = _loc8_[_loc5_];
            if(_loc3_)
            {
               return _loc3_.getPixel(_loc6_,_loc7_);
            }
         }
         return 0;
      }
      
      public function getPixel32(param1:int, param2:int) : uint
      {
         var _loc3_:* = undefined;
         var _loc4_:* = Math.floor(param1 / this.mapWidth);
         var _loc5_:* = Math.floor(param2 / this.mapHeight);
         if(_loc4_ >= this.nbX)
         {
            _loc4_ = this.nbX - 1;
         }
         if(_loc5_ >= this.nbY)
         {
            _loc5_ = this.nbY - 1;
         }
         var _loc6_:* = param1 - _loc4_ * this.mapWidth;
         var _loc7_:* = param2 - _loc5_ * this.mapHeight;
         var _loc8_:* = this.matrix[_loc4_];
         if(_loc8_)
         {
            _loc3_ = _loc8_[_loc5_];
            if(_loc3_)
            {
               return _loc3_.getPixel32(_loc6_,_loc7_);
            }
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < this.nbX)
         {
            _loc1_ = 0;
            while(_loc1_ < this.nbY)
            {
               this.matrix[_loc2_][_loc1_].dispose();
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function draw(param1:IBitmapDrawable, param2:Matrix = null, param3:ColorTransform = null, param4:String = null, param5:Rectangle = null, param6:Boolean = false) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = null;
         var _loc9_:* = undefined;
         var _loc10_:* = null;
         var _loc11_:int = 0;
         while(_loc11_ < this.nbX)
         {
            _loc7_ = 0;
            while(_loc7_ < this.nbY)
            {
               _loc9_ = new Matrix();
               _loc9_.translate(-_loc11_ * this.mapWidth,-_loc7_ * this.mapHeight);
               if(param2)
               {
                  _loc8_ = param2.clone();
                  _loc8_.concat(_loc9_);
               }
               else
               {
                  _loc8_ = _loc9_;
               }
               _loc10_ = null;
               if(param5)
               {
                  _loc10_ = param5.clone();
                  _loc10_.left = _loc10_.left - _loc11_ * this.mapWidth;
                  _loc10_.top = _loc10_.top - _loc7_ * this.mapHeight;
                  _loc10_.width = _loc10_.width - _loc11_ * this.mapWidth;
                  _loc10_.height = _loc10_.height - _loc7_ * this.mapHeight;
               }
               this.matrix[_loc11_][_loc7_].draw(param1,_loc8_,param3,param4,_loc10_,param6);
               _loc7_++;
            }
            _loc11_++;
         }
      }
   }
}
