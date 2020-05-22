package map
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class EarthQuake
   {
       
      
      public var soundClass:Class;
      
      public var volume:Number;
      
      private var itemList:Array;
      
      private var _target:Sprite;
      
      private var _currentposX:Number;
      
      private var _currentposY:Number;
      
      private var _flip:uint;
      
      private var _sprite:Sprite;
      
      private var _soundChannel:SoundChannel;
      
      public function EarthQuake()
      {
         super();
         this.itemList = new Array();
         this.volume = 1;
         this._sprite = new Sprite();
         this.target = null;
         this._soundChannel = null;
         this._flip = 0;
      }
      
      public function addItem() : EarthQuakeItem
      {
         var _loc1_:* = null;
         var _loc2_:EarthQuakeItem = new EarthQuakeItem();
         this.itemList.push(_loc2_);
         if(this.itemList.length == 1)
         {
            this._sprite.addEventListener(Event.ENTER_FRAME,this.enterf,false,0,true);
            _loc1_ = new this.soundClass();
            this._soundChannel = _loc1_.play(0,9999,new SoundTransform(0));
            if(this._target)
            {
               this._currentposX = this._target.x;
               this._currentposY = this._target.y;
            }
         }
         return _loc2_;
      }
      
      public function stop() : *
      {
         if(this._soundChannel)
         {
            this._soundChannel.stop();
            this._soundChannel = null;
         }
         if(this._target)
         {
            this._target.x = this._currentposX;
            this._target.y = this._currentposY;
         }
         this._sprite.removeEventListener(Event.ENTER_FRAME,this.enterf);
         this.itemList.splice(0,this.itemList.length);
      }
      
      public function enterf(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.itemList.length)
         {
            _loc2_ = this.itemList[_loc5_];
            _loc3_ = (GlobalProperties.serverTime - _loc2_.startAt) / _loc2_.duration;
            if(_loc3_ > 1)
            {
               this.itemList.splice(_loc5_,1);
               _loc5_--;
            }
            else
            {
               _loc2_.curAmplitude = Math.pow(Math.sin(Math.PI * _loc3_),0.6) * _loc2_.amplitude;
               _loc4_ = Number(Math.max(_loc2_.curAmplitude,_loc4_));
            }
            _loc5_++;
         }
         if(this.itemList.length)
         {
            if(this._soundChannel)
            {
               this._soundChannel.soundTransform = new SoundTransform(_loc4_ * 4 * this.volume);
            }
            if(this._target && this._flip % 3 == 0)
            {
               this.target.x = this._currentposX + (Math.random() * 20 - 10) * _loc4_;
               this.target.y = this._currentposY + (Math.random() * 20 - 10) * _loc4_;
            }
            this._flip++;
         }
         else
         {
            this.stop();
         }
      }
      
      public function get target() : Sprite
      {
         return this._target;
      }
      
      public function set target(param1:Sprite) : *
      {
         this._target = param1;
         if(param1)
         {
            this._currentposX = param1.x;
            this._currentposY = param1.y;
         }
      }
   }
}
