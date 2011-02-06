package com.allofus.taqa.led.controller.startup
{
	import com.allofus.taqa.led.view.preferences.TypeStylePreferences;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;

	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class CheckPreferencesCommand extends Command
	{
		[Inject] public var preferencesService:PreferencesService;
		
		override public function execute():void
		{
			logger.info("check app preferences.");
			
			// position prefs
			var positionPrefs : XML = preferencesService.readPreferences(PositionPreferences.FILE_ID);
			if(positionPrefs)
			{
				//update w/ xml that was read in
				logger.debug("update from file: " + positionPrefs);
				PositionPreferences.preferencesXML = positionPrefs;	
			}
			else
			{
				//the file doesn't exist in local storage (this is probably the 1st time the app has been run.
				//fire the write prefs command and it will create the file from the xml it was compiled with.
				//check out the PositionPreferences.as to see the default settings.
				logger.debug("write defaults.");
				dispatch(new Event(PreferencesPane.UPDATE));
			}
			
			// font styles prefs
			var fontPrefs : XML = preferencesService.readPreferences(TypeStylePreferences.FILE_ID);
			if(fontPrefs)
			{
				logger.debug("update from file: " + fontPrefs);
				TypeStylePreferences.preferencesXML = fontPrefs;	
			}
			else
			{
				logger.debug("write defaults.");
				dispatch(new Event(PreferencesPane.UPDATE));
			}
			
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.CHECKING_PREFERENCES_COMPLETE));
		}
		private static const logger:ILogger = GetLogger.qualifiedName( CheckPreferencesCommand );
	}
}
