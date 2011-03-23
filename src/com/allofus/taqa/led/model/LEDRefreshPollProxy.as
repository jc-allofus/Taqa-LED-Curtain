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
	 * Polls the CMS at a given frequency and checks for new content using simple datetime comparison
	 */
	public class LEDRefreshPollProxy extends Actor implements IXMLProxy
	{
		public static const UPDATE:String = "LEDRefreshPollProxy/UPDATE";
		private static const logger : ILogger = GetLogger.qualifiedName(LEDRefreshPollProxy);
		
		// last time in seconds-since-epoch that content was updated
		protected var _lastUpdated:int = -1;
		
		[Inject] public var configProxy:ConfigProxy;
		[Inject] public var xmlFeedService:XMLFeedService;
		
		/**
		 * Kicks off a delayed call to check for updates
		 */
		public function start():void
		{
			// Get poll rate from config or fallback to 60 seconds
			var pollRate:int = configProxy.updatedSettingsCheckFrequency || 60;
			TweenMax.delayedCall(pollRate, checkForUpdate);
		}
		
		/**
		 * Data contains last updated time
		 */
		public function set data(xml:XML):void
		{
			// Get the date time and compare it to _lastUpdated
			var updated:int = int(xml.node.updated);
			// log
			logger.info("set data: updated: " + updated + ", last updated: " + _lastUpdated);
			// make sure _lastUpdated has been set and compare seconds
			if (_lastUpdated != -1 && updated > _lastUpdated){
				// log
				logger.info("Content has been updated!");
				// Content has been updated, tell everyone about it
				disptachContentRefresh();
			}
			// Update last updated seconds and restart the timer
			_lastUpdated = updated;
			start();
		}
		
		/**
		 * Requests XML from the CMS that contains a last updated time
		 */
		private function checkForUpdate():void
		{
			logger.info("checkForUpdate");
			//load "/feeds/settings_updated"
			xmlFeedService.retrieveFeed(configProxy.updatedFeedPath, this);
		}
		
		/**
		 * Notifies the app that a content refresh is required
		 */
		private function disptachContentRefresh():void
		{
			logger.info("disptachContentRefresh");
			dispatch(new Event(UPDATE));
		}
	}
}
