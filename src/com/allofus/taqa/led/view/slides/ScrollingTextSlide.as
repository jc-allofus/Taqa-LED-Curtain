package com.allofus.taqa.led.view.slides
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.model.Languages;
	import com.allofus.taqa.led.model.Themes;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;
	import com.allofus.taqa.led.view.components.GradientBG;
	import com.allofus.taqa.led.view.text.IScrollState;
	import com.allofus.taqa.led.view.text.ScrollStateLTR;
	import com.allofus.taqa.led.view.text.ScrollStateRTL;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.taqa.led.view.text.TypeStyles;
	import com.allofus.taqa.led.view.video.LoopVideoPlayer;
	import com.allofus.taqa.ledcurtain.swcassets.AtomicMask;
	import com.allofus.taqa.ledcurtain.swcassets.GeoMask;
	import com.allofus.taqa.ledcurtain.swcassets.SolarMask;
	import com.allofus.taqa.ledcurtain.swcassets.WindMask;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;


	/**
	 * @author jc
	 */
	public class ScrollingTextSlide extends AbstractSlide implements IScrollingContentSlide
	{
		protected var _vo:ScrollingTextVO;
		protected var _textSprite:TLFContainer;

		protected var _slideWidth:int;
		protected var _slideHeight:int;

		protected var scrollState:IScrollState;

		protected var _videoBG:LoopVideoPlayer;
		protected var _gradientBG:GradientBG;
		protected var _maskClip:MovieClip;

		protected var _scrollingSpeed:int = 2;

		public function ScrollingTextSlide(vo:ScrollingTextVO, width:int, height:int)
		{
			super();
			_vo = vo;
			_slideWidth = width;
			_slideHeight = height;

			switch(vo.language)
			{
				case Languages.ENGLISH:
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.englishLarge);
					scrollState = new ScrollStateRTL(this, _textSprite);
					break;
					
				case Languages.ARABIC:
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.arabicLarge);
					scrollState = new ScrollStateLTR(this, _textSprite);
					break;
					
				default:
					logger.error("language not set in " + vo.toString());
					break;
			}

			var vidBGs:Array;
			switch(vo.theme)
			{
				case Themes.ATOMIC:
					vidBGs = [vo.bgVidsDir + "atomic.f4v", vo.bgVidsDir + "atomic.f4v"];
					_maskClip = new AtomicMask();
					break;

				case Themes.GENERIC:
					_gradientBG = new GradientBG(_slideWidth, _slideHeight);
					addChild(_gradientBG);
					_maskClip = new SolarMask();
					break;

				case Themes.GEOTHERMAL:
					vidBGs = [vo.bgVidsDir + "geo.f4v", vo.bgVidsDir + "geo.f4v"];
					_maskClip = new GeoMask();
					break;

				case Themes.SOLAR:
					vidBGs = [vo.bgVidsDir + "solar.f4v", vo.bgVidsDir + "solar.f4v"];
					_maskClip = new SolarMask();
					break;

				case Themes.WIND:
					vidBGs = [vo.bgVidsDir + "wind.f4v", vo.bgVidsDir + "wind.f4v"];
					_maskClip = new WindMask();
					break;
					
				default:
					logger.error("theme not set in " + vo.toString());
					break;
			}

			if(vidBGs)
			{
				_videoBG = new LoopVideoPlayer(_slideWidth, _slideHeight, vidBGs);
				addChild(_videoBG);
			}
			addChild(_textSprite);

			_maskClip.gotoAndStop(1);
			addChild(_maskClip);

			mask = _maskClip;

			ready = true;
		}

		override public function transitionIn():void
		{
			centerVertically(_textSprite);
			_textSprite.y += (_vo.language == Languages.ENGLISH) ? TypeStyles.EL_offsetY : TypeStyles.AL_offsetY;
			scrollState.initScroll();
			visible = true;
			alpha = 1;
			_maskClip.play();
			addEventListener(Event.ENTER_FRAME, handleTransitioningIn);
		}

		override public function updateToPrefs():void
		{
			switch(_vo.language)
			{
				case Languages.ENGLISH:
					_textSprite.format = TypeStyles.englishLarge;
					centerVertically(_textSprite);
					_textSprite.y += TypeStyles.EL_offsetY;
					break;

				case Languages.ARABIC:
					_textSprite.format = TypeStyles.arabicLarge;
					centerVertically(_textSprite);
					_textSprite.y += TypeStyles.AL_offsetY;
					break;
			}

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

		protected function handleEnterFrame(event:Event):void
		{
			scrollState.doScrollTick();
			if(scrollState.isFinishedScrolling)
			{
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				fadeOut();
			}
		}

		protected function fadeOut():void
		{
			TweenMax.to(this, ApplicationGlobals.FADE_DURATION, {alpha:0, onComplete:onComplete});
		}

		override public function dispose():void
		{
			TweenMax.killTweensOf(this);
			removeEventListener(Event.ENTER_FRAME, handleTransitioningIn);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			while(numChildren > 0)
			{
				removeChildAt(0);
			}

			_vo = null;

			scrollState.dispose();
			scrollState = null;

			if(_videoBG)
			{
				_videoBG.dispose();
			}
			_videoBG = null;

			_gradientBG = null;
			_maskClip = null;
		}

		protected function centerVertically(obj:DisplayObject):void
		{
			obj.y = Math.round((_slideHeight * 0.5) - (obj.height * 0.5));
		}

		public function get slideWidth():Number
		{
			return _slideWidth;
		}

		public function get slideHeight():Number
		{
			return _slideHeight;
		}

		public function get textSprite():TLFContainer
		{
			return _textSprite;
		}

		public function set textSprite(textSprite:TLFContainer):void
		{
			_textSprite = textSprite;
		}

		public function get scrollingSpeed():int
		{
			return _scrollingSpeed;
		}

		public function set scrollingSpeed(value:int):void
		{
			logger.debug("setting scrolling speed on text slide: " + value);
			_scrollingSpeed = value;
			if(scrollState) scrollState.speed = scrollingSpeed;
		}

		private static const logger:ILogger = GetLogger.qualifiedName(ScrollingTextSlide);
	}
}
