package com.allofus.taqa.led.model
{

	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;
	/**
	 * @author jc
	 */
	public class SettingsProxy extends Actor implements IXMLProxy
	{
		
		protected var _headlineDisplayRate:int;
		protected var _textScrollSpeed:String; //slow, med, fast
		protected var _imageDisplaySeconds:int;

		public function set data(xml : XML) : void
		{
			_headlineDisplayRate = int(xml.node.led_headline_display_rate);
			_textScrollSpeed = xml.node.led_scroll_speed;
			_imageDisplaySeconds = int(xml.node.led_img_display_dur);
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
