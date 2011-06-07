package com.allofus.taqa.led.model
{

	import flash.events.Event;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;
	/**
	 * @author jc
	 */
	public class SettingsProxy extends Actor implements IXMLProxy
	{
		public static const UPDATE:String = "SettingsProxy/Update";
		
		protected var _headlineDisplayRate:int;
		protected var _textScrollSpeed:String; //slow, med, fast
		protected var _imageDisplaySeconds:int;

		public function set data(xml : XML) : void
		{
			logger.debug("CONFIG PROXY updated settings: " + xml);
			if(xml)
			{
				_headlineDisplayRate = int(xml.node.led_headline_display_rate);
				_textScrollSpeed = xml.node.led_scroll_speed;
				_imageDisplaySeconds = int(xml.node.led_img_display_dur);
			}
			else
			{
				_headlineDisplayRate = 50;
				_textScrollSpeed = "slow";
				_imageDisplaySeconds = 10;
			}
			logger.debug("send update to system.");
			dispatch(new Event(UPDATE));
		}

		public function get headlineDisplayRate() : int
		{
			return _headlineDisplayRate;
		}


		public function get textScrollSpeed() : String
		{
			return _textScrollSpeed;
		}

		public function get imageDisplaySeconds() : int
		{
			return _imageDisplaySeconds;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(SettingsProxy);
	}
}
