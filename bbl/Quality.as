package bbl
{
   import flash.events.EventDispatcher;
   
   public class Quality extends EventDispatcher
   {
       
      
      private var _scrollMode:uint;
      
      private var _rainRateQuality:uint;
      
      private var _graphicQuality:Number;
      
      private var _persoMoveQuality:uint;
      
      private var _generalVolume:Number;
      
      private var _ambiantVolume:Number;
      
      private var _interfaceVolume:Number;
      
      private var _actionVolume:Number;
      
      public var lastPowerTest:uint;
      
      public function Quality()
      {
         super();
         this._scrollMode = 0;
         this._rainRateQuality = 3;
         this._graphicQuality = 3;
         this._persoMoveQuality = 5;
         this._generalVolume = 0.8;
         this._ambiantVolume = 1;
         this._actionVolume = 1;
         this._interfaceVolume = 1;
         this.lastPowerTest = 0;
      }
      
      public function autoDetect() : *
      {
         var _loc1_:* = this.getPower();
         this._scrollMode = _loc1_ > 30000?uint(uint(1)):uint(uint(0));
         this._rainRateQuality = Math.min(Math.max(Math.round((_loc1_ - 30000) / 150000 * 5),1),5);
         this._persoMoveQuality = Math.min(Math.max(Math.round((_loc1_ - 20000) / 70000 * 5),1),5);
         this._graphicQuality = Math.min(Math.max(Math.round((_loc1_ - 10000) / 40000 * 3),2),3);
         this.updateQuality();
         dispatchEvent(new Event("onChanged"));
      }
      
      public function getPower() : uint
      {
         var _loc1_:* = undefined;
         var _loc2_:* = GlobalProperties.getTimer();
         var _loc3_:int = 0;
         while(GlobalProperties.getTimer() < _loc2_ + 500)
         {
            _loc1_ = new Array();
            _loc1_.push("string");
            _loc1_.splice(0,_loc1_.length);
            _loc3_++;
         }
         this.lastPowerTest = _loc3_;
         return _loc3_;
      }
      
      public function updateQuality() : *
      {
         GlobalProperties.stage.quality = this._graphicQuality == 1?"low":this._graphicQuality == 2?"medium":"best";
      }
      
      public function set scrollMode(param1:uint) : *
      {
         this._scrollMode = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get scrollMode() : uint
      {
         return this._scrollMode;
      }
      
      public function set rainRateQuality(param1:uint) : *
      {
         this._rainRateQuality = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get rainRateQuality() : uint
      {
         return this._rainRateQuality;
      }
      
      public function set graphicQuality(param1:uint) : *
      {
         this._graphicQuality = param1;
         this.updateQuality();
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get graphicQuality() : uint
      {
         return this._graphicQuality;
      }
      
      public function set persoMoveQuality(param1:uint) : *
      {
         this._persoMoveQuality = param1;
         dispatchEvent(new Event("onChanged"));
      }
      
      public function get persoMoveQuality() : uint
      {
         return this._persoMoveQuality;
      }
      
      public function set ambiantVolume(param1:Number) : *
      {
         this._ambiantVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get ambiantVolume() : Number
      {
         return this._ambiantVolume;
      }
      
      public function set interfaceVolume(param1:Number) : *
      {
         this._interfaceVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get interfaceVolume() : Number
      {
         return this._interfaceVolume;
      }
      
      public function set actionVolume(param1:Number) : *
      {
         this._actionVolume = param1;
         dispatchEvent(new Event("onSoundChanged"));
      }
      
      public function get actionVolume() : Number
      {
         return this._actionVolume;
      }
      
      public function set generalVolume(param1:Number) : *
      {
         this._generalVolume = param1;
         var _loc2_:* = SoundMixer.soundTransform;
         _loc2_.volume = param1;
         SoundMixer.soundTransform = _loc2_;
      }
      
      public function get generalVolume() : Number
      {
         return this._generalVolume;
      }
   }
}
