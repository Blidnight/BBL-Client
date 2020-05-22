package map.noel
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   import fx.FxLoader;
   
   public class GuirlandeGlobal
   {
       
      
      public var itemList:Array;
      
      public var GB:Object;
      
      public var noelLight:Boolean;
      
      public var decoVisible:Boolean;
      
      public var _camera:Object;
      
      private var noelFxMng:Object;
      
      private var timer:Timer;
      
      private var noelSndChannel:SoundChannel;
      
      private var lastDate:Number;
      
      private var noelIlluDate:Number;
      
      private var nouvelAnDate:Number;
      
      private var endRepeat:Number;
      
      public function GuirlandeGlobal()
      {
         super();
         this.noelIlluDate = 1418499000000;
         this.nouvelAnDate = 1420066800000;
         this.endRepeat = this.nouvelAnDate - 86400000;
         this.itemList = new Array();
         this.noelLight = false;
         this.decoVisible = false;
      }
      
      public function onFxLoaded(param1:Event) : *
      {
         if(!this.noelFxMng)
         {
            this.noelFxMng = new FxLoader(param1.currentTarget).lastLoad.classRef();
            FxLoader(param1.currentTarget).removeEventListener("onFxLoaded",this.onFxLoaded);
            if(this._camera && this.GB)
            {
               this.noelFxMng.onCamera(this._camera,this.GB);
            }
         }
      }
      
      public function onTimerEvt(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:* = Number(NaN);
         var _loc8_:Number = NaN;
         var _loc9_:* = null;
         if(this.noelFxMng)
         {
            _loc3_ = this.GB.serverTime;
            _loc4_ = this.noelIlluDate;
            if(_loc3_ > _loc4_ + 11000)
            {
               this.noelLight = true;
            }
            if(this.GB.mainApplication.blablaland && this.GB.mainApplication.blablaland.serverId == 0 && _loc3_ > this.noelIlluDate + 3600000 && _loc3_ < this.endRepeat)
            {
               _loc7_ = 9000000;
               _loc8_ = _loc3_ % _loc7_;
               if(_loc8_ > 3600000)
               {
                  _loc4_ = _loc3_ + _loc7_ - _loc8_;
               }
               else
               {
                  _loc4_ = _loc3_ - _loc8_;
               }
            }
            if(this.lastDate < _loc4_ + 16000 && _loc3_ > _loc4_ && !this.noelSndChannel)
            {
               _loc2_ = this.noelFxMng.getNoelSoundClass();
               _loc9_ = new _loc2_();
               this.noelSndChannel = _loc9_.play(_loc3_ - _loc4_,0);
            }
            _loc5_ = _loc4_;
            _loc6_ = 0;
            if(_loc3_ > _loc5_ + 172800)
            {
               _loc5_ = this.nouvelAnDate;
            }
            if(_loc3_ > _loc5_ + 14000 && this.GB.mainApplication.camera)
            {
               if(this.GB.mainApplication.camera.cameraReady)
               {
                  _loc2_ = this.noelFxMng.getFeuArtifice();
                  if(_loc3_ < _loc5_ + 26000)
                  {
                     this.timer.delay = 1000;
                     _loc6_ = 0;
                     while(_loc6_ < 10)
                     {
                        this.startFeu(_loc2_,_loc3_ + _loc6_);
                        _loc6_++;
                     }
                  }
                  else if(_loc3_ >= _loc5_ + 28000)
                  {
                     if(_loc3_ < _loc5_ + 33000)
                     {
                        this.timer.delay = 100;
                        this.startFeu(_loc2_,_loc3_);
                     }
                     else if(_loc3_ < _loc5_ + 40000)
                     {
                        this.timer.delay = 100;
                        if(Math.random() > 0.7)
                        {
                           _loc6_ = 0;
                           while(_loc6_ < 5)
                           {
                              this.startFeu(_loc2_,_loc3_ + _loc6_,0);
                              _loc6_++;
                           }
                        }
                        this.startFeu(_loc2_,_loc3_);
                     }
                     else if(_loc3_ < _loc5_ + 50000)
                     {
                        this.timer.delay = 100;
                        if(Math.random() > 0.8)
                        {
                           _loc6_ = 0;
                           while(_loc6_ < 2)
                           {
                              this.startFeu(_loc2_,_loc3_ + _loc6_,1);
                              _loc6_++;
                           }
                        }
                        if(Math.random() > 0.7)
                        {
                           _loc6_ = 0;
                           while(_loc6_ < 5)
                           {
                              this.startFeu(_loc2_,_loc3_ + _loc6_,0);
                              _loc6_++;
                           }
                        }
                        this.startFeu(_loc2_,_loc3_);
                     }
                     else
                     {
                        this.timer.delay = 200;
                     }
                  }
               }
            }
         }
      }
      
      public function startFeu(param1:Object, param2:Number, param3:uint = 0) : *
      {
         var _loc4_:Object = new param1();
         _loc4_.GB = this.GB;
         _loc4_.type = param3;
         _loc4_.seed = param2;
         _loc4_.camera = this.GB.mainApplication.camera;
         _loc4_.init();
      }
      
      public function init() : *
      {
         var _loc1_:* = null;
         if(!this.noelFxMng)
         {
            _loc1_ = new FxLoader();
            _loc1_.addEventListener("onFxLoaded",this.onFxLoaded);
            _loc1_.loadFx(6);
            this.timer = new Timer(200);
            this.timer.addEventListener("timer",this.onTimerEvt,false);
            this.timer.start();
            this.lastDate = this.GB.serverTime;
         }
      }
      
      public function addGuirlande(param1:MovieClip, param2:Object, param3:Object) : *
      {
         var _loc4_:* = null;
         if(this.decoVisible)
         {
            param1.addEventListener("onDispose",this.disposeItem,false);
            _loc4_ = new GuirlandeItem();
            _loc4_.GB = param2;
            _loc4_.camera = param3;
            _loc4_.source = param1;
            _loc4_.init();
         }
         else
         {
            param1.visible = false;
         }
      }
      
      public function disposeItem(param1:Event) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.itemList.length)
         {
            if(this.itemList[_loc2_].source == param1.currentTarget)
            {
               this.itemList[_loc2_].dispose();
               this.itemList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function set camera(param1:Object) : *
      {
         this._camera = param1;
         if(this.noelFxMng)
         {
            this.noelFxMng.onCamera(param1,this.GB);
         }
      }
   }
}
