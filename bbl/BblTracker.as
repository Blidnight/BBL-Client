package bbl
{
   import net.SocketMessage;
   import net.SocketMessageEvent;
   
   public class BblTracker extends BblLoader
   {
       
      
      public var trackerList:Array;
      
      public function BblTracker()
      {
         super();
      }
      
      override public function init() : *
      {
         this.trackerList = new Array();
         super.init();
      }
      
      override public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:* = 0;
         var _loc17_:* = null;
         var _loc18_:* = null;
         var _loc19_:* = null;
         var _loc20_:Boolean = false;
         var _loc21_:* = null;
         if(param1 == 7)
         {
            this.checkForWreakedTracker();
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = 0;
            if(param2 == 4)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc15_ = param3.message.bitReadBoolean();
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               if(_loc4_)
               {
                  while(param3.message.bitReadBoolean())
                  {
                     _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                     _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
                     _loc18_ = this.getUserInTracker(_loc4_,_loc7_,_loc12_);
                     if(!_loc18_)
                     {
                        _loc18_ = new BblTrackerUser();
                        _loc18_.pid = _loc7_;
                        _loc18_.serverId = _loc12_;
                        _loc4_.userList.push(_loc18_);
                     }
                     this.readUserData(param3.message,_loc18_);
                  }
                  if(_loc15_)
                  {
                     _loc4_.mapInformed = true;
                  }
                  _loc4_.informed = true;
                  _loc4_.dispatchEvent(new Event("onChanged"));
               }
            }
            else if(param2 == 2)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               if(_loc4_)
               {
                  _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                  _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_.userList.length)
                  {
                     if(_loc4_.userList[_loc8_].pid == _loc7_ && _loc4_.userList[_loc8_].serverId == _loc12_)
                     {
                        _loc4_.userList.splice(_loc8_,1);
                        _loc8_--;
                     }
                     _loc8_++;
                  }
                  _loc4_.dispatchEvent(new Event("onChanged"));
               }
            }
            else if(param2 == 3)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
               _loc14_ = param3.message.bitReadBoolean();
               _loc13_ = param3.message.bitReadBoolean();
               _loc16_ = uint(param3.message.bitReadUnsignedInt(3));
               _loc17_ = param3.message.bitReadString();
               if(!_loc14_)
               {
                  _loc17_ = this.htmlEncode(_loc17_);
               }
               if(_loc4_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_.userList.length)
                  {
                     if(_loc4_.userList[_loc8_].pid == _loc7_ && _loc4_.userList[_loc8_].serverId == _loc12_)
                     {
                        _loc18_ = _loc4_.userList[_loc8_];
                        _loc19_ = !!_loc13_?"":_loc16_ == 0?"_U":_loc16_ == 1?"_M":"_F";
                        _loc18_.addMessage("--&gt; <span class=\'message" + _loc19_ + (!!_loc13_?"_modo":"") + "\'>" + _loc17_ + "</span>");
                     }
                     _loc8_++;
                  }
                  _loc4_.dispatchEvent(new Event("onMessage"));
               }
            }
            else if(param2 == 5)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
               _loc14_ = param3.message.bitReadBoolean();
               _loc13_ = param3.message.bitReadBoolean();
               _loc20_ = param3.message.bitReadBoolean();
               _loc21_ = this.htmlEncode(param3.message.bitReadString());
               _loc17_ = param3.message.bitReadString();
               if(!_loc14_)
               {
                  _loc17_ = this.htmlEncode(_loc17_);
               }
               if(_loc4_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc4_.userList.length)
                  {
                     if(_loc4_.userList[_loc8_].pid == _loc7_ && _loc4_.userList[_loc8_].serverId == _loc12_)
                     {
                        _loc18_ = _loc4_.userList[_loc8_];
                        _loc18_.addMessage("<span class=\'user" + (!!_loc13_?"_modo":"") + "_mp\'>mp " + (!!_loc20_?"DE":"A") + " " + _loc21_ + "</span> : </span><span class=\'message" + (!!_loc13_?"_modo":"") + "_mp\'>" + _loc17_ + "</span>");
                     }
                     _loc8_++;
                  }
                  _loc4_.dispatchEvent(new Event("onMessage"));
               }
            }
            else if(param2 == 1)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               if(_loc4_)
               {
                  _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                  _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
                  _loc18_ = this.getUserInTracker(_loc4_,_loc7_,_loc12_);
                  if(!_loc18_)
                  {
                     _loc18_ = new BblTrackerUser();
                     _loc4_.userList.push(_loc18_);
                  }
                  this.readUserData(param3.message,_loc18_);
                  _loc18_.pid = _loc7_;
                  _loc18_.serverId = _loc12_;
                  _loc4_.dispatchEvent(new Event("onChanged"));
               }
            }
            else if(param2 == 6)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               if(_loc4_)
               {
                  _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                  _loc12_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID));
                  _loc18_ = this.getUserInTracker(_loc4_,_loc7_,_loc12_);
                  if(!_loc18_)
                  {
                     _loc18_ = new BblTrackerUser();
                     _loc18_.pid = _loc7_;
                     _loc18_.serverId = _loc12_;
                     this.readUserData(param3.message,_loc18_);
                     _loc4_.userList.push(_loc18_);
                  }
                  else
                  {
                     _loc18_.grade = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                  }
                  _loc4_.dispatchEvent(new Event("onChanged"));
               }
            }
            else if(param2 == 7)
            {
               _loc5_ = uint(param3.message.bitReadUnsignedInt(32));
               _loc6_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
               _loc7_ = uint(param3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
               _loc4_ = this.getTrackerByParams(_loc5_,_loc6_,_loc7_);
               if(_loc4_)
               {
                  _loc4_.addTextEvent(this.htmlEncode(param3.message.bitReadString()));
                  _loc4_.dispatchEvent(new Event("onTextEvent"));
               }
            }
         }
         else
         {
            super.parsedEventMessage(param1,param2,param3);
         }
      }
      
      private function readUserData(param1:SocketMessage, param2:BblTrackerUser) : *
      {
         if(param1.bitReadBoolean())
         {
            param2.uid = param1.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
            param2.ip = param1.bitReadUnsignedInt(32);
            param2.grade = param1.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            param2.skinId = param1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
            param2.pseudo = param1.bitReadString();
            param2.login = param1.bitReadString();
            param2.skinColor = new SkinColor();
            param2.skinColor.readBinaryColor(param1);
         }
         if(param1.bitReadBoolean())
         {
            param2.mapId = param1.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
         }
      }
      
      private function htmlEncode(param1:String) : String
      {
         return param1.split("&").join("&amp;").split("<").join("&lt;");
      }
      
      public function checkForWreakedTracker() : *
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.trackerList.length)
         {
            if(!this.trackerList[_loc1_].hasEventListener("onChanged"))
            {
               this.removeTrackerInstance(this.trackerList[_loc1_]);
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      private function removeTrackerInstance(param1:BblTrackerInstance) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         while(_loc3_ < this.trackerList.length)
         {
            if(this.trackerList[_loc3_] == param1)
            {
               _loc2_ = new SocketMessage();
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,5);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
               _loc2_.bitWriteUnsignedInt(32,param1.ip);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,param1.uid);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param1.pid);
               send(_loc2_);
               this.trackerList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function unRegisterTracker(param1:Tracker) : *
      {
         if(param1.trackerInstance)
         {
            param1.trackerInstance.nbInstance--;
            if(param1.mapInform)
            {
               param1.trackerInstance.nbMapInform--;
            }
            if(param1.msgInform)
            {
               param1.trackerInstance.nbMsgInform--;
            }
            if(param1.trackerInstance.nbInstance <= 0)
            {
               this.removeTrackerInstance(param1.trackerInstance);
            }
            else if(param1.mapInform && param1.trackerInstance.nbMapInform == 0 || param1.msgInform && param1.trackerInstance.nbMsgInform == 0)
            {
               this.informServer(param1.ip,param1.uid,param1.pid,param1.trackerInstance.nbMapInform > 0,param1.trackerInstance.nbMsgInform > 0);
            }
            if(param1.trackerInstance.nbMapInform == 0)
            {
               param1.trackerInstance.mapInformed = false;
            }
            param1.trackerInstance = null;
         }
      }
      
      public function informServer(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Boolean) : *
      {
         var _loc6_:* = new SocketMessage();
         _loc6_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,5);
         _loc6_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc6_.bitWriteUnsignedInt(32,param1);
         _loc6_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,param2);
         _loc6_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param3);
         _loc6_.bitWriteBoolean(param4);
         _loc6_.bitWriteBoolean(param5);
         send(_loc6_);
      }
      
      public function registerTracker(param1:Tracker) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = null;
         if(!param1.trackerInstance)
         {
            _loc2_ = false;
            _loc3_ = this.getTrackerByParams(param1.ip,param1.uid,param1.pid);
            if(!_loc3_)
            {
               _loc3_ = new BblTrackerInstance();
               _loc3_.ip = param1.ip;
               _loc3_.uid = param1.uid;
               _loc3_.pid = param1.pid;
               this.trackerList.push(_loc3_);
               _loc2_ = true;
            }
            if(_loc3_.nbMapInform == 0 && param1.mapInform || _loc3_.nbMsgInform == 0 && param1.msgInform)
            {
               _loc2_ = true;
            }
            if(param1.mapInform)
            {
               _loc3_.nbMapInform++;
            }
            if(param1.msgInform)
            {
               _loc3_.nbMsgInform++;
            }
            if(_loc2_)
            {
               this.informServer(param1.ip,param1.uid,param1.pid,param1.mapInform,param1.msgInform);
            }
            param1.trackerInstance = _loc3_;
            _loc3_.nbInstance++;
            if(_loc3_.informed && (!param1.mapInform || _loc3_.mapInformed))
            {
               param1.dispatchEvent(new Event("onChanged"));
            }
            this.checkForWreakedTracker();
         }
      }
      
      public function getUserInTracker(param1:BblTrackerInstance, param2:uint, param3:uint) : BblTrackerUser
      {
         var _loc4_:int = 0;
         while(_loc4_ < param1.userList.length)
         {
            if(param1.userList[_loc4_].pid == param2 && param1.userList[_loc4_].serverId == param3)
            {
               return param1.userList[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getTrackerByParams(param1:uint, param2:uint, param3:uint) : BblTrackerInstance
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.trackerList.length)
         {
            if(this.trackerList[_loc4_].ip == param1 && this.trackerList[_loc4_].uid == param2 && this.trackerList[_loc4_].pid == param3)
            {
               return this.trackerList[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
   }
}
