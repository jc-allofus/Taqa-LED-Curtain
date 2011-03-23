package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.service.XMLFeedService;
	import com.greensock.TweenMax;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author chrismullany
	 * Polls the CMS at a given frequency and checks for new content using datetimestamp comparison
	 */
	public class LEDRefreshPollProxy extends Actor implements IXMLProxy
	{
		public static const UPDATE:String = "LEDRefreshPollProxy/UPDATE";
		
		private static const logger : ILogger = GetLogger.qualifiedName(LEDRefreshPollProxy);
		
		protected var _lastUpdated:int = -1;	// last time in seconds content was updated
		protected var _pollRate:int = 10;		// in seconds
		
		[Inject] public var configProxy:ConfigProxy;
		[Inject] public var xmlFeedService:XMLFeedService;
		

		public function LEDRefreshPollProxy()
		{
		}
		
		public function start():void
		{
			//TweenMax.delayedCall(_pollRate, checkForUpdate);
		}

		public function set data(xml:XML):void
		{
			// Get the date time and compare it to _lastDateTime
			var updated:int = int(xml.node.updated);
			
			logger.info("set data: updated: " + updated + ", last updated: " + _lastUpdated);
			
			if (_lastUpdated != -1 && updated > _lastUpdated){
				
				logger.info("Content has been updated!");
				
				// Content has been updated
				disptachContentRefresh();
			}
			_lastUpdated = updated;
			start();
		}
		
		
		private function checkForUpdate():void
		{
			logger.info("checkForUpdate");
			//load "/feeds/settings_updated"
			xmlFeedService.retrieveFeed(configProxy.updatedFeedPath, this);
		}
		
		private function disptachContentRefresh():void
		{
			logger.info("disptachContentRefresh");
			dispatch(new Event(UPDATE));
		}
	}
}
