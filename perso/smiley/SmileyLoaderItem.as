package perso.smiley
{
   import addons.AssetsLoaderItem;
   import flash.events.Event;
   
   public class SmileyLoaderItem extends AssetsLoaderItem
   {
       
      
      public var packSelectClass:Object;
      
      public var iconClass:Object;
      
      public var managerClass:Object;
      
      public function SmileyLoaderItem()
      {
         super(4);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initSmileyEvent,false,1,false);
      }
      
      public function initSmileyEvent(param1:Event) : *
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initSmileyEvent,false);
         this.packSelectClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackSelect");
         this.iconClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackIcon");
         this.managerClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackManager");
      }
   }
}
