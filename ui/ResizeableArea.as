package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ResizeableArea extends Sprite
   {
       
      
      public var source:MovieClip;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _map:Array;
      
      private var mainbtmd:BitmapData;
      
      private var P0:Bitmap;
      
      private var P1:Bitmap;
      
      private var P2:Bitmap;
      
      private var P3:Bitmap;
      
      private var P4:Bitmap;
      
      private var P5:Bitmap;
      
      private var P6:Bitmap;
      
      private var P7:Bitmap;
      
      private var P8:Bitmap;
      
      private var P9:Bitmap;
      
      public function ResizeableArea()
      {
         var _loc1_:* = undefined;
         super();
         this.source.stop();
         this.source.scaleY = 0;
         this.source.scaleX = 0;
         this.source.visible = false;
         this._map = new Array();
         this._map.push({
            "_x":-1,
            "_y":-1
         });
         this._map.push({
            "_x":0,
            "_y":-1
         });
         this._map.push({
            "_x":1,
            "_y":-1
         });
         this._map.push({
            "_x":1,
            "_y":0
         });
         this._map.push({
            "_x":1,
            "_y":1
         });
         this._map.push({
            "_x":0,
            "_y":1
         });
         this._map.push({
            "_x":-1,
            "_y":1
         });
         this._map.push({
            "_x":-1,
            "_y":0
         });
         this._map.push({
            "_x":0,
            "_y":0
         });
         this._width = 100;
         this._height = 100;
         var _loc2_:int = 0;
         while(_loc2_ < 9)
         {
            _loc1_ = new Bitmap();
            this["P" + _loc2_.toString()] = _loc1_;
            addChild(_loc1_);
            _loc2_++;
         }
         this.redraw();
      }
      
      private function getMatrix(param1:Number, param2:Number, param3:Rectangle) : Matrix
      {
         var _loc4_:Matrix = new Matrix();
         _loc4_.translate(param1 < 0?Number(Number(param3.left)):param1 > 0?Number(Number(-100)):Number(Number(0)),param2 < 0?Number(Number(param3.top)):param2 > 0?Number(Number(-100)):Number(Number(0)));
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(param1 == 0?Number(Number(this._width / 100)):Number(Number(1)),param2 == 0?Number(Number(this._height / 100)):Number(Number(1)));
         _loc4_.concat(_loc5_);
         return _loc4_;
      }
      
      private function getScreen(param1:Number, param2:Number, param3:Rectangle) : BitmapData
      {
         var _loc4_:Number = param1 < 0?Number(Number(param3.left)):param1 > 0?Number(Number(param3.right)):Number(Number(this._width));
         var _loc5_:Number = param2 < 0?Number(Number(param3.top)):param2 > 0?Number(Number(param3.bottom)):Number(Number(this._height));
         var _loc6_:* = new BitmapData(_loc4_,_loc5_,true,0);
         var _loc7_:* = this.getMatrix(param1,param2,param3);
         _loc6_.draw(this.source,_loc7_,new ColorTransform(),null,null,true);
         return _loc6_;
      }
      
      public function redraw() : *
      {
         var _loc1_:* = undefined;
         this.source.scaleX = this.source.scaleY = 100;
         var _loc2_:int = 0;
         while(_loc2_ < 9)
         {
            if(this["P" + _loc2_].bitmapData)
            {
               this["P" + _loc2_].bitmapData.dispose();
            }
            _loc2_++;
         }
         var _loc3_:* = this.source.getBounds(this.source);
         if(_loc3_.left >= 0)
         {
            _loc3_.left = 0;
         }
         else
         {
            _loc3_.left = -_loc3_.left;
         }
         if(_loc3_.right <= 100)
         {
            _loc3_.right = 0;
         }
         else
         {
            _loc3_.right = _loc3_.right - 100;
         }
         if(_loc3_.top >= 0)
         {
            _loc3_.top = 0;
         }
         else
         {
            _loc3_.top = -_loc3_.top;
         }
         if(_loc3_.bottom <= 100)
         {
            _loc3_.bottom = 0;
         }
         else
         {
            _loc3_.bottom = _loc3_.bottom - 100;
         }
         _loc3_.left = _loc3_.left + 2;
         _loc3_.right = _loc3_.right + 2;
         _loc3_.top = _loc3_.top + 2;
         _loc3_.bottom = _loc3_.bottom + 2;
         var _loc4_:* = new Array();
         _loc2_ = 0;
         while(_loc2_ < 9)
         {
            _loc4_.push(this.getScreen(this._map[_loc2_]._x,this._map[_loc2_]._y,_loc3_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 9)
         {
            _loc1_ = this["P" + _loc2_.toString()];
            _loc1_.bitmapData = _loc4_[_loc2_];
            _loc1_.smoothing = true;
            _loc2_++;
         }
         this.P0.x = -this.P0.width;
         this.P0.y = -this.P0.height;
         this.P1.x = 0;
         this.P1.y = -this.P1.height;
         this.P1.width = this._width;
         this.P2.x = this._width;
         this.P2.y = -this.P2.height;
         this.P3.x = this._width;
         this.P3.y = 0;
         this.P3.height = this._height;
         this.P4.x = this._width;
         this.P4.y = this._height;
         this.P5.x = 0;
         this.P5.y = this._height;
         this.P5.width = this._width;
         this.P6.x = -this.P6.width;
         this.P6.y = this._height;
         this.P7.x = -this.P7.width;
         this.P7.y = 0;
         this.P7.height = this._height;
         this.P8.x = 0;
         this.P8.y = 0;
         this.P8.height = this._height;
         this.P8.width = this._width;
         this.source.scaleX = this.source.scaleY = 0;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = Math.round(param1);
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = Math.round(param1);
      }
   }
}
