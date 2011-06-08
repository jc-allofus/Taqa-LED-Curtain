package com.allofus.taqa.led.service
{
	import com.allofus.taqa.led.model.IXMLProxy;
	/**
	 * @author jc
	 */
	public class XMLFeedVO
	{
		public var url:String;
		public var targetModel:IXMLProxy;
		public var data:XML;
		
		public function toString():String
		{
			return "[XMLFeedVO]: " 
			+ "  url: " + url
			+ ", targetModel: " + targetModel
			+ ", data: " + data;
		}
	}
}
