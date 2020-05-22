package chatbbl
{
   import bbl.Contact;
   import bbl.ContactEvent;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import fx.FxLoader;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   
   public class ChatContact extends ChatInterface
   {
       
      
      public function ChatContact()
      {
         super();
      }
      
      override public function initBlablaland() : *
      {
         super.initBlablaland();
         blablaland.addEventListener("onRemoveFriend",this.onFriendRemoved,false);
         blablaland.addEventListener("onFriendAdded",this.onFriendAdded,false);
         blablaland.addEventListener("onParsedMessage",this.onInterfaceMessage,false);
         blablaland.addEventListener("onFriendListChange",this.onFriendListChange,false);
      }
      
      override public function close() : *
      {
         if(blablaland)
         {
            blablaland.removeEventListener("onRemoveFriend",this.onFriendRemoved,false);
            blablaland.removeEventListener("onFriendAdded",this.onFriendAdded,false);
            blablaland.removeEventListener("onParsedMessage",this.onInterfaceMessage,false);
            blablaland.removeEventListener("onFriendListChange",this.onFriendListChange,false);
         }
         super.close();
      }
      
      override public function onGetCamera(param1:Event) : *
      {
         super.onGetCamera(param1);
         if(camera && GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN)
         {
            openFriendList();
         }
      }
      
      public function removeBlackList(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Contact = blablaland.getBlackListByUID(param1);
         if(_loc5_)
         {
            _loc2_ = new URLVariables();
            _loc2_.CACHE = new Date().getTime();
            _loc2_.ACTION = 5;
            _loc2_.PARAMS = "SESSION=" + session + "&TARGETID=" + param1;
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "/chat/contactManager.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            _loc4_ = new URLLoader();
            _loc4_.dataFormat = "variables";
            _loc4_.load(_loc3_);
            userInterface.addLocalMessage("<span class=\'info\'>Ce blabla n\'est plus back listé :).</span>");
         }
      }
      
      public function addBlackList(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Contact = blablaland.getBlackListByUID(param1);
         if(!_loc5_)
         {
            _loc2_ = new URLVariables();
            _loc2_.CACHE = new Date().getTime();
            _loc2_.ACTION = 4;
            _loc2_.PARAMS = "SESSION=" + session + "&TARGETID=" + param1;
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "/chat/contactManager.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            _loc4_ = new URLLoader();
            _loc4_.dataFormat = "variables";
            _loc4_.load(_loc3_);
            _loc4_.addEventListener("complete",this.addBlackListMessage,false,0,true);
         }
      }
      
      public function addBlackListMessage(param1:Event) : *
      {
         var _loc2_:uint = Number(param1.currentTarget.data.RES);
         var _loc3_:String = param1.currentTarget.data.ERROR;
         if(_loc2_ && !_loc3_)
         {
            userInterface.addLocalMessage("<span class=\'info\'>Blabla black listé ^^</span>");
         }
         else if(!_loc2_ && _loc3_ == "BLACK_LISTED")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Ce blabla est déja dans ta black list :).</span>");
         }
         else if(!_loc2_ && _loc3_ == "BLACK_LIST_FULL")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible, ta black liste est pleine :/.</span>");
         }
      }
      
      public function removeMute(param1:uint) : *
      {
         blablaland.removeMute(param1);
      }
      
      public function addMute(param1:uint, param2:String) : *
      {
         blablaland.addMute(param1,param2);
      }
      
      public function removeFriend(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Contact = blablaland.getFriendByUID(param1);
         if(_loc5_)
         {
            _loc2_ = new URLVariables();
            _loc2_.CACHE = new Date().getTime();
            _loc2_.ACTION = 3;
            _loc2_.PARAMS = "SESSION=" + session + "&TARGETID=" + param1;
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "/chat/contactManager.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            _loc4_ = new URLLoader();
            _loc4_.dataFormat = "variables";
            _loc4_.load(_loc3_);
         }
      }
      
      public function addFriend(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:Contact = blablaland.getFriendByUID(param1);
         if(!_loc5_)
         {
            _loc2_ = new URLVariables();
            _loc2_.CACHE = new Date().getTime();
            _loc2_.ACTION = 1;
            _loc2_.PARAMS = "SESSION=" + session + "&TARGETID=" + param1;
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "/chat/contactManager.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            _loc4_ = new URLLoader();
            _loc4_.dataFormat = "variables";
            _loc4_.load(_loc3_);
            _loc4_.addEventListener("complete",this.addFriendMessage,false,0,true);
         }
      }
      
      public function addFriendMessage(param1:Event) : *
      {
         var _loc2_:uint = Number(param1.currentTarget.data.RES);
         var _loc3_:String = param1.currentTarget.data.ERROR;
         var _loc4_:String = param1.currentTarget.data.INFO;
         if(_loc2_ && !_loc3_ && !_loc4_)
         {
            userInterface.addLocalMessage("<span class=\'info\'>Demande d\'ajout à la liste d\'amis transmise.</span>");
         }
         else if(!_loc2_ && _loc3_ == "PENDING")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Tu as déja fais cette demande d\'amis. Tu dois attendre que le blabla réponde.</span>");
         }
         else if(!_loc2_ && _loc3_ == "FRIEND_LISTED")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Ce blabla est déja dans ta liste d\'amis ^^.</span>");
         }
         else if(!_loc2_ && _loc3_ == "BLACK_LISTED")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible de faire la demande, tu es dans la black liste de ce blabla.</span>");
         }
         else if(!_loc2_ && _loc3_ == "FROM_LIST_FULL")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible, ta liste d\'amis est pleine :/.</span>");
         }
         else if(!_loc2_ && _loc3_ == "TARGET_LIST_FULL")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible, sa liste d\'amis est pleine.</span>");
         }
         else if(!_loc2_ && _loc3_ == "SELF_INVIT")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible de s\'inviter soi-même !!</span>");
         }
      }
      
      public function answerFriendAsk(param1:Boolean, param2:uint, param3:String) : *
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:Contact = blablaland.getFriendByUID(param2);
         if(!_loc7_)
         {
            _loc4_ = new URLVariables();
            _loc4_.CACHE = new Date().getTime();
            _loc4_.ACTION = 2;
            _loc4_.PARAMS = "SESSION=" + session + "&TARGETID=" + param2 + "&ACCEPT=" + (!!param1?1:0);
            _loc5_ = new URLRequest(GlobalProperties.scriptAdr + "/chat/contactManager.php");
            _loc5_.method = "POST";
            _loc5_.data = _loc4_;
            _loc6_ = new URLLoader();
            _loc6_.dataFormat = "variables";
            _loc6_.load(_loc5_);
            _loc6_.addEventListener("complete",this.answerFriendAskMessage,false,0,true);
         }
      }
      
      public function answerFriendAskMessage(param1:Event) : *
      {
         var _loc2_:uint = Number(param1.currentTarget.data.RES);
         var _loc3_:String = param1.currentTarget.data.ERROR;
         if(!_loc2_ && _loc3_ == "FRIEND_LISTED")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Ce blabla est déja dans ta liste d\'amis ^^.</span>");
         }
         else if(!_loc2_ && _loc3_ == "BLACK_LISTED")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible de faire la demande, tu es dans la black liste de ce blabla.</span>");
         }
         else if(!_loc2_ && _loc3_ == "FROM_LIST_FULL")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible, ta liste d\'amis est pleine :/.</span>");
         }
         else if(!_loc2_ && _loc3_ == "TARGET_LIST_FULL")
         {
            userInterface.addLocalMessage("<span class=\'info\'>Impossible, sa liste d\'amis est pleine.</span>");
         }
      }
      
      public function updateFriendConnected() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < blablaland.friendList.length)
         {
            if(blablaland.friendList[_loc2_].connected)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         ExternalInterface.call("bblinfos_setAmis",_loc1_,blablaland.friendList.length);
         userInterface.friendCount = _loc1_;
      }
      
      public function onFriendListChange(param1:Event) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < blablaland.friendList.length)
         {
            blablaland.friendList[_loc2_].addEventListener("onStateChanged",this.onFriendStateChanged,false,0,true);
            _loc2_++;
         }
         this.updateFriendConnected();
      }
      
      public function onFriendStateChanged(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         userInterface.friendCount = userInterface.friendCount + (!!param1.currentTarget.connected?1:-1);
         ExternalInterface.call("bblinfos_setAmis",userInterface.friendCount,blablaland.friendList.length);
         if(param1.currentTarget.connected && param1.currentTarget.informed && GlobalProperties.serverTime - param1.currentTarget.lastDecoTime > 10000)
         {
            _loc2_ = new ChatAlertItem();
            _loc2_.uid = param1.currentTarget.tracker.userList[0].uid;
            _loc2_.pid = param1.currentTarget.tracker.userList[0].pid;
            _loc2_.pseudo = param1.currentTarget.tracker.userList[0].pseudo;
            _loc2_.type = 1;
            addAlert(_loc2_);
            _loc3_ = "";
            _loc3_ = _loc3_ + "<span class=\'info\'>";
            _loc3_ = _loc3_ + ("<span class=\'user\'><U><A HREF=\'event:0=" + escape(_loc2_.pseudo) + "=" + _loc2_.pid + "=" + _loc2_.uid + "\'>" + _loc2_.pseudo + "</A></U> ");
            _loc3_ = _loc3_ + "Vient de se connecter.";
            userInterface.addLocalMessage(_loc3_);
         }
      }
      
      public function onFriendAdded(param1:ContactEvent) : *
      {
         var _loc2_:ChatAlertItem = new ChatAlertItem();
         _loc2_.uid = param1.contact.uid;
         _loc2_.pseudo = param1.contact.pseudo;
         _loc2_.type = 3;
         addAlert(_loc2_);
         var _loc3_:* = "";
         _loc3_ = _loc3_ + "<span class=\'info\'>";
         _loc3_ = _loc3_ + ("<span class=\'user\'><U><A HREF=\'event:0=" + escape(_loc2_.pseudo) + "=0=" + _loc2_.uid + "\'>" + _loc2_.pseudo + "</A></U> ");
         _loc3_ = _loc3_ + "est ajouté à ta liste d\'amis.";
         userInterface.addLocalMessage(_loc3_);
      }
      
      public function onFriendRemoved(param1:ContactEvent) : *
      {
         param1.contact.removeEventListener("onStateChanged",this.onFriendStateChanged,false);
         var _loc2_:ChatAlertItem = new ChatAlertItem();
         _loc2_.uid = param1.contact.uid;
         _loc2_.pseudo = param1.contact.pseudo;
         _loc2_.type = 2;
         addAlert(_loc2_);
         var _loc3_:* = "";
         _loc3_ = _loc3_ + "<span class=\'info\'>";
         _loc3_ = _loc3_ + ("<span class=\'user\'><U><A HREF=\'event:0=" + escape(_loc2_.pseudo) + "=0=" + _loc2_.uid + "\'>" + _loc2_.pseudo + "</A></U> ");
         _loc3_ = _loc3_ + "Ne fait plus partie de ta liste d\'amis";
         userInterface.addLocalMessage(_loc3_);
      }
      
      public function onInterfaceMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:SocketMessage = param1.getMessage();
         if(param1.evtType == 2 && param1.evtStype == 5)
         {
            _loc3_ = uint(_loc7_.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
            _loc2_ = _loc7_.bitReadString();
            _loc4_ = new ChatAlertItem();
            _loc4_.uid = _loc3_;
            _loc4_.pseudo = _loc2_;
            _loc4_.type = 0;
            addAlert(_loc4_);
            _loc5_ = "";
            _loc5_ = _loc5_ + "<span class=\'info\'>";
            _loc5_ = _loc5_ + ("<span class=\'user\'><U><A HREF=\'event:0=" + escape(_loc2_) + "=" + _loc3_ + "\'>" + _loc2_ + "</A></U> ");
            _loc5_ = _loc5_ + "veut t\'ajouter dans sa liste d\'amis. <A HREF=\'event:1\'><U>Cliquer ici.</U></A>";
            userInterface.addLocalMessage(_loc5_);
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 2 && param1.evtStype == 10)
         {
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 2 && param1.evtStype == 15)
         {
            _loc6_ = new FxLoader();
            _loc6_.initData = {
               "CHAT":this,
               "GB":GlobalProperties,
               "ACTION":1,
               "SM":_loc7_
            };
            _loc6_.loadFx(41);
            param1.stopImmediatePropagation();
         }
      }
   }
}
