package com.allofus.taqa.led.view.slides
{
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

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;


	/**
	 * @author jc
	 */
	public class ScrollingTextSlide extends AbstractSlide
	{
		protected var _vo:ScrollingTextVO;
		protected var _textSprite:TLFContainer;
		
		protected var _slideWidth:int;
		protected var _slideHeight:int;
		
		protected var scrollState:IScrollState;
		protected var _scrollStateLTR:ScrollStateLTR;
		protected var _scrollStateRTL:ScrollStateRTL;
		
		protected var _videoBG:LoopVideoPlayer;
		protected var _gradientBG:GradientBG;
		protected var _maskClip:MovieClip;
		
		public var scrollingSpeed:Number = 3;
		
		public function ScrollingTextSlide(vo:ScrollingTextVO, width:int, height:int)
		{
			super();
			_vo = vo;
			_slideWidth = width;
			_slideHeight = height;
			
			_scrollStateLTR = new ScrollStateLTR(this);
			_scrollStateRTL = new ScrollStateRTL(this);
			switch(vo.language)
			{
				case Languages.ENGLISH:
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.englishLarge);
					scrollState = _scrollStateRTL;
					break;
				
				case Languages.ARABIC:
					_textSprite = TLFTextManager.createText(vo.text, TypeStyles.arabicLarge);
					scrollState = _scrollStateLTR;
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
					vidBGs = [vo.bgVidsDir + "Geo.f4v", vo.bgVidsDir + "Geo.f4v"];
					_maskClip = new GeoMask();
					break;
					
				case Themes.SOLAR:
					vidBGs = [vo.bgVidsDir + "solar.f4v", vo.bgVidsDir + "solar.f4v"];
					_maskClip = new SolarMask();
					break;
					
				case Themes.WIND:
					vidBGs = [vo.bgVidsDir + "Wind.f4v", vo.bgVidsDir + "Wind.f4v"];
					_maskClip = new WindMask();
					break;
			}
			
			if(vidBGs)
			{
				_videoBG= new LoopVideoPlayer(_slideWidth, _slideHeight, vidBGs);
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
			scrollState.initScroll();
			visible = true;
			alpha = 1;
			_maskClip.play();
			addEventListener(Event.ENTER_FRAME, handleTransitioningIn);
//			TweenMax.from(this, 0.5, {alpha:0, onComplete:handleTransitionInComplete});
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
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			
			_vo = null;
			
			_scrollStateLTR.dispose();
			_scrollStateLTR = null;
			
			_scrollStateRTL.dispose();
			_scrollStateRTL = null;
			
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

		public function set textSprite(textSprite : TLFContainer) : void
		{
			_textSprite = textSprite;
		}
	}
}
