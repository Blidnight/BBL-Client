package net
{
   import flash.utils.ByteArray;
   
   public class Binary extends ByteArray
   {
      
      public static var powList:Array;
      
      public static var __init:Boolean = _init();
       
      
      public var bitLength:Number;
      
      public var bitPosition:Number;
      
      public function Binary()
      {
         super();
         this.bitLength = 0;
         this.bitPosition = 0;
      }
      
      public static function _init() : Boolean
      {
         powList = new Array();
         var _loc1_:int = 0;
         while(_loc1_ <= 32)
         {
            powList.push(Math.pow(2,_loc1_));
            _loc1_++;
         }
         return true;
      }
      
      public function getDebug() : String
      {
         var _loc1_:Array = new Array();
         _loc1_.push(this.bitPosition);
         _loc1_.push(this.bitLength);
         var _loc2_:int = 0;
         while(_loc2_ < length)
         {
            _loc1_.push(this[_loc2_].toString());
            _loc2_++;
         }
         return _loc1_.join("=");
      }
      
      public function setDebug(param1:String) : *
      {
         var _loc2_:Array = param1.split("=");
         this.bitPosition = _loc2_[0];
         this.bitLength = _loc2_[1];
         var _loc3_:int = 2;
         while(_loc3_ < _loc2_.length)
         {
            this.writeByte(Number(_loc2_[_loc3_]));
            _loc3_++;
         }
      }
      
      public function bitReadString() : String
      {
         var _loc1_:* = 0;
         var _loc2_:String = "";
         var _loc3_:* = this.bitReadUnsignedInt(16);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = uint(this.bitReadUnsignedInt(8));
            if(_loc1_ == 255)
            {
               _loc1_ = 8364;
            }
            _loc2_ = _loc2_ + String.fromCharCode(_loc1_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function bitReadBoolean() : Boolean
      {
         if(this.bitPosition == this.bitLength)
         {
            return false;
         }
         var _loc1_:* = Math.floor(this.bitPosition / 8);
         var _loc2_:* = this.bitPosition % 8;
         this.bitPosition++;
         return (this[_loc1_] >> 7 - _loc2_ & 1) == 1;
      }
      
      public function bitReadUnsignedInt(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         if(this.bitPosition + param1 > this.bitLength)
         {
            this.bitPosition = this.bitLength;
            return 0;
         }
         var _loc7_:* = 0;
         var _loc8_:Number = param1;
         while(_loc8_ > 0)
         {
            _loc2_ = Math.floor(this.bitPosition / 8);
            _loc3_ = this.bitPosition % 8;
            _loc4_ = 8 - _loc3_;
            _loc5_ = Math.min(_loc4_,_loc8_);
            _loc6_ = this[_loc2_] >> _loc4_ - _loc5_ & powList[_loc5_] - 1;
            _loc7_ = _loc7_ + _loc6_ * powList[_loc8_ - _loc5_];
            _loc8_ = _loc8_ - _loc5_;
            this.bitPosition = this.bitPosition + _loc5_;
         }
         return _loc7_;
      }
      
      public function bitReadSignedInt(param1:Number) : Number
      {
         var _loc2_:Boolean = this.bitReadBoolean();
         return this.bitReadUnsignedInt(param1 - 1) * (!!_loc2_?1:-1);
      }
      
      public function bitReadBinaryData() : Binary
      {
         var _loc1_:* = this.bitReadUnsignedInt(16);
         return this.bitReadBinary(_loc1_);
      }
      
      public function bitReadBinary(param1:uint) : Binary
      {
         var _loc3_:* = 0;
         var _loc4_:Binary = new Binary();
         var _loc5_:uint = this.bitPosition;
         while(this.bitPosition - _loc5_ < param1)
         {
            if(this.bitPosition == this.bitLength)
            {
               return _loc4_;
            }
            _loc3_ = uint(Math.min(8,param1 - this.bitPosition + _loc5_));
            _loc4_.bitWriteUnsignedInt(_loc3_,this.bitReadUnsignedInt(_loc3_));
         }
         return _loc4_;
      }
      
      public function bitWriteString(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = Math.min(param1.length,powList[16] - 1);
         this.bitWriteUnsignedInt(16,_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = uint(param1.charCodeAt(_loc4_));
            if(_loc2_ == 8364)
            {
               _loc2_ = 255;
            }
            this.bitWriteUnsignedInt(8,_loc2_);
            _loc4_++;
         }
      }
      
      public function bitWriteSignedInt(param1:Number, param2:Number) : void
      {
         this.bitWriteBoolean(param2 >= 0);
         this.bitWriteUnsignedInt(param1 - 1,Math.abs(param2));
      }
      
      public function bitWriteUnsignedInt(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         param2 = Math.min(powList[param1] - 1,param2);
         var _loc7_:Number = param1;
         while(_loc7_ > 0)
         {
            _loc3_ = this.bitLength % 8;
            if(_loc3_ == 0)
            {
               writeBoolean(false);
            }
            _loc4_ = 8 - _loc3_;
            _loc5_ = Math.min(_loc4_,_loc7_);
            _loc6_ = this.Rshift(param2,Number(_loc7_ - _loc5_));
            this[this.length - 1] = this[this.length - 1] + _loc6_ * powList[_loc4_ - _loc5_];
            param2 = param2 - _loc6_ * powList[_loc7_ - _loc5_];
            _loc7_ = _loc7_ - _loc5_;
            this.bitLength = this.bitLength + _loc5_;
         }
      }
      
      public function bitWriteUnsignedIntOLD(param1:Number, param2:Number) : void
      {
         param2 = Math.min(powList[param1] - 1,Math.abs(param2));
         var _loc3_:* = param2.toString(2);
         while(_loc3_.length < param1)
         {
            _loc3_ = "0" + _loc3_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            this.bitWriteBoolean(_loc3_.charAt(_loc4_) == "1");
            _loc4_++;
         }
      }
      
      public function bitWriteBoolean(param1:Boolean) : void
      {
         var _loc2_:Number = this.bitLength % 8;
         if(_loc2_ == 0)
         {
            writeBoolean(false);
         }
         if(param1)
         {
            this[this.length - 1] = this[this.length - 1] + powList[7 - _loc2_];
         }
         this.bitLength++;
      }
      
      public function bitWriteBinaryData(param1:Binary) : void
      {
         var _loc2_:* = Math.min(param1.bitLength,powList[16] - 1);
         this.bitWriteUnsignedInt(16,_loc2_);
         this.bitWriteBinary(param1);
      }
      
      public function bitWriteBinary(param1:Binary) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         param1.bitPosition = 0;
         var _loc4_:uint = param1.bitLength;
         while(_loc4_)
         {
            _loc2_ = uint(Math.min(8,_loc4_));
            _loc3_ = uint(param1.bitReadUnsignedInt(_loc2_));
            this.bitWriteUnsignedInt(_loc2_,_loc3_);
            _loc4_ = _loc4_ - _loc2_;
         }
      }
      
      public function bitCopyObject(param1:Object) : *
      {
         this.bitPosition = param1.bitPosition;
         this.bitLength = param1.bitLength;
         param1.position = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            writeByte(param1.readByte());
            _loc2_++;
         }
      }
      
      public function Rshift(param1:Number, param2:int) : Number
      {
         return Math.floor(param1 / powList[param2]);
      }
      
      public function Lshift(param1:Number, param2:int) : Number
      {
         return param1 * powList[param2];
      }
   }
}
