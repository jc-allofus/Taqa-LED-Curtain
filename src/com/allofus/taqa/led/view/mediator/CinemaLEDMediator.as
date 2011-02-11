package com.allofus.taqa.led.view.mediator
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.CinemaLEDProxy;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.components.AbstractLEDSource;
	import com.allofus.taqa.led.view.components.CinemaLED;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class CinemaLEDMediator extends Mediator
	{
		[Inject] public var model:CinemaLEDProxy;
		
		[Inject] public var view:CinemaLED;
		
		public function CinemaLEDMediator()
		{
		}
		
		override public function onRegister():void
		{
			//listen for system events
			eventMap.mapListener(eventDispatcher, PreferencesService.UPDATED, handlePrefsUpdated);
			eventMap.mapListener(eventDispatcher, CinemaLEDProxy.UPDATED, handleModelUpdated);
			
			//listen for component events
			eventMap.mapListener(view, AbstractLEDSource.REQUEST_NEXT_SLIDE, handleNextSlidePlaying);
		}
		
		protected function handleModelUpdated(event:Event):void
		{
			logger.warn("debug, i see the update.");
			queueNextSlide();
		}
		
		protected function queueNextSlide():void
		{
			var vo:ISlideVO = model.getNext();
			if(vo)
			{
				view.queueSlide(vo);
			}
			else
			{
				logger.debug("tried to init small LED, but model has nothing yet; wait...");
			}
		}
		
		protected function handlePrefsUpdated(event:Event):void
		{
			view.updateToPrefs();
		}
		
		protected function handleNextSlidePlaying(event:Event):void
		{
			//we just started playing the slide that was queued so queue up the next one
			queueNextSlide();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( CinemaLEDMediator );
	}
}
