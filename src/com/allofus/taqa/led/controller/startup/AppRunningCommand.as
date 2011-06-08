package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.LEDRefreshPollProxy;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class AppRunningCommand extends Command
	{
		[Inject] public var ledRefreshPollProxy:LEDRefreshPollProxy;
		
		override public function execute():void
		{
			logger.info("App is Running, start polling for updates" );
			ledRefreshPollProxy.start();
		}
		private static const logger:ILogger = GetLogger.qualifiedName( AppRunningCommand );
	}
}
