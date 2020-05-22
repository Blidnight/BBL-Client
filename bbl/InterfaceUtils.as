package bbl
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import ui.RectArea;
   
   public class InterfaceUtils extends InterfaceSmiley
   {
       
      
      public var utilsRectAreaA:RectArea;
      
      public var utilsRectAreaB:RectArea;
      
      public var utilsList:Array;
      
      public var onglet_0:Sprite;
      
      public var onglet_1:Sprite;
      
      public var onglet_2:Sprite;
      
      public var onglet_3:Sprite;
      
      public var noMouse:Sprite;
      
      public var maskUtilA:Sprite;
      
      public var maskUtilB:Sprite;
      
      public var infoBulle:Function;
      
      private var gridContentA:Sprite;
      
      private var utilsContentA:Sprite;
      
      private var gridContentB:Sprite;
      
      private var utilsContentB:Sprite;
      
      private var gridWidth:uint;
      
      private var gridHeight:uint;
      
      private var curGenre:uint;
      
      private var genrePosMemory:Array;
      
      public function InterfaceUtils()
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         super();
         this.utilsList = new Array();
         this.curGenre = 0;
         this.genrePosMemory = [0,0,0,0,0,0];
         this.gridWidth = 30;
         this.gridHeight = 31;
         this.utilsRectAreaA = new RectArea();
         this.utilsRectAreaA.contentWidth = this.gridWidth;
         this.utilsRectAreaA.areaWidth = this.gridWidth * 5;
         this.utilsRectAreaA.areaHeight = this.gridHeight * 4;
         this.utilsRectAreaA.x = this.maskUtilA.x + 1;
         this.utilsRectAreaA.y = 0;
         this.utilsRectAreaA.mouseBorderMarge = 40;
         this.utilsRectAreaA.scrollControl = 2;
         addChildAt(this.utilsRectAreaA,getChildIndex(this.maskUtilA));
         this.maskUtilA.visible = false;
         this.utilsRectAreaB = new RectArea();
         this.utilsRectAreaB.contentWidth = this.gridWidth;
         this.utilsRectAreaB.areaWidth = this.gridWidth * 2;
         this.utilsRectAreaB.areaHeight = this.gridHeight * 4;
         this.utilsRectAreaB.x = this.maskUtilB.x + 1;
         this.utilsRectAreaB.y = 0;
         this.utilsRectAreaB.mouseBorderMarge = 40;
         this.utilsRectAreaB.scrollControl = 2;
         addChildAt(this.utilsRectAreaB,getChildIndex(this.maskUtilB));
         this.maskUtilB.visible = false;
         this.gridContentA = new Sprite();
         this.utilsRectAreaA.content.addChild(this.gridContentA);
         this.utilsContentA = new Sprite();
         this.utilsRectAreaA.content.addChild(this.utilsContentA);
         this.gridContentB = new Sprite();
         this.utilsRectAreaB.content.addChild(this.gridContentB);
         this.utilsContentB = new Sprite();
         this.utilsRectAreaB.content.addChild(this.utilsContentB);
         var _loc4_:int = 0;
         while(_loc4_ < this.numChildren)
         {
            if(getChildAt(_loc4_) is Sprite)
            {
               _loc1_ = Sprite(getChildAt(_loc4_));
               _loc2_ = _loc1_.name;
               _loc3_ = _loc2_.split("_");
               if(_loc2_ == "noMouse")
               {
                  _loc1_.mouseChildren = false;
                  _loc1_.mouseEnabled = false;
               }
               else if(_loc3_.length == 2 && _loc3_[0] == "onglet" && _loc3_[1].length == 1)
               {
                  MovieClip(_loc1_).gotoAndStop(Number(_loc3_[1]) == this.curGenre?2:1);
                  _loc1_.addEventListener("mouseOver",this.ongletOverEvt);
                  _loc1_.addEventListener("mouseOut",this.ongletOutEvt);
                  _loc1_.addEventListener("click",this.ongletClickEvt);
               }
            }
            _loc4_++;
         }
         this.redrawGrid();
      }
      
      private function getGenreList(param1:uint) : *
      {
         var _loc2_:* = null;
         if(param1 == 0)
         {
            _loc2_ = [3,5,7];
         }
         if(param1 == 1)
         {
            _loc2_ = [1,8];
         }
         if(param1 == 2)
         {
            _loc2_ = [2,9];
         }
         if(param1 == 3)
         {
            _loc2_ = [4,6];
         }
         return _loc2_;
      }
      
      private function isInGenre(param1:uint, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function ongletClickEvt(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = Number(param1.currentTarget.name.split("_")[1]);
         if(_loc6_ != this.curGenre)
         {
            this.genrePosMemory[this.curGenre] = this.utilsRectAreaA.content.y;
            _loc2_ = this.getGenreList(_loc6_);
            this["onglet_" + this.curGenre].gotoAndStop(1);
            this["onglet_" + _loc6_].gotoAndStop(2);
            _loc3_ = 0;
            while(_loc3_ < this.utilsList.length)
            {
               _loc4_ = this.utilsList[_loc3_];
               _loc5_ = this.isInGenre(_loc4_.genre,_loc2_);
               if(_loc5_ && !_loc4_.iconContent.parent)
               {
                  this.utilsContentA.addChild(_loc4_.iconContent);
               }
               else if(!_loc5_ && _loc4_.iconContent.parent == this.utilsContentA)
               {
                  this.utilsContentA.removeChild(_loc4_.iconContent);
               }
               _loc3_++;
            }
            this.utilsRectAreaA.content.y = this.genrePosMemory[_loc6_];
            this.curGenre = _loc6_;
            this.redrawGrid();
            this.utilsRectAreaA.replaceInside();
         }
      }
      
      public function ongletOverEvt(param1:Event) : *
      {
         var _loc2_:* = 0;
         if(this.infoBulle)
         {
            _loc2_ = uint(Number(param1.currentTarget.name.split("_")[1]));
            if(_loc2_ == 0)
            {
               this.infoBulle("Objets & Pouvoirs");
            }
            if(_loc2_ == 1)
            {
               this.infoBulle("Montures");
            }
            if(_loc2_ == 2)
            {
               this.infoBulle("Bliblis");
            }
            if(_loc2_ == 3)
            {
               this.infoBulle("Maisons");
            }
         }
      }
      
      public function ongletOutEvt(param1:Event) : *
      {
         if(this.infoBulle)
         {
            this.infoBulle(null);
         }
      }
      
      override public function closeInterface() : *
      {
         this.removeAllUtil();
         super.closeInterface();
      }
      
      public function removeAllUtil() : *
      {
         while(this.utilsList.length)
         {
            this.removeUtil(this.utilsList[0]);
         }
      }
      
      public function warnUtil(param1:InterfaceUtilsItem) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         if(param1.iconContent.parent)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.utilsList.length)
            {
               if(this.utilsList[_loc3_] == param1)
               {
                  _loc4_ = MovieClip(Sprite(param1.iconContent.parent.parent.getChildAt(0)).getChildAt(_loc2_));
                  _loc4_.gotoAndPlay(2);
                  RectArea(param1.iconContent.parent.parent.parent).showRectangle(_loc4_.getBounds(_loc4_.parent));
                  break;
               }
               if(this.utilsList[_loc3_].iconContent.parent == param1.iconContent.parent)
               {
                  _loc2_++;
               }
               _loc3_++;
            }
            this.utilsRectAreaA.replaceInside();
            this.utilsRectAreaB.replaceInside();
         }
      }
      
      public function removeUtil(param1:InterfaceUtilsItem) : *
      {
         if(param1.iconContent.parent)
         {
            param1.iconContent.parent.removeChild(param1.iconContent);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.utilsList.length)
         {
            if(this.utilsList[_loc2_] == param1)
            {
               this.utilsList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.utilsRectAreaA.replaceInside();
         this.utilsRectAreaB.replaceInside();
         this.redrawGrid();
      }
      
      public function addUtil(param1:uint = 0) : InterfaceUtilsItem
      {
         var _loc2_:InterfaceUtilsItem = new InterfaceUtilsItem();
         _loc2_.genre = param1;
         _loc2_.userInterface = this;
         var _loc3_:Array = this.getGenreList(this.curGenre);
         if(param1 == 0)
         {
            this.utilsContentB.addChild(_loc2_.iconContent);
         }
         else if(this.isInGenre(param1,_loc3_))
         {
            this.utilsContentA.addChild(_loc2_.iconContent);
         }
         this.utilsList.push(_loc2_);
         this.redrawGrid();
         return _loc2_;
      }
      
      private function redrawGrid() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc5_:int = 5;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = this.getGenreList(this.curGenre);
         _loc1_ = 0;
         while(_loc1_ < this.utilsList.length)
         {
            if(this.isInGenre(this.utilsList[_loc1_].genre,_loc8_))
            {
               _loc6_++;
            }
            else if(this.utilsList[_loc1_].genre == 0)
            {
               _loc7_++;
            }
            _loc1_++;
         }
         _loc2_ = uint(Math.max(Math.ceil(this.utilsRectAreaA.areaHeight / this.gridHeight) * _loc5_,Math.ceil(_loc6_ / _loc5_) * _loc5_));
         this.utilsRectAreaA.contentHeight = this.gridHeight * _loc2_ / _loc5_;
         while(_loc2_ < this.gridContentA.numChildren)
         {
            this.gridContentA.removeChildAt(0);
         }
         while(_loc2_ > this.gridContentA.numChildren)
         {
            _loc3_ = new utilsGridSprite();
            this.gridContentA.addChild(_loc3_);
         }
         _loc1_ = 0;
         while(_loc1_ < this.gridContentA.numChildren)
         {
            this.gridContentA.getChildAt(_loc1_).x = _loc1_ % _loc5_ * this.gridWidth;
            this.gridContentA.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc5_) * this.gridHeight;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.utilsContentA.numChildren)
         {
            this.utilsContentA.getChildAt(_loc1_).x = _loc1_ % _loc5_ * this.gridWidth + 4;
            this.utilsContentA.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc5_) * this.gridHeight + 4;
            _loc1_++;
         }
         _loc5_ = 2;
         _loc2_ = uint(Math.max(Math.ceil(this.utilsRectAreaB.areaHeight / this.gridHeight) * _loc5_,Math.ceil(_loc7_ / _loc5_) * _loc5_));
         this.utilsRectAreaB.contentHeight = this.gridHeight * _loc2_ / _loc5_;
         while(_loc2_ < this.gridContentB.numChildren)
         {
            this.gridContentB.removeChildAt(0);
         }
         while(_loc2_ > this.gridContentB.numChildren)
         {
            _loc3_ = new utilsGridSprite();
            this.gridContentB.addChild(_loc3_);
         }
         _loc1_ = 0;
         while(_loc1_ < this.gridContentB.numChildren)
         {
            this.gridContentB.getChildAt(_loc1_).x = _loc1_ % _loc5_ * this.gridWidth;
            this.gridContentB.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc5_) * this.gridHeight;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.utilsContentB.numChildren)
         {
            this.utilsContentB.getChildAt(_loc1_).x = _loc1_ % _loc5_ * this.gridWidth + 4;
            this.utilsContentB.getChildAt(_loc1_).y = Math.floor(_loc1_ / _loc5_) * this.gridHeight + 4;
            _loc1_++;
         }
      }
   }
}
