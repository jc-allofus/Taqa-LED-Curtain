package com.allofus.taqa.led.view.components
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.view.slides.AbstractSlide;
	import com.allofus.taqa.led.view.slides.ImageSlide;
	import com.allofus.taqa.ledcurtain.swcassets.TestBitmapSlice;

	import mx.logging.ILogger;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;


	/**
	 * @author jc
	 */
	public class SmallLEDSource extends AbstractLEDSource
	{
		public static const WIDTH:int = 848;
		public static const HEIGHT:int = 34;
		
		protected var testPattern:Bitmap;
		
		//slide refs
		protected var currentSlide:AbstractSlide;
		protected var queuedSlide:AbstractSlide;
		protected var slideToDispose:AbstractSlide;
		
		protected var _running:Boolean = false;
		
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
			
			queuedSlide = makeSlide(vo);
			addChild(queuedSlide);
			if(currentSlide)
			{
				//wait to get finished event from slide
				logger.info("i've got a queued slide, but i'm gonna chillax till the current dude is done playing...");
			}
			else
			{
				playQueued();
			}
		}
		
		public function updateToPrefs():void
		{
			x = PositionPreferences.SMALL_LED_X;
			y = PositionPreferences.SMALL_LED_Y;
			PositionPreferences.SHOW_SMALL_LED_TESTPATTERN ? showTestPattern() : hideTestPattern();
			visible = PositionPreferences.SHOW_SMALL_LED_SOURCE;
		}
		
		protected function makeSlide(vo:ISlideVO):AbstractSlide
		{
			var slide:AbstractSlide;
			switch (vo.type)
			{
				case ImageSlideVO.TYPE:
					slide = new ImageSlide(vo as ImageSlideVO);
					break;
			}
			return slide;
		}
		
		protected function playQueued(event:Event = null):void
		{
			if(queuedSlide.ready)
			{
				//first update our references
				slideToDispose = currentSlide;
				currentSlide = queuedSlide;
				queuedSlide = null;
				
				//then get our new current slide transitioning in
				currentSlide.removeEventListener(AbstractSlide.READY, playQueued);
				currentSlide.addEventListener(AbstractSlide.COMPLETE, handleSlideFinished);
				currentSlide.addEventListener(AbstractSlide.TRANSITION_IN_COMPLETE, handleCurrentSlideTransitionInComplete);
				bringToTop(currentSlide);
				currentSlide.transitionIn();
				
				notifyNextPlaying();
				_running = true;
			}
			else
			{
				logger.warn("oh feck! queued slide not ready: "  +queuedSlide);
				queuedSlide.addEventListener(AbstractSlide.READY, playQueued);
			}
		}

		private function handleCurrentSlideTransitionInComplete(event : Event) : void
		{
			if(slideToDispose)
			{
				logger.debug("disposing: " + slideToDispose);
				if(contains(slideToDispose))removeChild(slideToDispose);
				slideToDispose.dispose();
				slideToDispose.removeEventListener(AbstractSlide.COMPLETE, handleSlideFinished);
				slideToDispose.addEventListener(AbstractSlide.TRANSITION_IN_COMPLETE, handleCurrentSlideTransitionInComplete);
				slideToDispose = null;
			}
		}
		
		protected function handleSlideFinished(event:Event):void
		{
			logger.debug("slide finished.");
			playQueued();
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
