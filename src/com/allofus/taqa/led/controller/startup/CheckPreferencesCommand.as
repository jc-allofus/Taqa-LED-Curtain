package com.allofus.taqa.led.controller.startup
{
	import org.robotlegs.utilities.statemachine.StateEvent;
	import com.allofus.taqa.led.view.PreferencesPane;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class CheckPreferencesCommand extends Command
	{
		[Inject] public var preferencesService:PreferencesService;
		
		override public function execute():void
		{
			logger.info("check app preferences.");
			var prefsXML:XML = preferencesService.readPreferences();
			if(prefsXML)
			{
				//update w/ xml that was read in
				logger.debug("update from file: " + prefsXML);
				PreferencesPane.preferencesXML = prefsXML;	
			}
			else
			{
				//write default prefs to local storage:
				logger.debug("write defaults.");
				preferencesService.writePreferences();
			}
			
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.CHECKING_PREFERENCES_COMPLETE));
		}
		private static const logger:ILogger = GetLogger.qualifiedName( CheckPreferencesCommand );
	}
}
