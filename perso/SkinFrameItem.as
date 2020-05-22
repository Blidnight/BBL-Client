package perso
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SkinFrameItem extends Sprite
   {
       
      
      private var _target:MovieClip;
      
      private var _action:Object;
      
      private var _actionObj:Object;
      
      private var _labelMemory:Object;
      
      public var curPos:uint;
      
      public function SkinFrameItem()
      {
         super();
         this.curPos = 0;
         this._action = {"v":0};
         this._actionObj = null;
      }
      
      public function set action(param1:uint) : *
      {
         this._action = {"v":param1};
         this.curPos = 0;
         this._actionObj = this._labelMemory[param1];
         if(this._actionObj)
         {
            this._target.gotoAndStop(this._actionObj.startAt);
         }
      }
      
      public function nextFrame() : *
      {
         if(this._actionObj && this._actionObj.startAt != this._actionObj.endAt)
         {
            this.curPos++;
            if(this._actionObj.startAt + this.curPos > this._actionObj.endAt)
            {
               this.curPos = 0;
            }
            this._target.gotoAndStop(this._actionObj.startAt + this.curPos);
         }
      }
      
      public function get target() : MovieClip
      {
         return this._target;
      }
      
      public function set target(param1:MovieClip) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this._target = param1;
         this._labelMemory = new Object();
         this._actionObj = null;
         this.curPos = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         while(_loc5_ < this._target.currentLabels.length)
         {
            _loc2_ = this._target.currentLabels[_loc5_].name.split("action_");
            if(_loc2_.length == 2)
            {
               _loc3_ = new Object();
               _loc3_.startAt = this._target.currentLabels[_loc5_].frame;
               if(_loc4_)
               {
                  _loc4_.endAt = _loc3_.startAt - 1;
               }
               this._labelMemory[uint(_loc2_[1])] = _loc3_;
               _loc4_ = _loc3_;
            }
            _loc5_++;
         }
         _loc4_.endAt = this._target.totalFrames;
      }
   }
}
