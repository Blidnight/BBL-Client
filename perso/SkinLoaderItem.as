package perso
{
   import addons.AssetsLoaderItem;
   import flash.events.Event;
   
   public class SkinLoaderItem extends AssetsLoaderItem
   {
       
      
      public var nbTry:uint;
      
      public var skinByte:uint;
      
      public function SkinLoaderItem()
      {
         super(1,false);
         this.nbTry = 0;
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initAssetEvent,false,0,false);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false,0,false);
      }
      
      override public function initAssetEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initAssetEvent,false);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errLoader,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Skin");
         this.skinByte = getSWFBytes(this.loader.contentLoaderInfo.bytes);
         this.loader = null;
         this.loaded = true;
         dispatchEvent(param1);
      }
      
      override public function errLoader(param1:Event) : *
      {
         dispatchEvent(param1);
      }
   }
}
