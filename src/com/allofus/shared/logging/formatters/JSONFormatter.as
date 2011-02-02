package com.allofus.shared.logging.formatters
{
	import com.adobe.serialization.json.JSON;
	import com.allofus.shared.logging.formatters.vo.LogEventVO;

	import mx.logging.ILogger;
	import mx.logging.LogEvent;

	import flash.filesystem.File;

	/**
	 * @author jcehle
	 */
	public class JSONFormatter implements ILogEventFormatter
	{
		public static const HEADER_STRING:String = "{\"logEntries\":[";
		public static const FOOTER_STRING:String = "{}]}";
		
		public function JSONFormatter():void
		{
		}
		
		
		public function formatLogEvent(event : LogEvent, fieldSeparator : String, includeCategory : Boolean, includeDate : Boolean, includeLevel : Boolean, includeTime : Boolean) : String
		{
			var logEntry:String = "";
			var date:Date = new Date();
			
			var dateStr:String 		= (includeDate) ? formatDate(date) : null;
			var time : String 		= (includeTime) ? formatTime(date) : null;
			var level : int 		= (includeLevel) ? event.level : -1;
			var category : String 	= (includeCategory) ? ILogger(event.target).category : null;
			var message : String 	= event.message;
			
 			var o:Object = 
 			{
 				date:dateStr,
 				time:time,
 				level:level,
 				category:category,
 				message:message
 			};
 			
 			logEntry = JSON.encode(o);
 			
			return logEntry +","+ File.lineEnding;
		}
		
		public static function parseLogEvent(value:Object):LogEventVO
		{
			if(value["message"] == null) return null;
			var vo:LogEventVO = new LogEventVO();
			vo.category = value["category"];
			vo.date = new Date(value["date"]);
			vo.time = new Date(value["time"]);
			vo.level = int(value["level"]);
			vo.message = value["message"];
			return vo;
		}


		
		protected function formatDate(dateObj:Date):String
		{
			return (dateObj.getMonth() + 1) + "/" + dateObj.getDate().toString() + "/" + dateObj.getFullYear();
		}
		
		protected function formatTime(dateObj:Date):String
		{
			return padTime(dateObj.getHours()) + ":" + padTime(dateObj.getMinutes()) + ":" + padTime(dateObj.getSeconds()) + "." + padTime(dateObj.getMilliseconds(), true);
		}
		
		protected function padTime(num : Number, millis : Boolean = false) : String
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
			return HEADER_STRING;
		}

		public function get fileFooterString() : String
		{
			return FOOTER_STRING;
		}
	}
}
