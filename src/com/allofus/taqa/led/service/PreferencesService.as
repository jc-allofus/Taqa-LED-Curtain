package com.allofus.taqa.led.service
{
	import com.allofus.taqa.led.view.PreferencesPane;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author jcehle
	 */
	public class PreferencesService extends Actor
	{
		
		public static const FILE_ID:String = "preferences.xml";
		
		public static const UPDATED:String 	= "preferencesService/readComplete";
		
		//API
		public function readPreferences():XML
		{
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_ID);
			if(file.exists)
			{
				var readStream:FileStream = new FileStream();
				readStream.open(file, FileMode.READ);
				var xml:XML = XML(readStream.readUTFBytes(readStream.bytesAvailable));
				logger.debug("here is what we read from the prefs file: " + xml);
				readStream.close();
				return xml;
			}

			logger.debug("there is no preferences file.");
			return null;
		}
		
		public function writePreferences():void
		{
			var writeString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			var xml:XML = PreferencesPane.preferencesXML;
			writeString += xml.toXMLString();
			writeString = writeString.replace(/\n/g, File.lineEnding); 
			
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_ID);
			var writeStream:FileStream = new FileStream();
			writeStream.open(file, FileMode.WRITE);
			writeStream.writeUTFBytes(writeString);
			writeStream.close();
			dispatch(new Event(UPDATED));
		}
		
		
		private static const logger:ILogger = GetLogger.qualifiedName(PreferencesService);
	}
}
