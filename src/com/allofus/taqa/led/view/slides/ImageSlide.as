package com.allofus.taqa.led.view.slides
{

	import flash.events.Event;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.data.ImageLoaderVars;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jc
	 */
	public class ImageSlide extends AbstractSlide implements IContentSlide
	{
		protected var _imgVO:ImageSlideVO;
		protected var imgContainer:Sprite;
		protected var timer:Timer;
		protected var _timeoutSeconds:int = 2;
		protected var _imageLoader:ImageLoader;

		public function ImageSlide(vo:ImageSlideVO):void
		{
			logger.debug("CONSTRUCTOR");
			_imgVO = vo;
			imgContainer = new Sprite();
			timer = new Timer(_timeoutSeconds * 1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			addChild(imgContainer);
			loadImage();
		}

		protected function loadImage():void
		{
			var lv:ImageLoaderVars = new ImageLoaderVars();
			lv.name = _imgVO.imageURL;
			lv.container = imgContainer;
			lv.onComplete = handleLoadComplete;
			lv.onError = handleLoadError;
			lv.onFail = handleLoadFail;
			lv.onIOError = handleIOError;
			lv.noCache = true;
			
			if(!_imgVO.imageURL)
			{
				logger.warn("Image slide doesn't have a url to load!!! " + _imgVO);
				ready = true;
				dispatchEvent(new Event(ERROR));
			}
			else
			{
				// Uncomment for broken image link recovery testing
				//if(Math.random() > 0.6) _imgVO.imageURL += "BROKENLINK";
				_imageLoader = new ImageLoader(_imgVO.imageURL, lv);
				_imageLoader.load();
			}
		}

		protected function handleLoadComplete(event:LoaderEvent):void
		{
			logger.debug("image finished loading " + (event.target as ImageLoader).content);
			ready = true;
		}

		override public function transitionIn():void
		{	
			visible = true;
			alpha = 1;
			TweenMax.from(this, 0.5, {alpha:0, onComplete:handleTransitionInComplete});
		}

		override protected function handleTransitionInComplete():void
		{
			timer.reset();
			timer.start();
			super.handleTransitionInComplete();
		}

		override public function dispose():void
		{
			logger.debug("dispose");
			if (_imageLoader) _imageLoader.dispose(true);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			timer = null;
			removeChild(imgContainer);
			imgContainer = null;
		}

		protected function handleTimerComplete(event:TimerEvent):void
		{
			// logger.debug("image finished, dispatch complete.");
			TweenMax.to(this, ApplicationGlobals.FADE_DURATION, {alpha:0, onComplete:onComplete});
		}


		private static const logger:ILogger = GetLogger.qualifiedName(ImageSlide);

		public function get timeoutSeconds():int
		{
			return _timeoutSeconds;
		}

		public function set timeoutSeconds(timeoutSeconds:int):void
		{
			_timeoutSeconds = timeoutSeconds;
			if(timer)
			{
				timer.delay = 1000 * _timeoutSeconds;
				if(timer.running)
				{
					timer.reset();
					timer.start();

				}
			}
		}
	}
}
