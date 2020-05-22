package chatbbl
{
   import engine.JPEGEncoder;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   
   public class PhotoUtilPopup extends MovieClip
   {
       
      
      public var win:Object;
      
      public var image:BitmapData;
      
      public var outImage:BitmapData;
      
      public var viewImage:BitmapData;
      
      public var bt_save:SimpleButton;
      
      public var waiter:Sprite;
      
      public var backBitmap:Bitmap;
      
      public var masque_0:MovieClip;
      
      public var masque_1:MovieClip;
      
      public var masque_2:MovieClip;
      
      public var masqueEtat:Array;
      
      public function PhotoUtilPopup()
      {
         this.masqueEtat = [false,false,false];
         super();
         this.bt_save.addEventListener("click",this.onBtSave);
      }
      
      public function init() : void
      {
         this.backBitmap = new Bitmap(this.image);
         this.backBitmap.scaleX = 0.5;
         this.backBitmap.scaleY = 0.5;
         addChildAt(this.backBitmap,0);
         parent.width = this.backBitmap.width;
         parent.height = this.backBitmap.height + 40;
         Object(parent).redraw();
         Object(parent).addEventListener("onKill",this.onWinKill);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this["masque_" + _loc1_].buttonMode = true;
            this["masque_" + _loc1_].alpha = 0;
            this["masque_" + _loc1_].stop();
            this["masque_" + _loc1_].addEventListener("mouseOver",this.onMasqueOver);
            this["masque_" + _loc1_].addEventListener("mouseOut",this.onMasqueOut);
            this["masque_" + _loc1_].addEventListener("click",this.onMasqueClick);
            _loc1_++;
         }
         this.updatePrise();
      }
      
      public function onMasqueOver(param1:Event) : void
      {
         param1.currentTarget.alpha = 1;
      }
      
      public function onMasqueOut(param1:Event) : void
      {
         param1.currentTarget.alpha = 0;
      }
      
      public function onMasqueClick(param1:Event) : void
      {
         this.masqueEtat[Number(param1.currentTarget.name.split("_")[1])] = !this.masqueEtat[Number(param1.currentTarget.name.split("_")[1])];
         this.updatePrise();
      }
      
      public function onWinKill(param1:Event) : *
      {
         this.setWaiter(false);
      }
      
      public function onBtSave(param1:Event) : *
      {
         var _loc2_:JPEGEncoder = new JPEGEncoder(95);
         var _loc3_:ByteArray = _loc2_.encode(this.outImage);
         var _loc4_:FileReference = new FileReference();
         _loc4_.save(_loc3_,"photo_" + Math.floor(new Date().getTime() / 1000) + ".jpg");
      }
      
      public function updatePrise() : *
      {
         var _loc1_:* = null;
         if(this.viewImage)
         {
            this.viewImage.dispose();
         }
         this.viewImage = new BitmapData(this.image.width,this.image.height,false,0);
         this.viewImage.draw(this.image);
         this.backBitmap.bitmapData = this.viewImage;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this.masqueEtat[_loc3_])
            {
               this["masque_" + _loc3_].gotoAndStop(2);
               _loc1_ = new Matrix();
               _loc1_.scale(this["masque_" + _loc3_].scaleX * 2,this["masque_" + _loc3_].scaleY * 2);
               _loc1_.translate(this["masque_" + _loc3_].x * 2,this["masque_" + _loc3_].y * 2);
               this.viewImage.draw(this["masque_" + _loc3_],_loc1_);
               this["masque_" + _loc3_].gotoAndStop(1);
            }
            else
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         this.outImage = this.viewImage;
         if(_loc2_)
         {
            this.outImage = new BitmapData(this.viewImage.width,this.viewImage.height - 136);
            this.outImage.copyPixels(this.viewImage,this.viewImage.rect,new Point());
         }
      }
      
      public function setWaiter(param1:Boolean) : *
      {
         var _loc2_:* = null;
         _loc2_ = null;
         if(param1 && !this.waiter)
         {
            this.waiter = new Sprite();
            addChild(this.waiter);
            this.waiter.graphics.beginFill(0,0.7);
            this.waiter.graphics.lineTo(parent.width,0);
            this.waiter.graphics.lineTo(parent.width,parent.height);
            this.waiter.graphics.lineTo(0,parent.height);
            this.waiter.graphics.lineTo(0,0);
            this.waiter.graphics.endFill();
            _loc2_ = new photoWaiter();
            _loc2_.x = parent.width / 2;
            _loc2_.y = parent.height / 2;
            this.waiter.addChild(_loc2_);
         }
         else if(!param1 && this.waiter)
         {
            this.waiter.parent.removeChild(this.waiter);
            this.waiter = null;
         }
      }
   }
}
