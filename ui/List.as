package ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class List extends Sprite
   {
       
      
      public var size:Number;
      
      public var graphicHeight:Number;
      
      public var graphicWidth:Number;
      
      public var annonce:Sprite;
      
      public var node:ListTreeNode;
      
      public var scrollLink:Object;
      
      public var graphicLink:Object;
      
      private var startAt:Number;
      
      private var scroll:Object;
      
      private var content:Sprite;
      
      private var graphicList:Array;
      
      private var visibleList:Array;
      
      public function List()
      {
         super();
         this.node = new ListTreeNode();
         this.visibleList = new Array();
         this.size = 5;
         if(this.annonce)
         {
            this.removeChild(this.annonce);
         }
         this.graphicHeight = 13;
         this.graphicWidth = 200;
         this.graphicList = new Array();
         this.startAt = 0;
         this.scrollLink = Scroll;
         this.graphicLink = ListGraphic;
         this.content = new Sprite();
         this.addChild(this.content);
      }
      
      public function redraw() : *
      {
         var _loc1_:* = null;
         if(!this.scroll && this.scrollLink)
         {
            this.scroll = new this.scrollLink();
            this.addChild(DisplayObject(this.scroll));
            this.scroll.rotation = 90;
            this.scroll.visible = false;
            this.scroll.x = this.graphicWidth + 10;
            this.scroll.addEventListener("onChanged",this.updateSceneByScroll,false,0,true);
         }
         while(this.graphicList.length > this.size)
         {
            _loc1_ = this.graphicList.pop();
            this.content.removeChild(DisplayObject(_loc1_));
         }
         while(this.graphicList.length < this.size)
         {
            _loc1_ = new this.graphicLink();
            this.content.addChild(DisplayObject(_loc1_));
            this.graphicList.push(_loc1_);
            _loc1_.system = this;
         }
         if(this.scroll)
         {
            this.scroll.size = this.size * this.graphicHeight;
         }
         this.visibleList = this.node.getVisibleList();
         this.startAt = Math.max(Math.min(this.visibleList.length - this.size,this.startAt),0);
         this.updateScreen();
         this.updateScrollByScene();
      }
      
      public function scrollDragging() : *
      {
         if(mouseX < 0)
         {
            this.scroll.value = this.scroll.value - this.scroll.changeStep / 2;
         }
         else if(mouseY > this.size * this.graphicHeight)
         {
            this.scroll.value = this.scroll.value + this.scroll.changeStep / 2;
         }
         this.updateSceneByScroll();
      }
      
      public function updateScreen() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < this.size)
         {
            _loc1_ = this.graphicList[_loc2_];
            _loc1_.screenIndex = _loc2_;
            _loc1_.visibleIndex = _loc2_ + this.startAt;
            if(_loc2_ + this.startAt < this.visibleList.length)
            {
               _loc1_.node = this.visibleList[_loc2_ + this.startAt];
               _loc1_.visible = true;
               _loc1_.y = this.graphicHeight * _loc2_;
               _loc1_.redraw();
            }
            else
            {
               _loc1_.visible = false;
               _loc1_.node = null;
            }
            _loc2_++;
         }
      }
      
      public function updateSceneByScroll(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         if(this.scroll)
         {
            _loc2_ = this.visibleList.length - this.size;
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            this.startAt = Math.round(_loc2_ * this.scroll.value);
         }
         this.updateScreen();
      }
      
      public function updateScrollByScene() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.scroll && this.graphicList.length)
         {
            if(this.size < this.visibleList.length)
            {
               _loc1_ = this.visibleList.length - this.size;
               _loc2_ = 0;
               _loc3_ = 0;
               while(_loc3_ < this.visibleList.length)
               {
                  if(this.visibleList[_loc3_] == this.graphicList[0].node)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
                  _loc3_++;
               }
               this.scroll.visible = true;
               this.scroll.value = _loc2_ / _loc1_;
            }
            else
            {
               this.scroll.visible = false;
            }
         }
      }
   }
}
