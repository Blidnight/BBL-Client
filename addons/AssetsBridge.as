package addons
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class AssetsBridge extends EventDispatcher
   {
      
      private static var assets:Object = new Object();
       
      
      private var resources:Class;
      
      private var signature:String;
      
      private var cacheVersion:uint;
      
      public function AssetsBridge(param1:uint)
      {
         this.resources = AssetsBridge_resources;
         super();
         this.cacheVersion = param1;
         this.loadAssetsBin();
      }
      
      public function reload(param1:uint) : *
      {
         this.cacheVersion = param1;
      }
      
      public function loadAsset(param1:EventDispatcher) : *
      {
         var assetName:String = null;
         var loader:Loader = null;
         var loadFrom:* = undefined;
         var loaderClass:EventDispatcher = param1;
         assetName = "";
         if(loaderClass instanceof AssetsLoaderItem)
         {
            loadFrom = loaderClass;
            if(loaderClass instanceof FxLoaderItem)
            {
               assetName = assetName + "fx.swf";
            }
            else if(loaderClass instanceof MapLoaderItem)
            {
               assetName = assetName + "map.swf";
            }
            else if(loaderClass instanceof SmileyLoaderItem)
            {
               assetName = assetName + "SmileyPack.swf";
            }
            else if(loaderClass instanceof SkinLoaderItem)
            {
               assetName = assetName + "skin.swf";
            }
            assetName = assetName + (":" + loadFrom.id);
            loader = loadFrom.loader;
         }
         else
         {
            assetName = assetName + "external.swf";
            loader = ExternalLoader.external;
         }
         if(!AssetsBridge.assets[assetName])
         {
            this.addEventListener("onAssetsLoaded",function():*
            {
               this.loadClientAsset(loader,this.getRequest(assetName));
            });
         }
         else
         {
            this.loadClientAsset(loader,this.getRequest(assetName));
         }
      }
      
      private function loadClientAsset(param1:Loader, param2:URLRequest) : *
      {
         var context:* = undefined;
         var signatureFile:String = null;
         var onAssetLoaded:* = undefined;
         var loader:Loader = param1;
         var request:URLRequest = param2;
         onAssetLoaded = function(param1:Event):*
         {
            var _loc2_:ByteArray = param1.target.data;
            var _loc3_:int = _loc2_.length;
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_[_loc4_] = _loc2_[_loc4_] ^ signatureFile.charCodeAt(_loc4_ % signatureFile.length);
               _loc4_++;
            }
            loader.loadBytes(param1.target.data,context);
         };
         context = new LoaderContext();
         if(GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1)
         {
         }
         context.applicationDomain = new ApplicationDomain();
         signatureFile = this.signature;
         var swfLoader:URLLoader = new URLLoader(request);
         swfLoader.dataFormat = URLLoaderDataFormat.BINARY;
         swfLoader.addEventListener("complete",onAssetLoaded,false);
      }
      
      private function loadAssetsBin() : void
      {
         var _loc1_:ByteArray = new this.resources();
         _loc1_.uncompress();
         this.signature = _loc1_.readUTF();
         while(_loc1_.readBoolean())
         {
            AssetsBridge.assets[_loc1_.readUTF()] = _loc1_.readUTF();
         }
         this.dispatchEvent(new Event("onAssetsLoaded"));
      }
      
      private function getRequest(param1:String) : *
      {
         return new URLRequest(AssetsBridge.assets[param1]);
      }
   }
}
