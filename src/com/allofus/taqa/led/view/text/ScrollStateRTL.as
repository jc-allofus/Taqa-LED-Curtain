package com.allofus.taqa.led.view.text
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.components.ScrollingTextSlide;

	import mx.logging.ILogger;

	import flash.display.Sprite;

	/**
	 * @author jc
	 */
	public class ScrollStateRTL extends Sprite implements IScrollState
	{
		protected var _slide:ScrollingTextSlide;
		protected var _speed:Number;
		protected var _finishedScrolling:Boolean = false;
		
		public function ScrollStateRTL(slide:ScrollingTextSlide)
		{
			_slide = slide;
			_speed = _slide.scrollingSpeed;
		}

		public function initScroll() : void
		{
			var w:Number = _slide.slideWidth;
			_slide.textSprite.x = w;
		}

		public function doScrollTick() : void
		{
			_slide.textSprite.x -= _speed;
			_slide.textSprite.refresh();
			if(_slide.textSprite.x < - _slide.textSprite.width)
			{
				_finishedScrolling = true;
			}
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

		public function set speed(value : Number) : void
		{
			_speed = value;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ScrollStateRTL );
	}
}
