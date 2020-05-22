package engine
{
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class SyncTimer extends Timer
   {
       
      
      private var _syncTime:Number;
      
      private var _delay:Number;
      
      private var _intervalCount:Number;
      
      private var _timeOffset:Number;
      
      public function SyncTimer(param1:Number, param2:int = 0)
      {
         super(param1,param2);
         addEventListener("timer",this.timerEvent,false,0,true);
         this._delay = param1;
         this.syncTime = new Date().getTime();
      }
      
      public function timerEvent(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = this._syncTime % this._delay;
         var _loc4_:Number = new Date().getTime() - (this._syncTime - _loc3_) - this._timeOffset;
         var _loc5_:Number = _loc4_ / this._delay;
         var _loc6_:Number = Math.floor(_loc5_);
         if(this._intervalCount < _loc6_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc6_ - this._intervalCount)
            {
               this._intervalCount++;
               dispatchEvent(new Event("syncTimer"));
               _loc2_++;
            }
         }
         var _loc7_:int = this._delay - _loc4_ % this._delay;
         if(this._intervalCount > 1)
         {
            _loc7_ = Math.max(Math.min(_loc7_,this._delay + this._delay * 0.5),this._delay - this._delay * 0.5);
         }
         super.delay = _loc7_;
      }
      
      override public function reset() : void
      {
         this.resetSync();
         super.reset();
      }
      
      public function set syncTime(param1:Number) : *
      {
         this._syncTime = param1;
         this._timeOffset = new Date().getTime() - this._syncTime;
         this.resetSync();
      }
      
      public function get syncTime() : Number
      {
         return this._syncTime - this._syncTime % this._delay + this._delay * this._intervalCount;
      }
      
      override public function set delay(param1:Number) : void
      {
         this._delay = param1;
         this.resetSync();
      }
      
      override public function get delay() : Number
      {
         return this._delay;
      }
      
      private function resetSync() : *
      {
         var _loc1_:Number = new Date().getTime() - (this._syncTime - this._syncTime % this._delay) - this._timeOffset;
         this._intervalCount = Math.floor(_loc1_ / this._delay);
         super.delay = Math.round(this._delay - _loc1_ % this._delay);
      }
   }
}
