package com.allofus.taqa.led.controller
{
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.PreferencesPane;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class WriteNewPreferencesCommand extends Command
	{
		[Inject] public var preferencesService:PreferencesService;
		
		override public function execute():void
		{
			logger.info("write new prefs to file: ");
			logger.debug("-> " + PreferencesPane.preferencesXML);
			preferencesService.writePreferences();
		}
		private static const logger:ILogger = GetLogger.qualifiedName( WriteNewPreferencesCommand );
	}
}
