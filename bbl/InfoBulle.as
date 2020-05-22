package bbl
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class InfoBulle extends MovieClip
   {
       
      
      public var txt_bulle:TextField;
      
      public var align:String;
      
      public var durationFactor:Number;
      
      private var _texte:String;
      
      private var _startTime:Number;
      
      public function InfoBulle()
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         super();
         this.durationFactor = 1;
         this.align = "right";
         this._texte = null;
         this._startTime = getTimer();
         addEventListener("enterFrame",this.enterFrameEvt,false,0,true);
         this.mouseEnabled = false;
         this.mouseChildren = false;
         filters = [new DropShadowFilter(4,45,0,1,4,4,0.5)];
         GlobalProperties.mainApplication.addChild(this);
         this.txt_bulle = new TextField();
         var _loc3_:Object = Object(ExternalLoader.external.content).bulleFont;
         if(_loc3_)
         {
            _loc1_ = new _loc3_();
            Font.registerFont(Class(_loc3_));
            _loc2_ = new TextFormat();
            _loc2_.font = _loc1_.fontName;
            _loc2_.align = this.align;
            _loc2_.size = 10;
            _loc2_.color = 0;
            this.txt_bulle.defaultTextFormat = _loc2_;
            this.txt_bulle.antiAliasType = "advanced";
            this.txt_bulle.embedFonts = true;
            this.txt_bulle.mouseEnabled = false;
            this.txt_bulle.multiline = true;
            this.txt_bulle.wordWrap = true;
            this.txt_bulle.alpha = 0.7;
            addChild(this.txt_bulle);
         }
      }
      
      public function redraw() : *
      {
         graphics.clear();
         this.txt_bulle.autoSize = "left";
         this.txt_bulle.wordWrap = false;
         this.txt_bulle.multiline = false;
         this.txt_bulle.text = this.text;
         this.txt_bulle.y = -this.txt_bulle.height - 10;
         graphics.lineStyle(1,16777215,1,true);
         graphics.beginFill(16777215,0.8);
         graphics.drawRoundRect(this.txt_bulle.x - 2,this.txt_bulle.y,this.txt_bulle.width + 4,this.txt_bulle.height,15,15);
         graphics.endFill();
         x = parent.mouseX;
         y = parent.mouseY;
         var _loc1_:Rectangle = this.getBounds(parent);
         if(_loc1_.left < 5)
         {
            x = x + (5 - _loc1_.left);
         }
         if(_loc1_.top < 5)
         {
            y = y + (5 - _loc1_.top);
         }
         if(_loc1_.right > stage.stageWidth - 5)
         {
            x = x - (_loc1_.right - (stage.stageWidth - 5));
         }
         if(_loc1_.bottom > stage.stageHeight - 5)
         {
            y = y - (_loc1_.bottom - (stage.stageHeight - 5));
         }
         x = Math.round(x);
         y = Math.round(y);
      }
      
      public function enterFrameEvt(param1:Event) : *
      {
         var _loc2_:uint = (!!this._texte?this._texte.length * 100:10000) * this.durationFactor;
         if(getTimer() > this._startTime + _loc2_)
         {
            alpha = Math.max(alpha - 0.03,0);
            if(alpha == 0)
            {
               this.dispose();
            }
         }
      }
      
      public function dispose() : *
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         removeEventListener("enterFrame",this.enterFrameEvt,false);
      }
      
      public function get text() : String
      {
         return this._texte;
      }
      
      public function set text(param1:String) : *
      {
         this._startTime = getTimer();
         this._texte = param1;
         this.redraw();
      }
   }
}
