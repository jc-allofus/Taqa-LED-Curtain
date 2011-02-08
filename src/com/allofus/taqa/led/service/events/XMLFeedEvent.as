package com.allofus.taqa.led.service.events
{
	import com.allofus.taqa.led.service.XMLFeedVO;
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class XMLFeedEvent extends Event
	{
		public static const FETCH_COMPLETED:String = "xmlFeed/fetchCompleted";
		
		protected var _vo:XMLFeedVO;
		
		public function XMLFeedEvent(type : String, vo:XMLFeedVO, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			_vo = vo;
			super(type, bubbles, cancelable);
		}

		public function get vo() : XMLFeedVO
		{
			return _vo;
		}

		public function set vo(vo : XMLFeedVO) : void
		{
			_vo = vo;
		}
		
		override public function clone():Event
		{
			return new XMLFeedEvent(type, vo, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return "[XMLFeedEvent]:" + _vo
		}
	}
}
