package com.allofus.taqa.led.view.text
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.slides.IScrollingContentSlide;

	import mx.logging.ILogger;


	/**
	 * @author jc
	 */
	public class ScrollStateLTR implements IScrollState
	{
		protected var _slide:IScrollingContentSlide;
		protected var _textSprite:TLFContainer;
		protected var _speed:Number;
		protected var _finishedScrolling:Boolean = false;
		
		public function ScrollStateLTR(slide:IScrollingContentSlide, textSprite:TLFContainer)
		{
			_slide = slide;
			_textSprite = textSprite;
			_speed = _slide.scrollingSpeed;
		}
		
		public function initScroll() : void
		{
			var w:Number = Math.round(_textSprite.width);
			_textSprite.x = -w;
		}

		public function doScrollTick() : void
		{
			_textSprite.x += _speed;
			logger.debug("my x: " + _textSprite.x);
			_textSprite.refresh();
			if(_textSprite.x > _slide.slideWidth)
			{
				_finishedScrolling = true;
			}
		}
		
		public function get speed() : Number
		{
			return _speed;
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
