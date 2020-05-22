package chatbbl.application
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.StyleSheet;
   import fx.FxLoader;
   import ui.List;
   import ui.ListGraphicEvent;
   
   public class AlertList extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_clear:Sprite;
      
      public function AlertList()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.addEventListener("onKill",this.onKill,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            this.liste.size = 10;
            this.liste.graphicLink = ListGraphicTxtClick;
            this.liste.graphicWidth = 350;
            this.liste.addEventListener("onTextClick",this.onTextClick,false,0,true);
            this.liste.addEventListener("onClick",this.onLineClick,false,0,true);
            this.bt_clear.getChildByName("bt").addEventListener("click",this.onClear,false,0,true);
            parent.width = this.liste.graphicWidth + 15 + this.liste.x * 2;
            parent.height = this.liste.graphicHeight * this.liste.size + this.liste.y * 2 + 20;
            Object(parent).redraw();
            this.bt_clear.x = parent.width / 2 - this.bt_clear.width / 2;
            this.bt_clear.y = parent.height - 18;
            Chat(GlobalChatProperties.chat).addEventListener("onAlertChange",this.updateList,false,0,true);
            this.updateList();
         }
      }
      
      public function onClear(param1:Event) : *
      {
         Chat(GlobalChatProperties.chat).clearAllAlert();
      }
      
      public function onKill(param1:Event) : *
      {
         this.removeEventListener("onKill",this.onKill,false);
         Chat(GlobalChatProperties.chat).removeEventListener("onAlertChange",this.updateList,false);
      }
      
      public function updateList(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:StyleSheet = new StyleSheet();
         _loc4_.setStyle(".click_pseudo",{
            "color":"#0000FF",
            "textDecoration":"underline"
         });
         _loc4_.setStyle(".accept",{
            "color":"#0000FF",
            "textDecoration":"underline"
         });
         _loc4_.setStyle(".cancel",{
            "color":"#0000FF",
            "textDecoration":"underline"
         });
         _loc4_.setStyle(".info",{"color":"#0000FF"});
         this.liste.node.removeAllChild();
         var _loc5_:* = Chat(GlobalChatProperties.chat).alertList;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc2_ = this.liste.node.addChild();
            _loc3_ = new Date();
            _loc3_.setTime(_loc5_[_loc6_].date);
            _loc2_.data.ALERT = _loc5_[_loc6_];
            _loc2_.text = "[" + _loc3_.getHours() + ":" + _loc3_.getMinutes() + "] ";
            _loc2_.styleSheet = _loc4_;
            if(_loc5_[_loc6_].type == 0)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> veut être ton ami. <span class=\'accept\'><A HREF=\'event:1\'>Accepter</a></span>");
            }
            else if(_loc5_[_loc6_].type == 1)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].pid + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> vient de se connecter.");
            }
            else if(_loc5_[_loc6_].type == 2)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].pid + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> quitte ta liste d\'amis.");
            }
            else if(_loc5_[_loc6_].type == 3)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].pid + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> est ajouté à ta liste d\'amis.");
            }
            else if(_loc5_[_loc6_].type == 4)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'info\'>" + _loc5_[_loc6_].texte + "</span>");
            }
            else if(_loc5_[_loc6_].type == 5)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'info\'>" + _loc5_[_loc6_].texte + "</span>");
            }
            else if(_loc5_[_loc6_].type == 6)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].pid + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> t\'invite à faire une \'Blablataille navale\', <span class=\'accept\'><A HREF=\'event:2\'>Accepter</a></span>.");
            }
            else if(_loc5_[_loc6_].type == 7)
            {
               _loc2_.text = _loc2_.text + ("<span class=\'click_pseudo\'><A HREF=\'event:0=" + escape(_loc5_[_loc6_].pseudo) + "=" + _loc5_[_loc6_].pid + "=" + _loc5_[_loc6_].uid + "\'>" + _loc5_[_loc6_].pseudo + "</a></span> t\'invite à faire un \'TicTacToe\', <span class=\'accept\'><A HREF=\'event:3\'>Accepter</a></span>.");
            }
            else if(_loc5_[_loc6_].type == 8)
            {
               _loc2_.text = _loc2_.text + _loc5_[_loc6_].texte;
            }
            _loc6_++;
         }
         this.liste.redraw();
      }
      
      public function onTextClick(param1:ListGraphicEvent) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Array = param1.text.split("=");
         if(_loc4_[0] == "0")
         {
            Chat(GlobalChatProperties.chat).clickUser(uint(_loc4_[3]),_loc4_[1]);
         }
         else if(_loc4_[0] == "1")
         {
            if(Chat(GlobalChatProperties.chat).blablaland.getFriendByUID(param1.graphic.node.data.ALERT.uid))
            {
               Chat(GlobalChatProperties.chat).msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Impossible !",
                  "DEPEND":this
               },{
                  "MSG":"\"" + param1.graphic.node.data.ALERT.pseudo + "\" est deja dans ta liste d\'amis.",
                  "ACTION":"OK"
               });
            }
            else
            {
               _loc3_ = Chat(GlobalChatProperties.chat).msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Confirme :",
                  "DEPEND":this
               },{
                  "MSG":"Tu es sûr de vouloir être dans la liste d\'amis de " + param1.graphic.node.data.ALERT.pseudo + " ?",
                  "ACTION":"YESNO",
                  "ALERT":param1.graphic.node.data.ALERT
               });
               _loc3_.addEventListener("onEvent",this.acceptFriend,false,0,true);
            }
         }
         else if(_loc4_[0] == "2")
         {
            _loc2_ = new FxLoader();
            _loc2_.initData = {
               "CHAT":GlobalChatProperties.chat,
               "ACTION":2,
               "UID":param1.graphic.node.data.ALERT.uid
            };
            _loc2_.loadFx(10);
            Object(parent).close();
         }
         else if(_loc4_[0] == "3")
         {
            _loc2_ = new FxLoader();
            _loc2_.initData = {
               "CHAT":GlobalChatProperties.chat,
               "ACTION":2,
               "UID":param1.graphic.node.data.ALERT.uid
            };
            _loc2_.loadFx(11);
            Object(parent).close();
         }
         else if(_loc4_[0] == "4")
         {
            _loc2_ = new FxLoader();
            _loc2_.initData = {
               "GB":GlobalProperties,
               "PARAM":param1.graphic.node.data.ALERT.data
            };
            _loc2_.loadFx(param1.graphic.node.data.ALERT.fxFileId);
            Object(parent).close();
         }
      }
      
      public function acceptFriend(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            param1.currentTarget.removeEventListener("onEvent",this.acceptFriend,false);
            Chat(GlobalChatProperties.chat).answerFriendAsk(true,param1.currentTarget.data.ALERT.uid,param1.currentTarget.data.ALERT.pseudo);
            Object(parent).close();
         }
      }
      
      public function onLineClick(param1:ListGraphicEvent) : *
      {
         if(param1.graphic.node.data.ALERT.type == "5")
         {
            navigateToURL(new URLRequest("/site/shop_index.php"),"_blank");
         }
      }
   }
}
