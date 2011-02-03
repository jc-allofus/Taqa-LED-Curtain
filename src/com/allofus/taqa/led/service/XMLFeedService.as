package com.allofus.taqa.led.service
{
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class XMLFeedService extends Actor
	{
		public function XMLFeedService()
		{
		}
		
		public function retrieveFeed(endpointURL:String):void
		{
			
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( XMLFeedService );
	}
}
