package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class AppRunningCommand extends Command
	{
		override public function execute():void
		{
			logger.info("App is Running" );
		}
		private static const logger:ILogger = GetLogger.qualifiedName( AppRunningCommand );
	}
}
