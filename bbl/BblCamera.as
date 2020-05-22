package bbl
{
   import flash.events.Event;
   import flash.utils.Timer;
   import map.ServerMap;
   import net.Binary;
   import net.SocketMessageEvent;
   import perso.User;
   
   public class BblCamera extends BblObject
   {
       
      
      public var cameraList:Array;
      
      public var newCamera:CameraMapControl;
      
      public var pseudo:String;
      
      public var worldCount:uint;
      
      public var universCount:uint;
      
      private var socketLockTimer:Timer;
      
      private var socketLocked:Boolean;
      
      public function BblCamera()
      {
         super();
         this.worldCount = 0;
         this.universCount = 0;
         this.socketLocked = false;
         this.cameraList = new Array();
         this.socketLockTimer = new Timer(300);
         this.socketLockTimer.addEventListener("timer",this.socketTimerEvt,false);
      }
      
      public function resetSocketLock() : *
      {
         if(!this.socketLockTimer.running)
         {
            this.socketLockTimer.reset();
            this.socketLockTimer.start();
         }
      }
      
      public function socketUnlock() : *
      {
         var _loc1_:* = undefined;
         this.socketLockTimer.reset();
         if(this.socketLocked)
         {
            this.socketLocked = false;
            _loc1_ = 0;
            while(_loc1_ < this.cameraList.length)
            {
               if(this.cameraList[_loc1_].socketLock)
               {
                  this.cameraList[_loc1_].socketLock = false;
               }
               _loc1_++;
            }
         }
      }
      
      public function socketTimerEvt(param1:Event) : *
      {
         this.socketLockTimer.reset();
         this.socketLocked = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.cameraList.length)
         {
            this.cameraList[_loc2_].socketLock = true;
            _loc2_++;
         }
      }
      
      private function setMuteStateByUID(param1:uint, param2:Boolean) : *
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.cameraList.length)
         {
            _loc3_ = this.cameraList[_loc4_].getUserByUid(param1);
            if(_loc3_)
            {
               _loc3_.mute = param2;
            }
            _loc4_++;
         }
      }
      
      override public function removeMute(param1:uint) : *
      {
         super.removeMute(param1);
         this.setMuteStateByUID(param1,false);
      }
      
      override public function addMute(param1:uint, param2:String) : *
      {
         super.addMute(param1,param2);
         this.setMuteStateByUID(param1,true);
      }
      
      override public function addBlackList(param1:uint, param2:String) : *
      {
         super.addBlackList(param1,param2);
         this.setMuteStateByUID(param1,true);
      }
      
      override public function removeBlackList(param1:uint) : *
      {
         super.removeBlackList(param1);
         this.setMuteStateByUID(param1,false);
      }
      
      public function createMainCamera() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,3);
         _loc1_.bitWriteUnsignedInt(32,"71292223");
         send(_loc1_);
      }
      
      public function createNewCamera(param1:uint = 0) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1);
         send(_loc2_);
      }
      
      public function removeCamera(param1:CameraMapControl) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
         var _loc3_:int = 0;
         while(_loc3_ < this.cameraList.length)
         {
            if(this.cameraList[_loc3_] == param1)
            {
               this.cameraList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         param1.dispose();
         send(_loc2_);
      }
      
      public function moveCameraToMap(param1:CameraMapControl, param2:uint, param3:uint = 0, param4:int = -1) : *
      {
         var _loc5_:* = undefined;
         if(!param1.mainUser)
         {
            _loc5_ = new SocketMessage();
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID,param3);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,param2);
            _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param4 == -1?serverId:param4);
            send(_loc5_);
         }
      }
      
      public function movePersoToMap(param1:CameraMapSocket, param2:uint, param3:Object = null) : *
      {
         var _loc4_:* = undefined;
         if(param1.mainUser)
         {
            if(!param3)
            {
               param3 = new Object();
            }
            if(param3.METHODE == undefined)
            {
               param3.METHODE = 1;
            }
            if(param3.SERVERID == undefined)
            {
               param3.SERVERID = serverId;
            }
            _loc4_ = new SocketMessage();
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,3);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID,param3.METHODE);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID,param1.cameraId);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,param2);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param3.SERVERID);
            param1.mainUser.exportStateToMessage(_loc4_,param3);
            send(_loc4_);
         }
      }
      
      public function getCameraById(param1:uint) : CameraMapControl
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.cameraList.length)
         {
            if(this.cameraList[_loc2_].cameraId == param1)
            {
               return this.cameraList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc13_:* = null;
         var _loc14_:* = null;
         var _loc15_:* = null;
         var _loc16_:Boolean = false;
         var _loc17_:* = null;
         var _loc18_:* = null;
         var _loc19_:* = 0;
         var _loc20_:* = 0;
         var _loc21_:* = 0;
         var _loc22_:* = null;
         var _loc23_:* = null;
         var _loc24_:* = 0;
         var _loc25_:* = 0;
         var _loc26_:* = undefined;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Boolean = true;
         if(param1 == 1)
         {
            if(param2 == 5)
            {
               _loc8_ = param3.message.bitReadBoolean();
               _loc9_ = param3.message.bitReadBoolean();
               _loc10_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc11_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = param3.message.bitReadString();
               _loc13_ = param3.message.bitReadString();
               if(_loc9_ && _loc11_)
               {
                  _loc14_ = getDefinitionByName("chatbbl.application.ConsoleChatUser");
                  _loc15_ = GlobalProperties.mainApplication.winPopup.open({
                     "APP":_loc14_,
                     "ID":"CONSOLEUSERCHAT_" + _loc11_.toString(),
                     "TITLE":"Modérateur : " + _loc7_
                  },{
                     "PSEUDO":_loc7_,
                     "UID":_loc11_
                  });
                  Object(_loc15_.content).addMessage(_loc13_,true);
               }
               if(!isMuted(_loc11_) || _loc9_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this.cameraList.length)
                  {
                     if(this.cameraList[_loc5_].userInterface)
                     {
                        this.cameraList[_loc5_].userInterface.lastMpPseudo = _loc7_;
                        this.cameraList[_loc5_].userInterface.addUserMessage(_loc7_,_loc13_,{
                           "ISHTML":_loc8_,
                           "ISMODO":_loc9_,
                           "PID":_loc10_,
                           "UID":_loc11_,
                           "ISPRIVATE":true
                        });
                     }
                     _loc5_++;
                  }
               }
               if(_loc9_ && _loc13_.match(/^Kické : /))
               {
                  GlobalProperties.mainApplication.closeCauseMsg = _loc7_ + " -- " + _loc13_;
               }
            }
            else if(param2 == 6)
            {
               _loc8_ = param3.message.bitReadBoolean();
               _loc16_ = param3.message.bitReadBoolean();
               _loc13_ = param3.message.bitReadString();
               _loc17_ = null;
               _loc5_ = 0;
               while(_loc5_ < this.cameraList.length)
               {
                  if(this.cameraList[_loc5_].userInterface)
                  {
                     if(!_loc17_)
                     {
                        if(!_loc8_)
                        {
                           _loc17_ = this.cameraList[_loc5_].userInterface.htmlEncode(_loc13_);
                        }
                        else
                        {
                           _loc17_ = _loc13_;
                        }
                     }
                     this.cameraList[_loc5_].userInterface.addLocalMessage("<span class=\'info\'>" + _loc17_ + "</span>");
                     if(_loc17_.match(/envoyer un message sur le forum/))
                     {
                        ExternalInterface.call("bblinfos_setMessages_up",1);
                     }
                  }
                  _loc5_++;
               }
               if(_loc16_)
               {
                  GlobalProperties.mainApplication.addTextAlert(_loc13_,_loc8_);
               }
            }
            else if(param2 == 7)
            {
               this.worldCount = param3.message.bitReadUnsignedInt(16);
               this.universCount = param3.message.bitReadUnsignedInt(16);
               dispatchEvent(new Event("onWorldCounterUpdate"));
               _loc29_ = false;
            }
            else if(param2 == 10)
            {
               _loc18_ = param3.message.bitReadBinaryData();
               param1 = _loc18_.bitReadUnsignedInt(4);
               _loc19_ = uint(param1 == 0?uint(uint(GlobalProperties.BIT_SKIN_ID)):param1 == 1?uint(uint(GlobalProperties.BIT_MAP_ID)):uint(uint(GlobalProperties.BIT_FX_ID)));
               _loc20_ = uint(new Date().getTime() / 1000);
               if(param1 == 0)
               {
                  SkinLoader.cacheVersion = _loc20_;
               }
               else if(param1 == 1)
               {
                  MapLoader.cacheVersion = _loc20_;
               }
               else if(param1 == 2)
               {
                  FxLoader.cacheVersion = _loc20_;
               }
               if(_loc18_.bitReadBoolean())
               {
                  while(_loc18_.bitReadBoolean())
                  {
                     _loc21_ = uint(_loc18_.bitReadUnsignedInt(_loc19_));
                     if(param1 == 0)
                     {
                        SkinLoader.clearById(_loc21_);
                        _loc5_ = 0;
                        while(_loc5_ < this.cameraList.length)
                        {
                           this.cameraList[_loc5_].forceReloadSkinId(_loc21_);
                           _loc5_++;
                        }
                     }
                     else if(param1 == 1)
                     {
                        MapLoader.clearById(_loc21_);
                     }
                     else if(param1 == 2)
                     {
                        FxLoader.clearById(_loc21_);
                     }
                  }
               }
               else if(param1 == 0)
               {
                  SkinLoader.clearAll();
                  _loc5_ = 0;
                  while(_loc5_ < this.cameraList.length)
                  {
                     this.cameraList[_loc5_].forceReloadSkins();
                     _loc5_++;
                  }
               }
               else if(param1 == 1)
               {
                  MapLoader.clearAll();
               }
               else if(param1 == 2)
               {
                  FxLoader.clearAll();
               }
            }
            else if(param2 == 11)
            {
               this.socketUnlock();
            }
            else if(param2 == 14)
            {
               _loc11_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               if(GlobalProperties.data["CONSOLEUSERCHAT_" + _loc11_])
               {
                  GlobalProperties.data["CONSOLEUSERCHAT_" + _loc11_].setAnswerState(false);
               }
            }
            else
            {
               _loc29_ = false;
            }
         }
         else if(param1 == 3)
         {
            if(param2 == 1)
            {
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID));
               this.newCamera = new CameraMapControl();
               this.cameraList.push(this.newCamera);
               this.newCamera.cameraId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
               this.newCamera.blablaland = this;
               this.dispatchEvent(new Event("onNewCamera"));
            }
            else if(param2 == 5)
            {
               _loc22_ = this.getCameraById(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID));
               _loc23_ = new ServerMap();
               _loc23_.id = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
               _loc23_.serverId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
               _loc23_.fileId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
               _loc24_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID));
               if(_loc22_)
               {
                  _loc22_.changeMapStatus(_loc23_,_loc6_,_loc24_);
               }
            }
            else
            {
               _loc29_ = false;
            }
         }
         else if(param1 == 4)
         {
            _loc25_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID));
            _loc5_ = 0;
            while(_loc5_ < this.cameraList.length)
            {
               if(this.cameraList[_loc5_].cameraId == _loc25_)
               {
                  this.cameraList[_loc5_].parsedMessage(param1,param2,param3);
                  break;
               }
               _loc5_++;
            }
         }
         else if(param1 == 5)
         {
            _loc4_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID));
            _loc26_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
            _loc5_ = 0;
            while(_loc5_ < this.cameraList.length)
            {
               _loc27_ = -1;
               _loc28_ = -1;
               if(this.cameraList[_loc5_].nextMap)
               {
                  _loc27_ = this.cameraList[_loc5_].nextMap.id;
                  _loc28_ = this.cameraList[_loc5_].nextMap.serverId;
               }
               if(this.cameraList[_loc5_].mapId == _loc4_ && this.cameraList[_loc5_].serverId == _loc26_ || _loc27_ == _loc4_ && _loc28_ == _loc26_)
               {
                  this.cameraList[_loc5_].parsedMessage(param1,param2,param3.duplicate());
               }
               _loc5_++;
            }
         }
         else
         {
            _loc29_ = false;
         }
         if(!_loc29_)
         {
            super.parsedEventMessage(param1,param2,param3);
         }
      }
   }
}
