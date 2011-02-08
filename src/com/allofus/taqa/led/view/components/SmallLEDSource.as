package com.allofus.taqa.led.view.components
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
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
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			
			updateToPrefs();
		}
		
		public function queueSlide(vo : ISlideVO) : void
		{
			logger.debug("i will make & show a slide: " + vo);
			//var slide = createSlide(vo);
			//slide.addeve
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
		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDSource );

	}
}
