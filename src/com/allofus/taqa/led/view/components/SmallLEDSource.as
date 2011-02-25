package com.allofus.taqa.led.view.components
{
	import com.allofus.taqa.led.model.SlideTypes;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.view.slides.AbstractSlide;
	import com.allofus.taqa.led.view.slides.ImageSlide;
	import com.allofus.taqa.led.view.slides.ScrollingTextSlide;
	import com.allofus.taqa.led.view.slides.VideoSlide;
	import com.allofus.taqa.ledcurtain.swcassets.TestBitmapSlice;

	import mx.logging.ILogger;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author jc
	 */
	public class SmallLEDSource extends AbstractLEDSource
	{
		public static const WIDTH:int = 848;
		public static const HEIGHT:int = 34;
		
		protected var testPattern:Bitmap;
		
		public function SmallLEDSource()
		{
			var r:Rectangle = new Rectangle(0,0,WIDTH,HEIGHT);
			scrollRect = r;
			
			graphics.beginFill(0);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			
			updateToPrefs();
		}
		
		override protected function makeSlide(vo:ISlideVO):AbstractSlide
		{
			var slide:AbstractSlide;
			switch (vo.type)
			{
				case SlideTypes.IMAGE_SMALL:
					slide = new ImageSlide(vo as ImageSlideVO);
					break;
					
				case SlideTypes.VIDEO_SMALL:
					slide = new VideoSlide(vo as VideoSlideVO, WIDTH, HEIGHT);
					break;
					
				case SlideTypes.SCROLLING_TEXT_SMALL:
					//logger.fatal("here we got a text slide.");
					slide = new ScrollingTextSlide(vo as ScrollingTextVO, WIDTH, HEIGHT);
					break;
					
				case SlideTypes.SCROLLING_TEXT_PIXEL:
					//TODO implement...
				default:
					logger.warn("don't know/haven't implemented how to make:" + vo.type);
					break;
			}
			return slide;
		}
		
		public function updateToPrefs():void
		{
			x = PositionPreferences.SMALL_LED_X;
			y = PositionPreferences.SMALL_LED_Y;
			PositionPreferences.SHOW_SMALL_LED_TESTPATTERN ? showTestPattern() : hideTestPattern();
			visible = PositionPreferences.SHOW_SMALL_LED_SOURCE;
		}
		
		override protected function bringToTop(vp:DisplayObject):void
		{
			var ti:int = testPattern ? numChildren-2 : numChildren -1;
			setChildIndex(vp, ti);
		}
		
		protected function showTestPattern(alpha:Number = 0.7):void
		{
			if(!testPattern)
			{
				testPattern = new Bitmap(new TestBitmapSlice(0, 0));
				testPattern.alpha = alpha;
				addChild(testPattern);
			}
		}
		
		protected function hideTestPattern():void
		{
			if(testPattern)
			{
				if(contains(testPattern))
				{
					removeChild(testPattern);
				}
				testPattern.bitmapData.dispose();
				testPattern = null;
			}
		}

		public function get running() : Boolean
		{
			return _running;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(SmallLEDSource);
	}
}
