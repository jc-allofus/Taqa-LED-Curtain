package com.allofus.taqa.led.controller.startup
{
	import org.robotlegs.utilities.statemachine.StateEvent;
	import com.allofus.taqa.led.events.InternetConnectionEvent;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.model.InternetConnectionProxy;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class DetectInternetConnectionCommand extends Command
	{
		[Inject] public var inetConnectionProxy:InternetConnectionProxy;
		
		[Inject] public var configProxy:ConfigProxy;
		
		
		public override function execute():void
		{
			logger.info(inetConnectionProxy + " will be detecting internet connection to URL from" + configProxy);
			inetConnectionProxy.eventDispatcher.addEventListener(InternetConnectionEvent.STATUS, handleStatusObtained);
			inetConnectionProxy.detectConnection(configProxy.updateURL);
		}

		protected function handleStatusObtained(event : InternetConnectionEvent) : void
		{
			inetConnectionProxy.eventDispatcher.removeEventListener(InternetConnectionEvent.STATUS, handleStatusObtained);
			if(event.isConnected)
			{
				dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.INITIAL_CONNECTION_OFF));
			}
			else
			{
				dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.INITIAL_CONNECTION_OFF));
			}
		}
		private static const logger:ILogger = GetLogger.qualifiedName( DetectInternetConnectionCommand );
	}
}
