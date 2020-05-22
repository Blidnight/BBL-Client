package bbl
{
   public class BblContact extends BblTracker
   {
       
      
      public var friendList:Array;
      
      public var blackList:Array;
      
      public var muteList:Array;
      
      public function BblContact()
      {
         super();
      }
      
      override public function init() : *
      {
         this.friendList = new Array();
         this.blackList = new Array();
         this.muteList = new Array();
         super.init();
      }
      
      public function isMuted(param1:uint) : Contact
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               return this.muteList[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.blackList.length)
         {
            if(this.blackList[_loc2_].uid == param1)
            {
               return this.blackList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getMuteByUID(param1:uint) : Contact
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               return this.muteList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeMute(param1:uint) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.muteList.length)
         {
            if(this.muteList[_loc2_].uid == param1)
            {
               this.muteList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.dispatchEvent(new Event("onMuteListChange"));
      }
      
      public function addMute(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         this.muteList.push(_loc3_);
         this.dispatchEvent(new Event("onMuteListChange"));
      }
      
      public function removeFriend(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.friendList.length)
         {
            _loc2_ = this.friendList[_loc4_];
            if(_loc2_.uid == param1)
            {
               if(_loc2_.tracker)
               {
                  unRegisterTracker(_loc2_.tracker);
               }
               this.friendList.splice(_loc4_,1);
               _loc3_ = new ContactEvent("onRemoveFriend");
               _loc3_.contact = _loc2_;
               dispatchEvent(_loc3_);
               break;
            }
            _loc4_++;
         }
      }
      
      public function addFriend(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         _loc3_.tracker = new Tracker(0,param1);
         registerTracker(_loc3_.tracker);
         this.friendList.push(_loc3_);
      }
      
      public function getFriendByUID(param1:uint) : Contact
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.friendList.length)
         {
            if(this.friendList[_loc2_].uid == param1)
            {
               return this.friendList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeBlackList(param1:uint) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.blackList.length)
         {
            _loc2_ = this.blackList[_loc4_];
            if(_loc2_.uid == param1)
            {
               this.blackList.splice(_loc4_,1);
               _loc3_ = new ContactEvent("onRemoveBlackList");
               _loc3_.contact = _loc2_;
               dispatchEvent(_loc3_);
               break;
            }
            _loc4_++;
         }
      }
      
      public function addBlackList(param1:uint, param2:String) : *
      {
         var _loc3_:Contact = new Contact();
         _loc3_.uid = param1;
         _loc3_.pseudo = param2;
         this.blackList.push(_loc3_);
      }
      
      public function getBlackListByUID(param1:uint) : Contact
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.blackList.length)
         {
            if(this.blackList[_loc2_].uid == param1)
            {
               return this.blackList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
