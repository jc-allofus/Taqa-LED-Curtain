package com.allofus.taqa.led.view.slides
{
	import flashx.textLayout.formats.TextLayoutFormat;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.model.Languages;
	import com.allofus.taqa.led.model.vo.PixelTextVO;
	import com.allofus.taqa.led.view.components.GradientBG;
	import com.allofus.taqa.led.view.text.IScrollState;
	import com.allofus.taqa.led.view.text.ScrollStateLTR;
	import com.allofus.taqa.led.view.text.ScrollStateRTL;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.taqa.led.view.text.TypeStyles;
	import com.allofus.taqa.ledcurtain.swcassets.SolarMask;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class PixelTextSlide extends AbstractSlide implements IScrollingContentSlide
	{
		protected static const AQUA:uint 		= 0x41b5aa;
		protected static const YELLOW:uint 		= 0xf5cc35;
		protected static const GREEN:uint 		= 0x84c347;
		protected static const RED:uint 		= 0xdc5a3c;
		protected static const PINK:uint 		= 0xb41e80;
		
		protected var COLORS:Array = [AQUA, YELLOW, GREEN, RED, PINK];
		
		protected var _vo:PixelTextVO;
		protected var _slideWidth:int;
		protected var _slideHeight:int;

		protected var _textSprite1:TLFContainer;
		protected var _textSprite2:TLFContainer;		

		protected var scrollState1:IScrollState;
		protected var scrollState2:IScrollState;
		
		protected var text1Color:uint = NaN;
		protected var text2Color:uint = NaN;
		
		protected var _gradientBG:GradientBG;
		protected var _maskClip:MovieClip;
		
		protected var _scrollingSpeed:Number = 2;
		
		public function PixelTextSlide(vo:PixelTextVO, width:int, height:int)
		{
			super();
			_vo = vo;
			_slideWidth = width;
			_slideHeight = height;
			
			//two lines of pixel text
			if(_vo.text2)
			{
				_gradientBG = new GradientBG(_slideWidth, _slideHeight, 0, 0);
				
				text1Color = getRandomColor();
				text2Color = getRandomColor();
				
				var fmt1:TextLayoutFormat = getTypeStyleForLanguage(_vo.text1Language);
				fmt1.color = text1Color;
				_textSprite1 = TLFTextManager.createText(_vo.text1, fmt1);
				scrollState1 = (_vo.text1Language == Languages.ENGLISH) ? new ScrollStateRTL(this, _textSprite1) : new ScrollStateLTR(this, _textSprite1);
				
				var fmt2:TextLayoutFormat = getTypeStyleForLanguage(_vo.text2Language);
				fmt2.color = text2Color;
				_textSprite2 = TLFTextManager.createText(_vo.text2, fmt2);
				scrollState2 = (_vo.text2Language == Languages.ENGLISH) ? new ScrollStateRTL(this, _textSprite2) : new ScrollStateLTR(this, _textSprite2);
				
			}
			else
			{
				_gradientBG = new GradientBG(_slideWidth, _slideHeight);
				
				_textSprite1 = TLFTextManager.createText(_vo.text1, getTypeStyleForLanguage(_vo.text1Language));
				scrollState1 = (_vo.text1Language == Languages.ENGLISH) ? new ScrollStateRTL(this, _textSprite1) : new ScrollStateLTR(this, _textSprite1);
			}
			
			addChild(_gradientBG);

			addChild(_textSprite1);
			scrollState1.initScroll();
			
			if(_textSprite2)			
			{
				addChild(_textSprite2);
				scrollState2.initScroll();
			}
			
			_maskClip = new SolarMask();
			_maskClip.gotoAndStop(1);
			addChild(_maskClip);
			mask = _maskClip;
			
			positionTextClips();
			
			ready = true;
		}
		
		override public function updateToPrefs():void
		{
			var fmt1:TextLayoutFormat = getTypeStyleForLanguage(_vo.text1Language);
			if(!isNaN(text1Color))fmt1.color = text1Color;
			_textSprite1.format = fmt1;
			if(_textSprite2)
			{
				var fmt2:TextLayoutFormat = getTypeStyleForLanguage(_vo.text2Language);
				fmt2.color = text2Color;
				_textSprite2.format = fmt2;
			}
			positionTextClips();
		}
		
		override public function transitionIn():void
		{
			visible = true;
			alpha = 1;
			_maskClip.play();
			addEventListener(Event.ENTER_FRAME, handleTransitioningIn);
		}
		
		protected function handleTransitioningIn(event:Event):void
		{
			if(_maskClip.currentFrame == _maskClip.totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, handleTransitioningIn);
				addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				handleTransitionInComplete();
			}
		}
		
		protected function handleEnterFrame(event : Event) : void
		{
			scrollState1.doScrollTick();
			
			if(scrollState2)
			{
				scrollState2.doScrollTick();
				if (scrollState1.isFinishedScrolling && scrollState2.isFinishedScrolling)
				{
					removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
					fadeOut();
				}
			}
			else
			{
				if (scrollState1.isFinishedScrolling)
				{
					removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
					fadeOut();
				}
			}
		}
		
		protected function fadeOut():void
		{
			TweenMax.to(this, ApplicationGlobals.FADE_DURATION, {alpha:0, onComplete:onComplete});
		}
		
		override public function dispose():void
		{
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			
			_vo = null;
			
			scrollState1.dispose();
			scrollState1 = null;
			
			if(scrollState2)
			{
				scrollState2.dispose();
				scrollState2 = null;			
			}
			
			_gradientBG = null;
			_maskClip = null;
		}
		
		protected function positionTextClips():void
		{
			if(_vo.text2)
			{
				_textSprite1.y = 5;
				_textSprite1.y += (_vo.text1Language == Languages.ENGLISH) ? TypeStyles.ES_offsetY : TypeStyles.AS_offsetY;
				
				_textSprite2.y = _slideHeight - _textSprite2.height -5;
				_textSprite2.y += (_vo.text2Language == Languages.ENGLISH) ? TypeStyles.ES_offsetY : TypeStyles.AS_offsetY;
				
			}
			else
			{
				_textSprite1.y = Math.round((_slideHeight * 0.5) - (_textSprite1.height * 0.5));
				_textSprite1.y += (_vo.text1Language == Languages.ENGLISH) ? TypeStyles.ES_offsetY : TypeStyles.AS_offsetY;
			}
		}
		
		protected function getTypeStyleForLanguage(value:String):TextLayoutFormat
		{
			var fmt:TextLayoutFormat;
			switch(value)
			{
				case Languages.ENGLISH:
					fmt = TypeStyles.englishSmall;
					break;
				
				case Languages.ARABIC:
					fmt = TypeStyles.arabicSmall;
					break;		
			}
			return fmt;
		}
		
		protected function getRandomColor():uint
		{
			//pick a random color then splice it so we cant have 2 randoms that are the same;
			var index:uint = Math.round(Math.random() * (COLORS.length -1));
			var color:uint = COLORS[index];
			COLORS.splice(index,1);
			return color;
		}

		public function get slideWidth() : Number
		{
			return _slideWidth;
		}

		public function get scrollingSpeed() : int
		{
			return _scrollingSpeed;
		}

		public function set scrollingSpeed(value : int) : void
		{
			_scrollingSpeed = value;
			if(scrollState1)scrollState1.speed = scrollingSpeed;
			if(scrollState2)scrollState2.speed = scrollingSpeed;
		}
		
		private static const logger : ILogger = GetLogger.qualifiedName(PixelTextSlide);
	}
}
