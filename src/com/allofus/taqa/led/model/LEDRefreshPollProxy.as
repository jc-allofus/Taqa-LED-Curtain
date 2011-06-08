package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.service.XMLFeedService;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

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
		protected var timer:Timer;
		
		protected var failCount:int = 0; //how many times have we got no response
		protected var giveUpAfterFails:int = 2;
		
		[Inject] public var internetConnectionProxy:InternetConnectionProxy;
		[Inject] public var configProxy:ConfigProxy;
		[Inject] public var xmlFeedService:XMLFeedService;
		
		public function LEDRefreshPollProxy()
		{
			timer = new Timer(1000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, checkForUpdate);
		}
		
		/**
		 * Kicks off a delayed call to check for updates
		 */
		public function start():void
		{
			// Get poll rate from config or fallback to 60 seconds
			var pollRate:int = (configProxy.updatedSettingsCheckFrequency * 1000) || 5000;
			timer.reset();
			timer.delay = pollRate;
			timer.start();
			logger.info("start timer for refresh: " + timer.delay +  " configProxy.checkFrequency: " + configProxy.updatedSettingsCheckFrequency);
		}
		
		/**
		 * Data contains last updated time
		 */
		public function set data(xml:XML):void
		{
			if(!xml)
			{
				logger.warn("data was set to null, this probably means the CMS is unavailable. try again after dealy.");
				start();
				return;
			}
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
		private function checkForUpdate(event:TimerEvent = null):void
		{
			if(!internetConnectionProxy.hasInternetConnection)
			{
				logger.info("checkForUpdate() called but we have no internet connection; try agin later...");
				start();
				return;
			}
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
