package com.allofus.taqa.led.view.text
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.slides.ScrollingTextSlide;
	import mx.logging.ILogger;


	/**
	 * @author jc
	 */
	public class ScrollStateLTR implements IScrollState
	{
		protected var _slide:ScrollingTextSlide;
		protected var _speed:Number;
		protected var _finishedScrolling:Boolean = false;
		
		public function ScrollStateLTR(slide:ScrollingTextSlide)
		{
			_slide = slide;
			_speed = _slide.scrollingSpeed;
		}
		
		public function initScroll() : void
		{
			var w:Number = _slide.textSprite.width;
			_slide.textSprite.x = -w;
		}

		public function doScrollTick() : void
		{
			_slide.textSprite.x += _speed;
			_slide.textSprite.refresh();
			if(_slide.textSprite.x > _slide.slideWidth)
			{
				_finishedScrolling = true;
			}
		}

		public function set speed(value : Number) : void
		{
			_speed = value;
		}

		public function dispose() : void
		{
			if(_slide)
			{
				_slide = null;
			}
		}

		public function get isFinishedScrolling() : Boolean
		{
			return _finishedScrolling;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(ScrollStateLTR);


	}
}
