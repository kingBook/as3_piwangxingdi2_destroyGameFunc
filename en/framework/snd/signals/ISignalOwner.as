package framework.snd.signals
{
   public interface ISignalOwner extends ISignal, IDispatcher
   {
      
      function removeAll() : void;
   }
}
