package com.allofus.taqa.led.model
{
	import air.net.URLMonitor;

	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.events.InternetConnectionEvent;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.StatusEvent;
	import flash.net.URLRequest;

	/**
	 * @author jc
	 */
	public class InternetConnectionProxy extends Actor
	{
		protected var _hasInternetConnection : Boolean;
		protected var _initialConnection:Boolean = true;
		protected var monitor:URLMonitor;
		
		private static const logger:ILogger = GetLogger.qualifiedName( InternetConnectionProxy );
		
		public function InternetConnectionProxy()
		{
		}
		
		public function detectConnection(url:String):void	
		{
			logger.debug("detectConnection: " + url);
			monitor = new URLMonitor(new URLRequest(url));
			monitor.addEventListener(StatusEvent.STATUS, setHasInternetConnection);
			monitor.start();
			TweenMax.delayedCall(1, checkNow);
			//monitor.
		}

		public function get hasInternetConnection():Boolean
		{
			return _hasInternetConnection;
		}
		
		protected function setHasInternetConnection(event : StatusEvent):void
		{
			logger.debug("do we have internet: " + monitor.available + " -> " + event.code + " initial connection?: " + _initialConnection);	
			checkNow(event);
		}
		
		protected function checkNow(event:StatusEvent = null):void
		{
			if(event == null)
			{
				logger.debug("dispatching from delayed call...");
			}
			else
			{
				TweenMax.killDelayedCallsTo(checkNow);
				logger.debug("dispatching from status event");
			}
			logger.debug("is available: " + monitor.available);
			_hasInternetConnection = monitor.available;
			dispatch(new InternetConnectionEvent(InternetConnectionEvent.STATUS, monitor.available, _initialConnection));
			_initialConnection = false;
		}
	}
}
