package com.allofus.shared.logging.formatters
{
	import com.allofus.shared.logging.formatters.vo.LogEventVO;

	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;

	/**
	 * @author jcehle
	 */
	 
	public class SimpleTextFormatter implements ILogEventFormatter
	{
		public static const ID:String ="!AOULW";
		
		public static const ALL:String 		= "[TRACE]";		public static const DEBUG:String 	= "[DEBUG]";		public static const INFO:String 	= "[INFO]";		public static const WARN:String 	= "[WARN]";		public static const ERROR:String 	= "[ERROR]";		public static const FATAL:String 	= "[FATAL]";
		
		public function formatLogEvent(event : LogEvent, fieldSeparator : String, includeCategory : Boolean, includeDate : Boolean, includeLevel : Boolean, includeTime : Boolean) : String
		{
			var logEntry:String = "";

			if (includeDate || includeTime)
			{
				var d : Date = new Date();
				if (includeDate)
				{
					var date:String = (d.getMonth() + 1) + "/" + d.getDate().toString() + "/" + d.getFullYear();
					logEntry += fieldSeparator + date;
				}   
				if (includeTime)
				{
					var time:String = padTime(d.getHours()) + ":" + padTime(d.getMinutes()) + ":" + padTime(d.getSeconds()) + "." + padTime(d.getMilliseconds(), true);
					logEntry += fieldSeparator + time;
				}
			}
			
			//format level code into meaningful string
			if (includeLevel)
			{
				var lvl:String;
				switch (event.level)
				{
					case LogEventLevel.ALL:
						lvl = ALL;						break;
					
					case LogEventLevel.DEBUG:
						lvl = DEBUG;
						break;
					
					case LogEventLevel.INFO:
						lvl =INFO;
						break;
					
					case LogEventLevel.WARN:
						lvl = WARN;
						break;
					
					case LogEventLevel.ERROR:
						lvl = ERROR;
						break;
					
					case LogEventLevel.FATAL:
						lvl = FATAL;
						break;	
					
				}
				logEntry += fieldSeparator + lvl;
			}

			if (includeCategory)
			{
				logEntry += fieldSeparator + ILogger(event.target).category;
			}

			logEntry += ID +  fieldSeparator + event.message;

			return logEntry;
		}
		
		public function parseLogEvent(value : String) : LogEventVO
		{
			return null;
		}
			
		private function padTime(num : Number, millis : Boolean = false) : String
		{
			if(millis)
			{
				if (num < 10)
	                return "00" + num.toString();
	            else if (num < 100)
	                return "0" + num.toString();
	            else 
	                return num.toString();
			}
			else
			{
				return num > 9 ? num.toString() : "0" + num.toString();
			}
		}

		public function get fileHeaderString() : String
		{
			return "";
		}

		public function get fileFooterString() : String
		{
			return "";
		}

	}
}
