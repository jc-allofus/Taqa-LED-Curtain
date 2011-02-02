package com.allofus.shared.logging.formatters 
{
	import mx.logging.LogEvent;
	/**
	 * @author jcehle
	 */
	
	
	public interface ILogEventFormatter 
	{
		function formatLogEvent(event:LogEvent, fieldSeparator:String, includeCategory:Boolean, includeDate:Boolean, includeLevel:Boolean, includeTime:Boolean):String;
		//function parseLogEvent(value:*):LogEventVO;
		function get fileHeaderString():String;
		function get fileFooterString():String;
	}
}
