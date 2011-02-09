package com.allofus.taqa.led.view.slides
{

	import flash.events.TimerEvent;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.data.ImageLoaderVars;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.utils.Timer;
	/**
	 * @author jc
	 */
	public class ImageSlide extends AbstractSlide implements IContentSlide
	{
		protected var _imgVO:ImageSlideVO;
		protected var imgContainer:Sprite;
		protected var timer:Timer;
		
		public function ImageSlide(vo:ImageSlideVO):void
		{
			_imgVO = vo;
			imgContainer = new Sprite();
			timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			addChild(imgContainer);	
			loadImage();
		}
		
		protected function loadImage():void
		{
			_loader = super.getLoader();
			if(_loader)
			{
				var lv : ImageLoaderVars = new ImageLoaderVars();
				lv.name = _imgVO.imageURL;
				lv.container = imgContainer;
				lv.onComplete = handleLoadComplete;
				lv.onError = handleLoadError;
				lv.onFail = handleLoadFail;
				lv.onIOError = handleIOError;
				//lv.scaleX = lv.scaleY = 1.001;
				if(!_imgVO.imageURL)
				{
					logger.warn("Image slide doesn't have a url to load!!! " + _imgVO);
				}
				else
				{
					_loader.append(
						new ImageLoader(_imgVO.imageURL, lv)
					);
				}
				switch(_loader.status)
				{
					case LoaderStatus.READY:
					case LoaderStatus.PAUSED:
					case LoaderStatus.COMPLETED:
						_loader.load();
						break;

					case LoaderStatus.LOADING:
						//logger.info("loader already in loading state, should just pick up our append: " + _loader.status);
						break;
				}
			}
			else
			{
				logger.error("could not get a loader instance for " + _imgVO.imageURL);
			}
		}
		
		protected function handleLoadComplete(event:LoaderEvent):void
		{
			logger.debug("image finished loading");
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
			_loader.dispose(true);
			_loader = null;
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			timer = null;
			removeChild(imgContainer);
			imgContainer = null;
		}
		
		protected function handleTimerComplete(event:TimerEvent):void
		{
			logger.debug("image finished, dispatch complete.");
			onComplete();
		}
		
		
		private static const logger:ILogger = GetLogger.qualifiedName( ImageSlide );
	}
}
