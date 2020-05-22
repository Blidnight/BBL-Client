package net
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class SocketAdv extends Socket
   {
       
      
      private var inBuffer:ByteArray;
      
      private var inCmpt:uint;
      
      private var outCmpt:uint;
      
      private var flushTimer:Timer;
      
      private var keepAliveTimer:Timer;
      
      public function SocketAdv()
      {
         super();
         addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
         this.inBuffer = new ByteArray();
         this.flushTimer = new Timer(1);
         this.flushTimer.addEventListener("timer",this.flushEvent,false,0,true);
         this.keepAliveTimer = new Timer(20000);
         this.keepAliveTimer.addEventListener("timer",this.keepAliveTimerEvt,false,0,true);
      }
      
      public function keepAliveTimerEvt(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(connected)
         {
            _loc2_ = new SocketMessage();
            this.send(_loc2_);
         }
      }
      
      public function flushEvent(param1:Event) : *
      {
         if(connected)
         {
            this.flush();
         }
         this.flushTimer.stop();
      }
      
      public function send(param1:SocketMessage, param2:Boolean = false) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(connected)
         {
            this.keepAliveTimer.reset();
            this.keepAliveTimer.start();
            this.outCmpt++;
            if(this.outCmpt >= 65530)
            {
               this.outCmpt = 12;
            }
            _loc3_ = new SocketMessage();
            _loc3_.bitWriteUnsignedInt(16,this.outCmpt);
            _loc4_ = _loc3_.exportMessage();
            this.writeBytes(_loc4_);
            _loc4_ = param1.exportMessage();
            this.writeBytes(_loc4_);
            this.writeByte(0);
            if(param2)
            {
               this.flush();
            }
            else
            {
               this.flushTimer.start();
            }
         }
      }
      
      override public function close() : void
      {
         if(connected)
         {
            super.close();
         }
      }
      
      override public function connect(param1:String, param2:int) : void
      {
         this.inCmpt = 12;
         this.outCmpt = 12;
         this.inBuffer = new ByteArray();
         Security.loadPolicyFile("xmlsocket://" + param1 + ":" + param2);
         super.connect(param1,param2);
      }
      
      public function eventMessage(param1:SocketMessageEvent) : *
      {
         dispatchEvent(param1);
      }
      
      public function socketDataHandler(param1:ProgressEvent) : *
      {
         var _loc2_:* = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = this.bytesAvailable;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_ && connected)
         {
            _loc2_ = uint(this.readByte());
            if(_loc2_ == 0)
            {
               this.inCmpt++;
               if(this.inCmpt >= 65530)
               {
                  this.inCmpt = 12;
               }
               _loc3_ = new SocketMessage();
               _loc3_.readMessage(this.inBuffer);
               _loc2_ = uint(_loc3_.bitReadUnsignedInt(16));
               if(!(_loc2_ < this.inCmpt || _loc2_ > this.inCmpt + 20))
               {
                  _loc4_ = new SocketMessageEvent("onMessage",true,true);
                  _loc4_.message.writeBytes(_loc3_,2,0);
                  _loc4_.message.bitLength = _loc4_.message.length * 8;
                  this.eventMessage(_loc4_);
                  this.inBuffer = new ByteArray();
               }
            }
            else
            {
               this.inBuffer.writeByte(_loc2_);
            }
            _loc6_++;
         }
      }
   }
}
