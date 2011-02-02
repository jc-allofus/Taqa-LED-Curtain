package com.allofus.shared.logging
{
	import com.allofus.shared.logging.formatters.ILogEventFormatter;
	import com.allofus.shared.logging.formatters.SimpleTextFormatter;

	import mx.core.mx_internal;
	import mx.logging.LogEvent;
	import mx.logging.targets.LineFormattedTarget;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	use namespace mx_internal;
	
	/**
	 * @author ehlejc
	 */
	public class LogWriter extends LineFormattedTarget
	{
		public var LOG_DIR:String = "log";		public var LOG_FILE:String = "application_log.txt";
		
		protected var logFile:File;
		protected var stream:FileStream;
		protected var formatter:ILogEventFormatter;
		
		public function LogWriter(logFile:File, formatter:ILogEventFormatter = null)
		{
			this.formatter = formatter || new SimpleTextFormatter();
			this.logFile = logFile || File.applicationStorageDirectory.resolvePath(LOG_DIR + "/" + LOG_FILE);
			
			trace ("[LogWriter] will attempt to write to: " + logFile.nativePath);
		}
		
		public override function logEvent(event:LogEvent):void
		{
			try
			{
				stream = getStream();
				var logEntry : String = formatter.formatLogEvent(event, fieldSeparator, includeCategory, includeDate, includeLevel, includeTime);
				//trace("File size: " + logFile.size + " file length: " + " footer size: " + footerSize);
				//stream.position = logFile.size - footerSize;
				stream.writeUTFBytes(logEntry);
			}
			catch (e:Error)
			{
				trace("[LogWriter] caught error trying to write to log: " + e.message);
			}
		}
		
		private function getStream():FileStream
		{
			if(!stream)
			{
				//make sure the log directory exists
				var storageDir : File = File.applicationStorageDirectory.resolvePath(LOG_DIR);
				if (!storageDir.exists)storageDir.createDirectory();

				if(!logFile.exists)writeFileHeader(logFile);
				stream = new FileStream();
				stream.addEventListener(Event.CLOSE, handleStreamClose);				stream.addEventListener(Event.COMPLETE, handleStreamComplete);				stream.addEventListener(IOErrorEvent.IO_ERROR, handleStreamIOError);				stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, handleStreamOutputProgress);
				stream.addEventListener(ProgressEvent.PROGRESS, handleStreamProgress);
				stream.openAsync(logFile, FileMode.APPEND);
				
			}
			return stream;
		}

		private function writeFileHeader(file:File) : void
		{
			var headerString:String = formatter.fileHeaderString + File.lineEnding;
			trace("writing header for log file: \n" + headerString);
			var fs : FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(headerString);
			fs.close();
		}
		
		private function handleStreamClose(event : Event) : void
		{
			//trace ("STREAM CLOSED" + event);
		}

		private function handleStreamComplete(event : Event) : void
		{
			//trace ("STREAM COMPLETE: " + event);
		}
		
		private function handleStreamIOError(event : IOErrorEvent) : void
		{
			trace ("STREAM IO ERROR: " + event);
		}
		
		private function handleStreamOutputProgress(event : OutputProgressEvent) : void
		{
			//trace ("OUTPUT PROGRESS: " + event);
		}
		
		private function handleStreamProgress(event : ProgressEvent) : void
		{
			trace ("INPUT PROGRESS?: " + event);
		}
		
		override mx_internal function internalLog(message : String) : void
		{
		}

	}
}
