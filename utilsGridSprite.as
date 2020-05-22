package
{
   import flash.display.MovieClip;
   
   public dynamic class utilsGridSprite extends MovieClip
   {
       
      
      public function utilsGridSprite()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
