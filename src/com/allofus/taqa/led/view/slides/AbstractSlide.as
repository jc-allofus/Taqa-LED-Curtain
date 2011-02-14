package com.allofus.taqa.led.view.slides
{
	import com.allofus.shared.logging.GetLogger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.data.LoaderMaxVars;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class AbstractSlide extends Sprite implements IContentSlide
	{
		public static const READY:String = "abstractSlide/ready";
		public static const TRANSITION_IN_COMPLETE:String = "abstractSlide/transitionInComplete";
		public static const COMPLETE:String = "abstractSlide/complete";
		
		protected var loaderId:String = "slideContentLoader";
		protected var _ready:Boolean = false;
		protected var _loader:LoaderMax;
		
		public function AbstractSlide()
		{
			visible = false;
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
		
		public function transitionIn() : void
		{
			visible = true;
		}
		
		public function transitionOut() :void
		{
			visible = false;
		}
		
		protected function handleTransitionInComplete():void
		{
			dispatchEvent(new Event(TRANSITION_IN_COMPLETE));
		}
		
		protected function handleImageLoadComplete(event:LoaderEvent):void
		{
			//logger.debug("img load complete, marking as ready: " + event.target);
			_ready = true;
		}
		
		protected function onComplete():void
		{
			dispatchEvent(new Event(COMPLETE));
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
		
		public function dispose():void
		{
			logger.warn("nothing implemented for dispose on " + this );
		}
		
		public function set ready(value:Boolean):void
		{
			_ready = value;
			if (_ready)
			{
				dispatchEvent(new Event(AbstractSlide.READY));
			}
		}
		

		public function get ready() : Boolean
		{
			return _ready;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(AbstractSlide);

		
	}
}
