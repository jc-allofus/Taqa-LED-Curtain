package com.allofus.taqa.led.controller
{
	import com.allofus.taqa.led.view.preferences.TypeStylePreferences;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	public class WriteNewPreferencesCommand extends Command
	{
		[Inject] public var preferencesService:PreferencesService;
		
		override public function execute():void
		{
			logger.info("write new prefs to file. ");
			
			//position prefs
			var posString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var xml:XML = PositionPreferences.preferencesXML;
			posString += xml.toXMLString();
			posString = posString.replace(/\n/g, File.lineEnding); 
			preferencesService.writePreferences(PositionPreferences.FILE_ID, posString);
			
			//type style prefs
			var styleString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var styleXML : XML = TypeStylePreferences.preferencesXML;
			styleString += styleXML.toXMLString();
			styleString = styleString.replace(/\n/g, File.lineEnding);
			preferencesService.writePreferences(TypeStylePreferences.FILE_ID, styleString); 
		}
		private static const logger:ILogger = GetLogger.qualifiedName( WriteNewPreferencesCommand );
	}
}
