package com.allofus.taqa.led.view.text
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.slides.IScrollingContentSlide;

	import mx.logging.ILogger;

	import flash.display.Sprite;



	/**
	 * @author jc
	 */
	public class ScrollStateRTL extends Sprite implements IScrollState
	{
		protected var _slide:IScrollingContentSlide;
		protected var _textSprite:TLFContainer;
		protected var _speed:Number;
		protected var _finishedScrolling:Boolean = false;
		
		public function ScrollStateRTL(slide:IScrollingContentSlide, textSprite:TLFContainer)
		{
			_slide = slide;
			_textSprite = textSprite;
			_speed = _slide.scrollingSpeed;
		}

		public function initScroll() : void
		{
			var w:Number = Math.round(_slide.slideWidth);
			_textSprite.x = w;
		}

		public function doScrollTick() : void
		{
			_textSprite.x -= _speed;
			//logger.debug("my x: " + _textSprite.x);
			_textSprite.refresh();
			if(_textSprite.x < - _textSprite.width)
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
