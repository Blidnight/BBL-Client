package engine
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Bulle extends Sprite
   {
       
      
      public var fontColor:uint;
      
      public var maxWidth:uint;
      
      public var text:String;
      
      public var isHtml:Boolean;
      
      public var textFormat:TextFormat;
      
      public var direction:Boolean;
      
      public var type:uint;
      
      private var textField:TextField;
      
      private var shape:Shape;
      
      private var frameCount:uint;
      
      private var content:Sprite;
      
      public function Bulle()
      {
         super();
         this.content = new Sprite();
         addChild(this.content);
         this.frameCount = 0;
         this.type = 0;
         this.fontColor = 16777215;
         this.maxWidth = 150;
         this.isHtml = false;
         this.direction = true;
         cacheAsBitmap = true;
         this.textFormat = new TextFormat();
         this.textFormat.font = "Arial";
         this.textFormat.size = 10;
      }
      
      public function shakeEvt(param1:Event) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         var _loc3_:* = Number(NaN);
         _loc2_ = 10;
         _loc3_ = 6;
         var _loc5_:Number = 1 - this.frameCount / _loc2_;
         this.content.x = Math.round(Math.random() * _loc3_ * _loc5_);
         this.content.y = Math.round(Math.random() * _loc3_ * _loc5_);
         this.frameCount++;
         if(this.frameCount > _loc2_)
         {
            removeEventListener("enterFrame",this.shakeEvt);
            this.content.x = this.content.y = 0;
         }
      }
      
      public function fadeEvt(param1:Event) : *
      {
         this.content.alpha = this.frameCount / 5;
         this.frameCount++;
         if(this.frameCount > 5)
         {
            removeEventListener("enterFrame",this.fadeEvt);
            this.content.alpha = 1;
         }
      }
      
      public function clear() : *
      {
         this.frameCount = 0;
         removeEventListener("enterFrame",this.shakeEvt);
         removeEventListener("enterFrame",this.fadeEvt);
         while(this.content.numChildren)
         {
            this.content.removeChildAt(0);
         }
      }
      
      public function dispose() : *
      {
         this.clear();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function onLinkEvt(param1:TextEvent) : *
      {
         var _loc2_:TextEvent = new TextEvent("onLink");
         _loc2_.text = param1.text;
         dispatchEvent(_loc2_);
      }
      
      public function redraw() : *
      {
         this.clear();
         this.shape = new Shape();
         this.textField = new TextField();
         this.textField.addEventListener("link",this.onLinkEvt,false);
         this.content.addChild(this.shape);
         this.content.addChild(this.textField);
         if(this.type == 0)
         {
            this.textFormat.bold = this.textFormat.italic = false;
         }
         if(this.type == 1)
         {
            this.textFormat.bold = false;
            this.textFormat.italic = true;
         }
         if(this.type == 2)
         {
            this.textFormat.bold = this.textFormat.italic = false;
         }
         this.textField.selectable = false;
         this.textField.autoSize = "left";
         this.textField.wordWrap = false;
         this.textField.multiline = false;
         this.textField.defaultTextFormat = this.textFormat;
         this.textField.antiAliasType = "advanced";
         this.textField.embedFonts = true;
         if(this.isHtml)
         {
            this.textField.htmlText = this.text;
         }
         else
         {
            this.textField.text = this.text;
         }
         if(this.textField.width > this.maxWidth)
         {
            this.textField.wordWrap = true;
            this.textField.multiline = true;
            this.textField.width = this.maxWidth;
         }
         this.textField.y = -(this.textField.height + 11);
         this.textField.x = !!this.direction?Number(Number(2)):Number(Number(-(this.textField.textWidth + 2)));
         if(this.type == 0)
         {
            this.drawTalk();
         }
         if(this.type == 1)
         {
            this.drawThink();
         }
         if(this.type == 2)
         {
            this.drawScream();
         }
         var _loc1_:DropShadowFilter = new DropShadowFilter(2,45,0,1,4,4,0.5,1);
         this.shape.filters = [_loc1_];
      }
      
      private function drawScream() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Number = NaN;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:* = null;
         addEventListener("enterFrame",this.shakeEvt);
         this.textField.y = this.textField.y - 17;
         this.textField.x = this.textField.x + 10;
         var _loc11_:Rectangle = new Rectangle(7,5,9,5);
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         var _loc12_:Array = new Array();
         _loc12_.push(new Point(this.textField.x - _loc11_.x,this.textField.y - _loc11_.y));
         _loc12_.push(new Point(this.textField.x + this.textField.textWidth + _loc11_.width,this.textField.y - _loc11_.y));
         _loc12_.push(new Point(this.textField.x + this.textField.textWidth + _loc11_.width,this.textField.y + this.textField.height + _loc11_.height));
         _loc12_.push(new Point(this.textField.x - _loc11_.x,this.textField.y + this.textField.height + _loc11_.height));
         var _loc17_:* = null;
         var _loc18_:Array = new Array();
         _loc1_ = 0;
         while(_loc1_ < _loc12_.length)
         {
            _loc2_ = _loc12_[_loc1_];
            _loc3_ = _loc12_[(_loc1_ + 1) % _loc12_.length];
            _loc4_ = new Point(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
            _loc5_ = _loc4_.length;
            _loc4_.normalize(1);
            _loc6_ = new Point(-_loc4_.y,_loc4_.x);
            _loc7_ = new Rectangle(10,10,8,10);
            _loc8_ = 2 * (_loc7_.width + _loc7_.height / 2);
            _loc9_ = _loc5_ / _loc8_;
            if(_loc9_ < 1)
            {
               _loc7_.width = _loc7_.width * _loc9_;
               _loc7_.height = _loc7_.height * _loc9_;
               _loc8_ = 2 * (_loc7_.width + _loc7_.height / 2);
            }
            _loc18_.push(new Point(_loc2_.x - (_loc6_.x + _loc4_.x) * _loc7_.y,_loc2_.y - (_loc6_.y + _loc4_.y) * _loc7_.y));
            _loc18_.push(new Point(_loc2_.x + _loc4_.x * (_loc7_.height / 2),_loc2_.y + _loc4_.y * (_loc7_.height / 2)));
            _loc18_.push(new Point(_loc2_.x + _loc4_.x * (_loc7_.width / 2 + _loc7_.height / 2) - _loc6_.x * _loc7_.x,_loc2_.y + _loc4_.y * (_loc7_.width / 2 + _loc7_.height / 2) - _loc6_.y * _loc7_.x));
            if(!this.direction && Math.round(_loc4_.x) == -1 && Math.round(_loc4_.y) == 0)
            {
               _loc17_ = _loc18_[_loc18_.length - 1];
            }
            _loc18_.push(new Point(_loc2_.x + _loc4_.x * (_loc7_.width + _loc7_.height / 2),_loc2_.y + _loc4_.y * (_loc7_.width + _loc7_.height / 2)));
            _loc18_.push(new Point(_loc3_.x - _loc4_.x * (_loc7_.width + _loc7_.height / 2),_loc3_.y - _loc4_.y * (_loc7_.width + _loc7_.height / 2)));
            _loc18_.push(new Point(_loc3_.x - _loc4_.x * (_loc7_.width / 2 + _loc7_.height / 2) - _loc6_.x * _loc7_.x,_loc3_.y - _loc4_.y * (_loc7_.width / 2 + _loc7_.height / 2) - _loc6_.y * _loc7_.x));
            if(this.direction && Math.round(_loc4_.x) == -1 && Math.round(_loc4_.y) == 0)
            {
               _loc17_ = _loc18_[_loc18_.length - 1];
            }
            _loc18_.push(new Point(_loc3_.x - _loc4_.x * (_loc7_.height / 2),_loc3_.y - _loc4_.y * (_loc7_.height / 2)));
            _loc1_++;
         }
         _loc17_.x = 0;
         _loc17_.y = 0;
         this.shape.graphics.moveTo(_loc18_[0].x,_loc18_[0].y);
         _loc1_ = 0;
         while(_loc1_ < _loc18_.length)
         {
            _loc10_ = _loc18_[_loc1_];
            this.shape.graphics.lineTo(_loc10_.x,_loc10_.y);
            _loc1_++;
         }
      }
      
      private function drawThink() : *
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:Number = NaN;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc11_:Number = NaN;
         var _loc12_:* = null;
         var _loc13_:* = null;
         addEventListener("enterFrame",this.fadeEvt);
         this.textField.y = this.textField.y - 12;
         var _loc14_:Rectangle = new Rectangle(7,5,12,5);
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         var _loc15_:Array = new Array();
         _loc15_.push(new Point(this.textField.x - _loc14_.x,this.textField.y - _loc14_.y));
         _loc15_.push(new Point(this.textField.x + this.textField.textWidth + _loc14_.width,this.textField.y - _loc14_.y));
         _loc15_.push(new Point(this.textField.x + this.textField.textWidth + _loc14_.width,this.textField.y + this.textField.height + _loc14_.height));
         _loc15_.push(new Point(this.textField.x - _loc14_.x,this.textField.y + this.textField.height + _loc14_.height));
         var _loc16_:Array = new Array();
         var _loc17_:Number = this.getDistance(_loc15_[0],_loc15_[1]) * 2 + this.getDistance(_loc15_[1],_loc15_[2]) * 2;
         var _loc18_:* = 0;
         _loc16_.push(0);
         do
         {
            _loc2_ = Math.random() * 20 + 10;
            _loc16_.push(_loc2_ + _loc18_);
            _loc18_ = Number(_loc18_ + _loc2_);
         }
         while(_loc2_ + _loc18_ <= _loc17_ - 10);
         
         var _loc19_:Array = new Array();
         _loc18_ = 0;
         var _loc20_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc15_.length)
         {
            _loc3_ = _loc15_[_loc1_];
            _loc4_ = _loc15_[(_loc1_ + 1) % _loc15_.length];
            _loc5_ = new Point(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
            _loc20_ = Number(_loc20_ + _loc5_.length);
            _loc6_ = _loc5_.clone();
            _loc6_.normalize(1);
            while(_loc18_ < _loc16_.length && _loc16_[_loc18_] <= _loc20_)
            {
               _loc7_ = _loc5_.length - (_loc20_ - _loc16_[_loc18_]);
               _loc19_.push(new Point(_loc3_.x + _loc6_.x * _loc7_,_loc3_.y + _loc6_.y * _loc7_));
               _loc18_++;
            }
            _loc1_++;
         }
         this.shape.graphics.moveTo(_loc19_[0].x,_loc19_[0].y);
         _loc1_ = 0;
         while(_loc1_ < _loc19_.length)
         {
            _loc8_ = _loc19_[_loc1_];
            _loc9_ = _loc19_[(_loc1_ + 1) % _loc19_.length];
            _loc10_ = new Point(_loc9_.x - _loc8_.x,_loc9_.y - _loc8_.y);
            _loc11_ = _loc10_.length / 2;
            _loc11_ = _loc11_ * (Math.random() * 0.5 + 0.5);
            if(_loc8_.x == _loc9_.x || _loc8_.y == _loc9_.y)
            {
            }
            _loc10_.normalize(1);
            _loc12_ = new Point(_loc10_.y,-_loc10_.x);
            _loc13_ = new Point((_loc9_.x + _loc8_.x) / 2,(_loc9_.y + _loc8_.y) / 2);
            this.shape.graphics.curveTo(_loc13_.x + _loc11_ * _loc12_.x,_loc13_.y + _loc11_ * _loc12_.y,_loc9_.x,_loc9_.y);
            _loc1_++;
         }
         this.shape.graphics.drawCircle(0,0,3);
         if(this.direction)
         {
            this.shape.graphics.drawCircle(8,-8,5);
         }
         else
         {
            this.shape.graphics.drawCircle(-8,-8,5);
         }
      }
      
      private function getDistance(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      private function drawTalk(param1:int = 15) : *
      {
         var _loc2_:Rectangle = new Rectangle(2,0,8,0);
         var _loc3_:* = param1;
         if(this.textField.height + _loc2_.height - _loc2_.y < _loc3_ * 2)
         {
            _loc3_ = (this.textField.height + _loc2_.height - _loc2_.y) / 2;
         }
         if(this.textField.textWidth + _loc2_.width - _loc2_.x < _loc3_ * 2)
         {
            _loc3_ = (this.textField.textWidth + _loc2_.width - _loc2_.x) / 2;
         }
         _loc2_.x = _loc2_.x + _loc3_ / 10;
         _loc2_.y = _loc2_.y + _loc3_ / 10;
         _loc2_.width = _loc2_.width + _loc3_ / 10;
         _loc2_.height = _loc2_.height + _loc3_ / 10;
         this.shape.graphics.lineStyle(0,0,0.5,true);
         this.shape.graphics.beginFill(this.fontColor,0.85);
         this.shape.graphics.moveTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width - _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.curveTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y,this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y - _loc2_.y + _loc3_);
         this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         this.shape.graphics.curveTo(this.textField.x + this.textField.textWidth + _loc2_.width,this.textField.y + this.textField.height + _loc2_.height,this.textField.x + this.textField.textWidth + _loc2_.width - _loc3_,this.textField.y + this.textField.height + _loc2_.height);
         var _loc4_:* = 10;
         if(_loc4_ > this.textField.textWidth - _loc3_ * 2)
         {
            _loc4_ = Math.max(this.textField.textWidth - _loc3_ * 2,1);
         }
         if(this.direction)
         {
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc4_ + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.lineTo(0,0);
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height,this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         }
         else
         {
            this.shape.graphics.lineTo(0,0);
            this.shape.graphics.lineTo(this.textField.x + this.textField.textWidth + _loc2_.width - _loc4_ - _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.lineTo(this.textField.x - _loc2_.x + _loc3_,this.textField.y + this.textField.height + _loc2_.height);
            this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height,this.textField.x - _loc2_.x,this.textField.y + this.textField.height + _loc2_.height - _loc3_);
         }
         this.shape.graphics.lineTo(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y + _loc3_);
         this.shape.graphics.curveTo(this.textField.x - _loc2_.x,this.textField.y - _loc2_.y,this.textField.x - _loc2_.x + _loc3_,this.textField.y - _loc2_.y);
         this.shape.graphics.endFill();
      }
   }
}
