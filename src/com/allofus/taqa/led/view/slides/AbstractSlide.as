package com.allofus.taqa.led.view.slides
{
	import com.greensock.loading.data.LoaderMaxVars;
	import com.allofus.shared.logging.GetLogger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;

	import mx.logging.ILogger;

	import flash.display.Sprite;

	/**
	 * @author jc
	 */
	public class AbstractSlide extends Sprite
	{
		protected var loaderId:String = "slideContentLoader";
		protected var _ready:Boolean = false;
		protected var _loader:LoaderMax;
		
		public function AbstractSlide()
		{
		}
		
		protected function getLoader():LoaderMax
		{
			if(!_loader)
			{
				var lmv:LoaderMaxVars = new LoaderMaxVars();
				lmv.name = loaderId;
				lmv.onError = handleLoadError;
				lmv.onFail = handleLoadFail;
				lmv.onIOError = handleIOError;
				_loader = new LoaderMax(lmv);
			}
			return _loader;
		}
		
		protected function handleImageLoadComplete(event:LoaderEvent):void
		{
			//logger.debug("img load complete, marking as ready: " + event.target);
			_ready = true;
		}
		
		protected function handleLoadError(event:LoaderEvent):void
		{
			logger.error("handleImageLoadError: " + event.target + " : " + event.text + " event: " + event);
		}
		
		protected function handleLoadFail(event:LoaderEvent):void
		{
			logger.error("handleImageLoadFail: " + event.target + " : " + event.text + " event: " + event);
		}
		
		protected function handleIOError(event:LoaderEvent):void
		{
			logger.error("handleImageIOError: " + event.target + " : " + event.text + " event: " + event);
		}

		public function get ready() : Boolean
		{
			return _ready;
		}
		private static const logger:ILogger = GetLogger.qualifiedName( AbstractSlide );
	}
}
