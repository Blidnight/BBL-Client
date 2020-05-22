package bbl.hitapi
{
   import bbl.ExternalLoader;
   import engine.CollisionObject;
   import engine.DDpoint;
   import engine.Segment;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Sound;
   import net.Binary;
   import net.SocketMessage;
   import perso.User;
   
   public class HitAPI
   {
      
      public static var pidCount:uint = 1;
       
      
      public var hitList:Array;
      
      public var hitId:uint;
      
      public var camera:Object;
      
      public var floodDuration:uint;
      
      public var hitSelf:Boolean;
      
      public var hitControled:HitData;
      
      public var fromUid:uint;
      
      public var fromFxId:uint;
      
      public var fromMapId:int;
      
      public var fromHitId:uint;
      
      public var walkerHitPush:Point;
      
      public var walkerHitSndClass:Class;
      
      public var walkerHitSndVolume:Number;
      
      public var walkerHitVisualClass:Class;
      
      public var serverFunction:Boolean;
      
      public var serverFunctionData:Binary;
      
      public var maxWalkerHit:int;
      
      public var visualDebug:uint;
      
      public var maxRayLength:uint;
      
      public var checkCollision:Boolean;
      
      public var checkCollisionCloud:Boolean;
      
      public var collisionData:CollisionObject;
      
      public var collisionHitSndClass:Class;
      
      public var collisionHitSndVolume:Number;
      
      public var collisionHitVisualClass:Class;
      
      private var externalLoader:ExternalLoader;
      
      public function HitAPI()
      {
         super();
         this.hitList = new Array();
         this.fromUid = 0;
         this.fromHitId = 0;
         this.fromFxId = 0;
         this.fromMapId = -1;
         this.maxWalkerHit = -1;
         this.hitSelf = false;
         this.walkerHitPush = new Point(0.1,-0.3);
         this.floodDuration = 5000;
         this.serverFunctionData = new Binary();
         this.visualDebug = 0;
         this.maxRayLength = 1200;
         this.checkCollision = true;
         this.checkCollisionCloud = false;
         this.collisionData = null;
         this.collisionHitSndClass = null;
         this.collisionHitSndVolume = 0.5;
         this.collisionHitVisualClass = null;
         this.externalLoader = new ExternalLoader();
         this.externalLoader.load();
         this.walkerHitSndClass = Class(this.externalLoader.getClass("HitCoupSnd"));
         this.walkerHitSndVolume = 0.4;
         this.walkerHitVisualClass = Class(this.externalLoader.getClass("HitImpact"));
         this.updateHitId();
      }
      
      public function updateHitId(param1:int = -1) : *
      {
         if(param1 < 0)
         {
            pidCount++;
            this.hitId = pidCount;
         }
         else
         {
            this.hitId = param1;
         }
      }
      
      public function getUserShield(param1:Object, param2:int = 0) : Object
      {
         var _loc3_:* = undefined;
         if(param1.data.SHIELDLIST)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.data.SHIELDLIST.length)
            {
               if(param1.data.SHIELDLIST[_loc3_].getShieldType(param2))
               {
                  return param1.data.SHIELDLIST[_loc3_];
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public function doHitList() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc7_:* = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:* = null;
         var _loc15_:* = null;
         if(!this.hitList.length)
         {
            return;
         }
         var _loc16_:Boolean = false;
         var _loc17_:Number = GlobalProperties.serverTime;
         var _loc19_:* = (this.camera.peace & 1) == 1;
         if(this.collisionData)
         {
            if(this.collisionHitSndClass)
            {
               _loc2_ = new this.collisionHitSndClass();
               _loc2_.play(0,0,new SoundTransform(this.camera.quality.actionVolume * this.collisionHitSndVolume));
            }
            if(this.collisionHitVisualClass)
            {
               this.collisionData.calculateNormal();
               _loc3_ = new this.collisionHitVisualClass();
               _loc3_.rotation = Math.atan2(this.collisionData.normal.y,this.collisionData.normal.x) * 180 / Math.PI;
               _loc3_.x = this.collisionData.colPoint.x;
               _loc3_.y = this.collisionData.colPoint.y;
               this.camera.userContent.addChild(_loc3_);
            }
         }
         _loc1_ = 0;
         while(_loc1_ < this.hitList.length)
         {
            _loc4_ = this.hitList[_loc1_];
            _loc5_ = _loc4_.walker;
            if(_loc5_.clientControled)
            {
               _loc6_ = this.camera.blablaland.isMuted(this.fromUid);
               _loc7_ = _loc5_.data.WAROPEN;
               _loc8_ = _loc7_ && _loc7_.dead;
               _loc9_ = _loc7_ && _loc7_.waitStart;
               if(this.walkerHitPush && !_loc8_)
               {
                  _loc14_ = this.walkerHitPush.clone();
                  _loc14_.x = _loc14_.x * (_loc4_.vector.x >= 0?1:-1);
                  if(_loc4_.shield || (_loc5_.dodo || _loc19_ || _loc6_) && !_loc7_)
                  {
                     _loc14_.x = 0;
                     _loc14_.y = 0;
                  }
                  if(!_loc7_)
                  {
                     _loc14_.x = 0;
                  }
                  if(_loc14_.x != 0 || _loc14_.y != 0)
                  {
                     if(_loc5_.onFloor)
                     {
                        _loc5_.speed.y = _loc14_.y;
                        _loc5_.speed.x = _loc14_.x;
                        _loc5_.onFloor = false;
                     }
                     else
                     {
                        _loc5_.speed.y = _loc5_.speed.y + _loc14_.y;
                        _loc5_.speed.x = _loc5_.speed.x + _loc14_.x;
                     }
                     _loc5_.accroche = false;
                     this.camera.sendMainUserState();
                  }
               }
               _loc10_ = this.fromUid || this.fromFxId || this.fromMapId >= 0;
               _loc11_ = !_loc5_.dodo && !_loc19_ && !_loc4_.shield && !_loc6_;
               _loc12_ = _loc11_ && (!_loc7_ || this.serverFunction);
               _loc13_ = _loc7_ && !_loc8_ && !_loc9_;
               if(_loc10_ && (_loc12_ || _loc13_))
               {
                  _loc15_ = new SocketMessage();
                  _loc15_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,6);
                  _loc15_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,12);
                  _loc15_.bitWriteUnsignedInt(4,2);
                  _loc15_.bitWriteUnsignedInt(10,_loc4_.distance);
                  if(this.fromUid)
                  {
                     _loc15_.bitWriteUnsignedInt(4,1);
                     _loc15_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,this.fromUid);
                  }
                  if(this.fromFxId)
                  {
                     _loc15_.bitWriteUnsignedInt(4,2);
                     _loc15_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID,this.fromFxId);
                  }
                  if(this.fromMapId >= 0)
                  {
                     _loc15_.bitWriteUnsignedInt(4,3);
                     _loc15_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.fromMapId);
                  }
                  if(this.fromHitId)
                  {
                     _loc15_.bitWriteUnsignedInt(4,4);
                     _loc15_.bitWriteUnsignedInt(3,this.fromHitId);
                  }
                  if(this.serverFunctionData.bitLength)
                  {
                     _loc15_.bitWriteUnsignedInt(4,5);
                     _loc15_.bitWriteBinaryData(this.serverFunctionData);
                  }
                  this.camera.blablaland.send(_loc15_);
               }
            }
            if(_loc4_.shield)
            {
               _loc4_.shield.hitShield();
            }
            else
            {
               if(!_loc16_ && this.walkerHitSndClass)
               {
                  _loc2_ = new this.walkerHitSndClass();
                  _loc2_.play(0,0,new SoundTransform(this.camera.quality.actionVolume * this.walkerHitSndVolume));
                  _loc16_ = true;
               }
               if(this.walkerHitVisualClass)
               {
                  _loc3_ = new this.walkerHitVisualClass();
                  _loc3_.x = _loc4_.impactPoint.x;
                  _loc3_.y = _loc4_.impactPoint.y;
                  _loc5_.parent.addChild(_loc3_);
               }
            }
            this.addHitFlood(_loc5_,_loc17_);
            _loc1_++;
         }
      }
      
      public function getWalkerDirectionVector(param1:User, param2:Point) : Point
      {
         var _loc3_:Point = param2.clone();
         if(!param1.direction)
         {
            _loc3_.x = _loc3_.x * -1;
         }
         return _loc3_;
      }
      
      public function getWalkerPoint(param1:User, param2:Point) : Point
      {
         var _loc3_:Point = param2.clone();
         _loc3_ = this.getWalkerDirectionVector(param1,_loc3_);
         _loc3_.x = _loc3_.x * param1.skinScale;
         _loc3_.y = _loc3_.y * param1.skinScale;
         _loc3_.x = _loc3_.x + param1.position.x;
         _loc3_.y = _loc3_.y + param1.position.y;
         return _loc3_;
      }
      
      public function getWalkerHitDataByPoint(param1:User, param2:Point, param3:uint = 4) : HitData
      {
         var _loc4_:Point = new Point();
         var _loc5_:Number = this.getWalkerCenterRadius(param1,_loc4_);
         if(this.visualDebug)
         {
            this.showDebugByPoint(_loc4_,_loc5_,0.7,255);
         }
         var _loc6_:Number = Point.distance(_loc4_,param2);
         var _loc7_:* = null;
         if(_loc6_ <= param3 + _loc5_ && (this.hitSelf || this.fromUid != param1.userId))
         {
            _loc7_ = new HitData();
            _loc7_.walker = param1;
            _loc7_.walkerRadius = _loc5_;
            _loc7_.walkerPoint = _loc4_;
            _loc7_.hitRadius = param3;
            _loc7_.hitPoint = param2;
            _loc7_.distance = _loc6_;
            _loc7_.shield = this.getUserShield(param1);
         }
         return _loc7_;
      }
      
      public function hitCameraByPoint(param1:Point, param2:uint = 6) : *
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         this.hitList = new Array();
         this.hitControled = null;
         if(this.visualDebug)
         {
            this.showDebugByPoint(param1,param2,0.7,16711680);
         }
         var _loc5_:Number = GlobalProperties.serverTime;
         var _loc6_:int = 0;
         while(_loc6_ < this.camera.userList.length)
         {
            _loc3_ = this.camera.userList[_loc6_];
            if(this.isWalkerFloodReady(_loc3_,_loc5_) && _loc3_.parent && !_loc3_.paused)
            {
               _loc4_ = this.getWalkerHitDataByPoint(_loc3_,param1,param2);
               if(_loc3_.clientControled)
               {
                  this.hitControled = _loc4_;
               }
               if(_loc4_)
               {
                  this.hitList.push(_loc4_);
               }
            }
            _loc6_++;
         }
      }
      
      public function hitCameraByRay(param1:Point, param2:Point, param3:uint = 4) : *
      {
         this.hitCameraBySegment(param1,new Point(param1.x + param2.x * this.maxRayLength,param1.y + param2.y * this.maxRayLength),param3);
      }
      
      public function hitCameraBySegment(param1:Point, param2:Point, param3:uint = 4) : *
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:Number = NaN;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         this.hitList = new Array();
         this.hitControled = null;
         var _loc10_:Number = GlobalProperties.serverTime;
         var _loc11_:* = null;
         var _loc12_:Segment = new Segment();
         _loc12_.init();
         _loc12_.ptA.x = param1.x;
         _loc12_.ptA.y = param1.y;
         _loc12_.ptB.x = param2.x;
         _loc12_.ptB.y = param2.y;
         _loc12_.lineCoef();
         this.collisionData = null;
         if(this.checkCollision && this.camera.physic)
         {
            this.collisionData = this.camera.physic.getSurfaceCollision(_loc12_,this.checkCollisionCloud && _loc12_.a >= 0?this.camera.physic.cloudTile:null);
            if(this.collisionData)
            {
               _loc12_.ptB.x = this.collisionData.colPoint.x;
               _loc12_.ptB.y = this.collisionData.colPoint.y;
               _loc12_.lineCoef();
            }
         }
         if(this.visualDebug)
         {
            this.showDebugBySegment(new Point(_loc12_.ptA.x,_loc12_.ptA.y),new Point(_loc12_.ptB.x,_loc12_.ptB.y),param3);
         }
         var _loc13_:int = 0;
         if(this.maxWalkerHit == -1)
         {
            _loc13_ = -99999;
         }
         var _loc14_:int = 0;
         while(_loc13_ < this.maxWalkerHit && _loc14_ < this.camera.userList.length)
         {
            _loc4_ = this.camera.userList[_loc14_];
            if(this.isWalkerFloodReady(_loc4_,_loc10_) && _loc4_.parent && !_loc4_.paused)
            {
               _loc5_ = new Point();
               _loc6_ = this.getWalkerCenterRadius(_loc4_,_loc5_);
               _loc7_ = _loc12_.orthoProjection(_loc5_.x,_loc5_.y);
               if(_loc12_.pointIsInSegment(_loc7_.x,_loc7_.y))
               {
                  _loc8_ = new Point(_loc7_.x,_loc7_.y);
                  _loc9_ = this.getWalkerHitDataByPoint(_loc4_,_loc8_,param3);
                  if(_loc9_)
                  {
                     if(!_loc11_)
                     {
                        _loc11_ = new Point(param2.x - param1.x,param2.y - param1.y);
                        _loc11_.normalize(1);
                     }
                     _loc9_.vector = _loc11_;
                     _loc13_++;
                     if(_loc4_.clientControled)
                     {
                        this.hitControled = _loc9_;
                     }
                     this.hitList.push(_loc9_);
                  }
               }
            }
            _loc14_++;
         }
      }
      
      private function isWalkerFloodReady(param1:User, param2:Number) : Boolean
      {
         return this.getWalkerLastHit(param1) < param2 - this.floodDuration;
      }
      
      private function getWalkerLastHit(param1:User) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:Object = param1.data["HITAPI"];
         if(_loc3_ && _loc3_["ID_" + this.hitId])
         {
            _loc2_ = Number(_loc3_["ID_" + this.hitId]);
         }
         return _loc2_;
      }
      
      private function addHitFlood(param1:User, param2:Number) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = param1.data["HITAPI"];
         if(!_loc4_)
         {
            _loc4_ = new Object();
            _loc4_.lastClear = param2;
            param1.data["HITAPI"] = _loc4_;
         }
         else if(param1.clientControled && _loc4_.lastClear < param2 - 300000)
         {
            for(_loc3_ in _loc4_)
            {
               if(_loc4_[_loc3_] < param2 - 30000)
               {
                  delete _loc4_[_loc3_];
               }
            }
            _loc4_.lastClear = param2;
         }
         _loc4_["ID_" + this.hitId] = param2;
      }
      
      private function getWalkerCenterRadius(param1:User, param2:Point) : Number
      {
         var _loc3_:Number = param1.skinPhysicHeight / 2;
         param2.x = param1.position.x;
         param2.y = param1.position.y - _loc3_;
         return _loc3_ + 2;
      }
      
      private function showDebugBySegment(param1:Point, param2:Point, param3:int, param4:Number = 0.3, param5:Number = 16776960) : *
      {
         var _loc6_:Sprite = new Sprite();
         _loc6_.name = GlobalProperties.serverTime.toString();
         _loc6_.addEventListener("enterFrame",this.debugEnterFrameEvt);
         this.camera.userContent.addChild(_loc6_);
         _loc6_.graphics.lineStyle(param3 * 2,param5,param4);
         _loc6_.graphics.moveTo(param1.x,param1.y);
         _loc6_.graphics.lineTo(param2.x,param2.y);
      }
      
      private function showDebugByPoint(param1:Point, param2:int, param3:Number = 0.6, param4:Number = 16711680) : *
      {
         var _loc5_:Sprite = new Sprite();
         _loc5_.name = GlobalProperties.serverTime.toString();
         _loc5_.addEventListener("enterFrame",this.debugEnterFrameEvt);
         this.camera.userContent.addChild(_loc5_);
         _loc5_.graphics.lineStyle(2,param4,param3);
         _loc5_.graphics.drawCircle(param1.x,param1.y,param2);
      }
      
      public function debugEnterFrameEvt(param1:Event) : *
      {
         var _loc2_:Number = GlobalProperties.serverTime;
         var _loc3_:Sprite = Sprite(param1.currentTarget);
         if(Number(_loc3_.name) < _loc2_ - this.visualDebug)
         {
            _loc3_.removeEventListener("enterFrame",this.debugEnterFrameEvt);
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
         }
      }
   }
}
