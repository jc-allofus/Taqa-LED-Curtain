package com.allofus.taqa.led.view.components
{
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.model.Languages;
	import com.allofus.taqa.led.model.Themes;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;
	import com.allofus.taqa.led.view.slides.AbstractSlide;
	import com.allofus.taqa.led.view.text.IScrollState;
	import com.allofus.taqa.led.view.text.ScrollStateLTR;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.taqa.led.view.text.TypeStyles;

	/**
	 * @author jc
	 */
	public class ScrollingTextSlide extends AbstractSlide
	{
		protected var _vo:ScrollingTextVO;
		protected var _textSprite:TLFContainer;
		
		protected var _slideWidth:Number;
		protected var _slideHeight:Number;
		
		protected var scrollState:IScrollState;
		protected var _scrollStateLTR:ScrollStateLTR;
		
		public var scrollingSpeed:Number;
		
		public function ScrollingTextSlide(vo:ScrollingTextVO, width:Number, height:Number)
		{
			super();
			_vo = vo;
			_slideWidth = width;
			_slideHeight = height;
			
			_scrollStateLTR = new ScrollStateLTR(this);
			switch(vo.language)
			{
				case Languages.ENGLISH:
					scrollState = _scrollStateLTR;//TODO implement a RTL
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.englishLarge);
					break;
				
				case Languages.ARABIC:
					scrollState = _scrollStateLTR;
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.arabicLarge);
					break;				
			}
			
			switch(vo.theme)
			{
				case Themes.ATOMIC:
				case Themes.GENERIC:
				
					break;
					
				case Themes.GEOTHERMAL:
				case Themes.SOLAR:
				case Themes.WIND:
				break;
			}
			
			addChild(_textSprite);
			ready = true;
		}

		public function get slideWidth() : Number
		{
			return _slideWidth;
		}

		public function get slideHeight() : Number
		{
			return _slideHeight;
		}

		public function get textSprite() : TLFContainer
		{
			return _textSprite;
		}
	}
}
