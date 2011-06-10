package com.allofus.taqa.led.view.components
{
	import com.allofus.taqa.led.model.SlideTypes;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.view.slides.AbstractSlide;
	import com.allofus.taqa.led.view.slides.ImageSlide;
	import com.allofus.taqa.led.view.slides.VideoSlide;

	import mx.logging.ILogger;

	import flash.geom.Rectangle;

	/**
	 * @author jc
	 */
	public class CinemaLED extends AbstractLEDSource
	{
		public static const WIDTH:int = 1216;
		public static const HEIGHT:int = 127;
		
		public function CinemaLED()
		{
			var r:Rectangle = new Rectangle(0,0,WIDTH,HEIGHT);
			scrollRect = r;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			
			updateToPrefs();
			scaleX = 0.5;
		}
		
		override protected function makeSlide(vo:ISlideVO):AbstractSlide
		{
			var slide:AbstractSlide;
			switch (vo.type)
			{
				case SlideTypes.IMAGE_CINEMA:
					slide = new ImageSlide(vo as ImageSlideVO);
					break;
					
				case SlideTypes.VIDEO_CINEMA:
					slide = new VideoSlide(vo as VideoSlideVO, WIDTH, HEIGHT);
					break;
					
				default:
					logger.warn("don't know/haven't implemented how to make:" + vo.type);
					break;
			}
			return slide;
		}
		public function updateToPrefs():void
		{
			x = PositionPreferences.CINEMA_LED_X;
			y = PositionPreferences.CINEMA_LED_Y;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( CinemaLED );
	}
}
