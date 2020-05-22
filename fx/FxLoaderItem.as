package fx
{
   import addons.AssetsLoaderItem;
   import flash.events.Event;
   
   public class FxLoaderItem extends AssetsLoaderItem
   {
       
      
      public function FxLoaderItem()
      {
         super(2);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initFxEvent,false,1,false);
      }
      
      public function initFxEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initFxEvent,false);
         this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("FxManager");
      }
   }
}
