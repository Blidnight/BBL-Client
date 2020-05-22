package map
{
   import addons.AssetsLoaderItem;
   import flash.events.Event;
   
   public class MapLoaderItem extends AssetsLoaderItem
   {
       
      
      public var instance:uint;
      
      public function MapLoaderItem()
      {
         super(3);
         this.instance = 0;
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initMapEvent,false,1,false);
      }
      
      public function initMapEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initMapEvent,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Map");
      }
   }
}
