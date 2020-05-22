package bbl
{
   import bbl.hitapi.HitAPI;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.utils.Timer;
   import fx.FxLoader;
   import perso.SkinLoader;
   
   public class BblLoader extends BblWebRadio
   {
       
      
      public var fxLoader:FxLoader;
      
      public var externalLoader:ExternalLoader;
      
      public var skinLoader:SkinLoader;
      
      private var serverTimeTimer:Timer;
      
      private var timeFailCheckTimer:Timer;
      
      private var timeFailCheckLast:Number;
      
      private var timeFailCheckCount:uint;
      
      private var hitAPILoader:HitAPI;
      
      public function BblLoader()
      {
         super();
         this.fxLoader = new FxLoader();
         this.externalLoader = new ExternalLoader();
         this.skinLoader = new SkinLoader();
         this.serverTimeTimer = new Timer(30000);
         this.serverTimeTimer.addEventListener("timer",this.onGetTimeTimer,false,0,true);
         this.timeFailCheckTimer = new Timer(200);
         this.timeFailCheckTimer.addEventListener("timer",this.onCheckFailTime,false,0,true);
         addEventListener("close",this.onCloseEvt,false,0,true);
      }
      
      public function onCloseEvt(param1:Event) : void
      {
         this.serverTimeTimer.stop();
         this.timeFailCheckTimer.stop();
      }
      
      public function onCheckFailTime(param1:Event) : *
      {
         var _loc2_:* = null;
         var _loc3_:Number = new Date().getTime() - getTimer();
         if(this.timeFailCheckCount % 100 == 0)
         {
            this.timeFailCheckLast = _loc3_;
         }
         if(Math.abs(this.timeFailCheckLast - _loc3_) > 5000)
         {
            _loc2_ = new TextEvent("onFatalAlert");
            _loc2_.text = "Erreur echelle de temps.";
            this.dispatchEvent(_loc2_);
            close();
            param1.currentTarget.stop();
         }
         this.timeFailCheckCount++;
      }
      
      public function init() : *
      {
         this.serverTimeTimer.reset();
         this.serverTimeTimer.stop();
         if(connected)
         {
            close();
         }
         this.timeFailCheckCount = 0;
         this.timeFailCheckTimer.reset();
         this.timeFailCheckTimer.start();
         this.addEventListener("connect",this.onSocketConnect,false,0,true);
         this.connect(GlobalProperties.socketHost,GlobalProperties.socketPort);
      }
      
      override public function dexecDynFx(param1:String) : void
      {
         var _loc2_:* = new FxLoader();
         _loc2_.initData = {
            "STR":param1,
            "GP":GlobalProperties,
            "SRC":this
         };
         _loc2_.loadFx(15);
      }
      
      public function onSocketConnect(param1:Event) : *
      {
         this.removeEventListener("connect",this.onSocketConnect,false);
         this.addEventListener("onGetPID",this.onGetPID,false,0,true);
         getPID();
      }
      
      public function onGetPID(param1:Event) : *
      {
         this.removeEventListener("onGetPID",this.onGetPID,false);
         this.addEventListener("onGetTime",this.onGetTime,false,0,true);
         getServerTime();
      }
      
      public function onGetTimeTimer(param1:Event) : *
      {
         getServerTime();
      }
      
      public function onGetTime(param1:Event) : *
      {
         this.removeEventListener("onGetTime",this.onGetTime,false);
         this.serverTimeTimer.start();
         this.addEventListener("onGetVariables",this.onGetVariables,false,0,true);
         getVariables();
      }
      
      public function onGetVariables(param1:Event) : *
      {
         this.removeEventListener("onGetVariables",this.onGetVariables,false);
         if(!GlobalProperties.assetsBridge)
         {
            GlobalProperties.assetsBridge = new AssetsBridge(cacheVersion);
         }
         else
         {
            GlobalProperties.assetsBridge.reload(cacheVersion);
         }
         FxLoader.cacheVersion = cacheVersion;
         ExternalLoader.cacheVersion = cacheVersion;
         MapLoader.cacheVersion = cacheVersion;
         SkinLoader.cacheVersion = cacheVersion;
         SmileyLoader.cacheVersion = cacheVersion;
         this.fxLoader.addEventListener("onFxLoaded",this.onFxLoaded,false,0,true);
         this.fxLoader.loadFx(0);
      }
      
      public function onFxLoaded(param1:Event) : *
      {
         this.fxLoader.removeEventListener("onFxLoaded",this.onFxLoaded,false);
         this.externalLoader.addEventListener("onReady",this.onExternalReady,false,0,true);
         this.externalLoader.load();
      }
      
      public function onExternalReady(param1:Event) : *
      {
         this.externalLoader.removeEventListener("onReady",this.onExternalReady,false);
         this.dispatchEvent(new Event("onReady"));
      }
   }
}
