package com.allofus.taqa.led.view.components
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.view.slides.AbstractSlide;

	import mx.logging.ILogger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class AbstractLEDSource extends Sprite
	{
		
		public static const REQUEST_NEXT_SLIDE:String = "abstractLEDSource/playingNext";
		
		//slide refs (text, video & image)
		protected var currentSlide:AbstractSlide;
		protected var queuedSlide:AbstractSlide;
		protected var slideToDispose:AbstractSlide;
		
		protected var _running:Boolean = false;
		
		public function AbstractLEDSource()
		{
		}
		
		public function queueSlide(vo : ISlideVO) : void
		{
			logger.debug("make & show a slide: " + vo.id + " - " + vo.type);
			
			queuedSlide = makeSlide(vo);
			if(queuedSlide)
			{
				addChild(queuedSlide);
			}
			else
			{
				logger.debug("we got null returned from a call to makeSlide() so request the next one.");
				dispatchEvent(new Event(AbstractLEDSource.REQUEST_NEXT_SLIDE));
				return;
			}
			
			if(currentSlide)
			{
				//wait to get finished event from slide
				//logger.info("i've got a queued slide, but i'm gonna chillax till the current dude is done playing...");
			}
			else
			{
				playQueued();
			}
		}
		
		protected function makeSlide(vo:ISlideVO):AbstractSlide
		{
			//implement in children
			logger.error("you must implement makeSlide() in your descendent class");
			return null;
		}
		
		protected function playQueued(event:Event = null):void
		{
			if(queuedSlide.ready)
			{
				//first update our references
				slideToDispose = currentSlide;
				currentSlide = queuedSlide;
				queuedSlide = null;
				
				//then get our new current slide transitioning in
				currentSlide.removeEventListener(AbstractSlide.READY, playQueued);
				currentSlide.addEventListener(AbstractSlide.COMPLETE, handleSlideFinished);
				currentSlide.addEventListener(AbstractSlide.TRANSITION_IN_COMPLETE, handleCurrentSlideTransitionInComplete);
				bringToTop(currentSlide);
				currentSlide.transitionIn();
				
				notifyNextPlaying();
				_running = true;
			}
			else
			{
				logger.warn("oh feck! queued slide not ready: "  +queuedSlide);
				queuedSlide.addEventListener(AbstractSlide.READY, playQueued);
			}
		}
		
		protected function handleCurrentSlideTransitionInComplete(event : Event) : void
		{
			if(slideToDispose)
			{
				logger.debug("disposing: " + slideToDispose);
				if(contains(slideToDispose))removeChild(slideToDispose);
				slideToDispose.dispose();
				slideToDispose.removeEventListener(AbstractSlide.READY, playQueued);
				slideToDispose.removeEventListener(AbstractSlide.COMPLETE, handleSlideFinished);
				slideToDispose.removeEventListener(AbstractSlide.TRANSITION_IN_COMPLETE, handleCurrentSlideTransitionInComplete);
				slideToDispose = null;
			}
		}
		
		protected function handleSlideFinished(event:Event):void
		{
			//logger.debug("slide finished.");
			playQueued();
		}		
		
		protected function notifyNextPlaying():void
		{
			dispatchEvent(new Event(REQUEST_NEXT_SLIDE));
		}
		
		protected function bringToTop(vp:DisplayObject):void
		{
			var ti:int = numChildren -1;
			setChildIndex(vp, ti);
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( AbstractLEDSource );
	}
}
