package addons
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   
   public class AssetsLoaderItem extends EventDispatcher
   {
       
      
      private var swfTypeId:uint;
      
      private var sMod:uint;
      
      private var _id:Number;
      
      public var loaded:Boolean;
      
      public var classRef:Object;
      
      public var loader:Loader;
      
      private var swfByte:uint;
      
      public function AssetsLoaderItem(param1:uint, param2:Boolean = true)
      {
         super();
         this.swfTypeId = param1;
         this.sMod = uint(Math.random() * 1000 + 1);
         this.loaded = false;
         this.loader = new Loader();
         if(param2)
         {
            this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initAssetEvent,false,0,false);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
         }
      }
      
      public function getSWFBytes(param1:ByteArray) : *
      {
         var _loc2_:uint = param1.length - 8;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = uint(_loc3_ + _loc4_ * param1[_loc4_ + 8]);
            _loc4_ = _loc4_ + 5;
         }
         return _loc3_;
      }
      
      public function initAssetEvent(param1:Event) : *
      {
         var param1:Event = param1;
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initAssetEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.swfByte = uint(this.getSWFBytes(this.loader.contentLoaderInfo.bytes));
         try
         {
            ExternalInterface.call("console.log",this.swfTypeId,this.id,this.swfByte);
            GlobalProperties.mainApplication.onExternalFileLoaded(this.swfTypeId,this.id,this.swfByte);
         }
         catch(err:*)
         {
         }
         this.loader = null;
         this.loaded = true;
         dispatchEvent(param1);
      }
      
      public function errLoader(param1:Event) : *
      {
         this.loader = null;
         dispatchEvent(param1);
      }
      
      public function get id() : Number
      {
         return this._id / this.sMod;
      }
      
      public function set id(param1:Number) : *
      {
         this._id = Number(param1 * this.sMod);
      }
   }
}
