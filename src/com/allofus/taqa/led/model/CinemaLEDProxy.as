package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;
	/**
	 * @author jc
	 */
	public class CinemaLEDProxy extends Actor implements IXMLProxy
	{
		
		public function set data(xml : XML) : void
		{
			logger.debug("CINEMA LED parse this into something useful: " + xml);
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( CinemaLEDProxy );
	}
}
