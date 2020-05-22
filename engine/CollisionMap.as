package engine
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CollisionMap extends EventDispatcher
   {
       
      
      public var collisionBodyList:Array;
      
      public var environmentBodyList:Array;
      
      private var cbCount:uint;
      
      private var ebCount:uint;
      
      public function CollisionMap()
      {
         super();
         this.collisionBodyList = new Array();
         this.environmentBodyList = new Array();
         this.clearAllSurfaceBody();
      }
      
      public function clearAllSurfaceBody() : *
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.collisionBodyList.length)
         {
            this.collisionBodyList[_loc1_].dispose();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.environmentBodyList.length)
         {
            this.environmentBodyList[_loc1_].dispose();
            _loc1_++;
         }
         this.collisionBodyList.splice(0,this.collisionBodyList.length);
         this.environmentBodyList.splice(0,this.environmentBodyList.length);
         this.cbCount = 0;
         this.ebCount = 0;
      }
      
      public function dispose() : *
      {
         this.clearAllSurfaceBody();
      }
      
      public function getCollisionBodyById(param1:uint) : PhysicBody
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc2_].id == param1)
            {
               return this.collisionBodyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addCollisionBody() : PhysicBody
      {
         var _loc1_:* = new PhysicBody();
         _loc1_.id = this.cbCount;
         this.collisionBodyList.push(_loc1_);
         _loc1_.addEventListener("onMove",this.onCollisionBodyMove,false,0,true);
         this.cbCount++;
         return _loc1_;
      }
      
      public function onCollisionBodyMove(param1:Event) : *
      {
         var _loc2_:PhysicBodyEvent = new PhysicBodyEvent("onCollisionBodyMove");
         _loc2_.body = PhysicBody(param1.currentTarget);
         dispatchEvent(_loc2_);
      }
      
      public function removeCollisionBody(param1:PhysicBody) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc2_] == param1)
            {
               this.collisionBodyList[_loc2_].removeEventListener("onMove",this.onCollisionBodyMove,false);
               this.collisionBodyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getEnvironmentBodyById(param1:uint) : PhysicBody
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.environmentBodyList.length)
         {
            if(this.environmentBodyList[_loc2_].id == param1)
            {
               return this.environmentBodyList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addEnvironmentBody() : PhysicBody
      {
         var _loc1_:* = new PhysicBody();
         _loc1_.id = this.ebCount;
         this.environmentBodyList.push(_loc1_);
         _loc1_.addEventListener("onMove",this.onEnvironmentBodyMove,false,0,true);
         this.ebCount++;
         return _loc1_;
      }
      
      public function onEnvironmentBodyMove(param1:Event) : *
      {
         var _loc2_:PhysicBodyEvent = new PhysicBodyEvent("onEnvironmentBodyMove");
         _loc2_.body = PhysicBody(param1.currentTarget);
         dispatchEvent(_loc2_);
      }
      
      public function removeEnvironmentBody(param1:PhysicBody) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.environmentBodyList.length)
         {
            if(this.environmentBodyList[_loc2_] == param1)
            {
               this.environmentBodyList[_loc2_].removeEventListener("onMove",this.onEnvironmentBodyMove,false);
               this.environmentBodyList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function updateCollisionMap(param1:DisplayObject, param2:Number, param3:Number) : *
      {
         var _loc4_:* = null;
         var _loc5_:PhysicBody = this.getCollisionBodyById(0);
         if(_loc5_)
         {
            _loc5_.map.dispose();
            _loc5_.map = new MultiBitmapData(param2,param3,true,0);
            _loc4_ = GlobalProperties.stage.quality;
            GlobalProperties.stage.quality = "low";
            _loc5_.map.draw(param1);
            GlobalProperties.stage.quality = _loc4_;
         }
      }
      
      public function readMap(param1:DisplayObject, param2:DisplayObject, param3:Number, param4:Number) : *
      {
         var _loc5_:String = GlobalProperties.stage.quality;
         GlobalProperties.stage.quality = "low";
         this.dispose();
         var _loc6_:PhysicBody = this.addCollisionBody();
         _loc6_.map = new MultiBitmapData(param3,param4,true,0);
         _loc6_.map.draw(param1);
         _loc6_ = this.addEnvironmentBody();
         _loc6_.map = new MultiBitmapData(param3,param4,true,0);
         _loc6_.map.draw(param2);
         GlobalProperties.stage.quality = _loc5_;
      }
      
      public function getEnvironmentPixelData(param1:Number, param2:Number) : Object
      {
         var _loc3_:* = 0;
         var _loc4_:Object = new Object();
         _loc4_.pxl = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.environmentBodyList.length)
         {
            if(this.environmentBodyList[_loc5_].map && this.environmentBodyList[_loc5_].solid)
            {
               _loc3_ = uint(this.environmentBodyList[_loc5_].map.getPixel(param1 - Math.floor(this.environmentBodyList[_loc5_].position.x),param2 - Math.floor(this.environmentBodyList[_loc5_].position.y)));
               if(_loc3_)
               {
                  _loc4_.pxl = _loc3_;
                  _loc4_.body = this.environmentBodyList[_loc5_];
                  return _loc4_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getCollisionPixelData(param1:Number, param2:Number) : Object
      {
         var _loc3_:* = 0;
         var _loc4_:Object = new Object();
         _loc4_.pxl = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc5_].map && this.collisionBodyList[_loc5_].solid)
            {
               _loc3_ = uint(this.collisionBodyList[_loc5_].map.getPixel(param1 - Math.floor(this.collisionBodyList[_loc5_].position.x),param2 - Math.floor(this.collisionBodyList[_loc5_].position.y)));
               if(_loc3_)
               {
                  _loc4_.pxl = _loc3_;
                  _loc4_.body = this.collisionBodyList[_loc5_];
                  return _loc4_;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getSurfaceCollision(param1:Segment, param2:Object = null) : CollisionObject
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.collisionBodyList.length)
         {
            if(this.collisionBodyList[_loc4_].map && this.collisionBodyList[_loc4_].solid)
            {
               _loc3_ = this.getSingleSurfaceCollision(this.collisionBodyList[_loc4_],param1,param2);
               if(_loc3_)
               {
                  return _loc3_;
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getSingleSurfaceCollision(param1:PhysicBody, param2:Segment, param3:*) : CollisionObject
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = Number(NaN);
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!param3)
         {
            param3 = new Object();
         }
         var _loc11_:DDpoint = param1.position.duplicate();
         _loc11_.x = Math.floor(_loc11_.x);
         _loc11_.y = Math.floor(_loc11_.y);
         var _loc12_:* = null;
         var _loc13_:DDpoint = new DDpoint();
         _loc13_.x = Math.floor(param2.ptA.x);
         _loc13_.y = Math.floor(param2.ptA.y);
         var _loc14_:Number = Math.floor(param2.ptA.x);
         var _loc15_:Number = Math.floor(param2.ptA.y);
         var _loc16_:Number = Math.floor(param2.ptB.x);
         var _loc17_:Number = Math.floor(param2.ptB.y);
         if(_loc14_ < _loc11_.x && _loc16_ < _loc11_.x)
         {
            return null;
         }
         if(_loc15_ < _loc11_.y && _loc17_ < _loc11_.y)
         {
            return null;
         }
         if(_loc14_ > param1.map.width + _loc11_.x && _loc16_ > param1.map.width + _loc11_.x)
         {
            return null;
         }
         if(_loc15_ > param1.map.height + _loc11_.y && _loc17_ > param1.map.height + _loc11_.y)
         {
            return null;
         }
         if(_loc14_ == _loc16_ && _loc15_ == _loc17_)
         {
            return null;
         }
         var _loc18_:Number = param1.map.getPixel(_loc14_ - _loc11_.x,_loc15_ - _loc11_.y);
         var _loc19_:* = 0;
         if(_loc18_)
         {
            _loc19_ = Number(_loc18_);
         }
         if(param2.ptA.x == param2.ptB.x)
         {
            if(_loc15_ < _loc17_)
            {
               _loc4_ = _loc15_;
               while(true)
               {
                  if(_loc4_ <= _loc17_)
                  {
                     _loc18_ = param1.map.getPixel(_loc14_ - _loc11_.x,_loc4_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = 0;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc14_;
                        _loc12_.colPixel.y = _loc4_;
                        _loc12_.colPoint.x = param2.ptA.x;
                        _loc12_.colPoint.y = _loc4_;
                     }
                     else
                     {
                        _loc13_.x = _loc14_;
                        _loc13_.y = _loc4_;
                        _loc4_++;
                        continue;
                     }
                  }
               }
            }
            else
            {
               _loc4_ = _loc15_;
               while(true)
               {
                  if(_loc4_ >= _loc17_)
                  {
                     _loc18_ = param1.map.getPixel(_loc14_ - _loc11_.x,_loc4_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = 2;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc14_;
                        _loc12_.colPixel.y = _loc4_;
                        _loc12_.colPoint.x = param2.ptA.x;
                        _loc12_.colPoint.y = _loc4_ + 1;
                     }
                     else
                     {
                        _loc13_.x = _loc14_;
                        _loc13_.y = _loc4_;
                        _loc4_--;
                        continue;
                     }
                  }
               }
            }
         }
         else if(param2.ptA.y == param2.ptB.y)
         {
            if(_loc14_ < _loc16_)
            {
               _loc4_ = _loc14_;
               while(true)
               {
                  if(_loc4_ <= _loc16_)
                  {
                     _loc18_ = param1.map.getPixel(_loc4_ - _loc11_.x,_loc15_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = 3;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc4_;
                        _loc12_.colPixel.y = _loc15_;
                        _loc12_.colPoint.x = _loc4_;
                        _loc12_.colPoint.y = param2.ptA.y;
                     }
                     else
                     {
                        _loc13_.x = _loc4_;
                        _loc13_.y = _loc15_;
                        _loc4_++;
                        continue;
                     }
                  }
               }
            }
            else
            {
               _loc4_ = _loc14_;
               while(true)
               {
                  if(_loc4_ >= _loc16_)
                  {
                     _loc18_ = param1.map.getPixel(_loc4_ - _loc11_.x,_loc15_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = 1;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc4_;
                        _loc12_.colPixel.y = _loc15_;
                        _loc12_.colPoint.x = _loc4_ + 1;
                        _loc12_.colPoint.y = param2.ptA.y;
                     }
                     else
                     {
                        _loc13_.x = _loc4_;
                        _loc13_.y = _loc15_;
                        _loc4_--;
                        continue;
                     }
                  }
               }
            }
         }
         else
         {
            _loc5_ = param2.a;
            _loc6_ = param2.b;
            _loc7_ = 0;
            _loc8_ = _loc14_;
            _loc9_ = _loc15_;
            if(param2.ptB.x > param2.ptA.x && param2.ptB.y > param2.ptA.y)
            {
               while(true)
               {
                  if(_loc8_ <= _loc16_ && _loc9_ <= _loc17_)
                  {
                     _loc13_.x = _loc8_;
                     _loc13_.y = _loc9_;
                     _loc10_ = _loc5_ * (_loc8_ + 1) + _loc6_;
                     if(_loc10_ > _loc9_ + 1)
                     {
                        _loc9_++;
                        _loc7_ = 0;
                     }
                     else
                     {
                        _loc8_++;
                        _loc7_ = 3;
                     }
                     _loc18_ = param1.map.getPixel(_loc8_ - _loc11_.x,_loc9_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = _loc7_;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc8_;
                        _loc12_.colPixel.y = _loc9_;
                        if(_loc7_ == 0)
                        {
                           _loc12_.colPoint.x = (_loc9_ - _loc6_) / _loc5_;
                           _loc12_.colPoint.y = _loc9_;
                        }
                        else
                        {
                           _loc12_.colPoint.x = _loc8_;
                           _loc12_.colPoint.y = _loc10_;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
               }
            }
            else if(param2.ptB.x < param2.ptA.x && param2.ptB.y > param2.ptA.y)
            {
               while(true)
               {
                  if(_loc8_ >= _loc16_ && _loc9_ <= _loc17_)
                  {
                     _loc13_.x = _loc8_;
                     _loc13_.y = _loc9_;
                     _loc10_ = _loc5_ * _loc8_ + _loc6_;
                     if(_loc10_ >= _loc9_ + 1)
                     {
                        _loc9_++;
                        _loc7_ = 0;
                     }
                     else
                     {
                        _loc8_--;
                        _loc7_ = 1;
                     }
                     _loc18_ = param1.map.getPixel(_loc8_ - _loc11_.x,_loc9_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = _loc7_;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc8_;
                        _loc12_.colPixel.y = _loc9_;
                        if(_loc7_ == 0)
                        {
                           _loc12_.colPoint.x = (_loc9_ - _loc6_) / _loc5_;
                           _loc12_.colPoint.y = _loc9_;
                        }
                        else
                        {
                           _loc12_.colPoint.x = _loc8_ + 1;
                           _loc12_.colPoint.y = _loc10_;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
               }
            }
            else if(param2.ptB.x < param2.ptA.x && param2.ptB.y < param2.ptA.y)
            {
               while(true)
               {
                  if(_loc8_ >= _loc16_ && _loc9_ >= _loc17_)
                  {
                     _loc13_.x = _loc8_;
                     _loc13_.y = _loc9_;
                     _loc10_ = _loc5_ * _loc8_ + _loc6_;
                     if(_loc10_ > _loc9_)
                     {
                        _loc8_--;
                        _loc7_ = 1;
                     }
                     else
                     {
                        _loc9_--;
                        _loc7_ = 2;
                     }
                     _loc18_ = param1.map.getPixel(_loc8_ - _loc11_.x,_loc9_ - _loc11_.y);
                     if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                     {
                        _loc12_ = new CollisionObject();
                        _loc12_.colPoint = new DDpoint();
                        _loc12_.colPixel = new DDpoint();
                        _loc12_.lastPixel = _loc13_;
                        _loc12_.collisionBody = param1;
                        _loc12_.originalSegment = param2;
                        _loc12_.color = _loc18_;
                        _loc12_.faceNum = _loc7_;
                        _loc12_.exclude = param3;
                        _loc12_.colPixel.x = _loc8_;
                        _loc12_.colPixel.y = _loc9_;
                        if(_loc7_ == 1)
                        {
                           _loc12_.colPoint.x = _loc8_ + 1;
                           _loc12_.colPoint.y = _loc10_;
                        }
                        else
                        {
                           _loc12_.colPoint.x = (_loc9_ + 1 - _loc6_) / _loc5_;
                           _loc12_.colPoint.y = _loc9_ + 1;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
               }
            }
            else if(param2.ptB.x > param2.ptA.x && param2.ptB.y < param2.ptA.y)
            {
               while(_loc8_ <= _loc16_ && _loc9_ >= _loc17_)
               {
                  _loc13_.x = _loc8_;
                  _loc13_.y = _loc9_;
                  _loc10_ = _loc5_ * (_loc8_ + 1) + _loc6_;
                  if(_loc10_ >= _loc9_)
                  {
                     _loc8_++;
                     _loc7_ = 3;
                  }
                  else
                  {
                     _loc9_--;
                     _loc7_ = 2;
                  }
                  _loc18_ = param1.map.getPixel(_loc8_ - _loc11_.x,_loc9_ - _loc11_.y);
                  if(_loc18_ != 0 && _loc18_ != _loc19_ && !param3[String(_loc18_)])
                  {
                     _loc12_ = new CollisionObject();
                     _loc12_.colPoint = new DDpoint();
                     _loc12_.colPixel = new DDpoint();
                     _loc12_.lastPixel = _loc13_;
                     _loc12_.collisionBody = param1;
                     _loc12_.originalSegment = param2;
                     _loc12_.color = _loc18_;
                     _loc12_.faceNum = _loc7_;
                     _loc12_.exclude = param3;
                     _loc12_.colPixel.x = _loc8_;
                     _loc12_.colPixel.y = _loc9_;
                     if(_loc7_ == 3)
                     {
                        _loc12_.colPoint.x = _loc8_;
                        _loc12_.colPoint.y = _loc10_;
                        break;
                     }
                     _loc12_.colPoint.x = (_loc9_ + 1 - _loc6_) / _loc5_;
                     _loc12_.colPoint.y = _loc9_ + 1;
                     break;
                  }
               }
            }
         }
         if(_loc12_)
         {
            if(_loc12_.lastPixel.x < 0 || _loc12_.lastPixel.y < 0)
            {
               _loc12_ = null;
            }
         }
         return _loc12_;
      }
   }
}
