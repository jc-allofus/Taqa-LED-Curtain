package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.model.SmallLEDProxy;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.components.SmallLEDSource;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.Event;



	/**
	 * @author jc
	 */
	public class SmallLEDSourceMediator extends Mediator
	{
		[Inject] public var model:SmallLEDProxy;
		
		[Inject] public var view:SmallLEDSource;
		
		public function SmallLEDSourceMediator()
		{
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, PreferencesService.UPDATED, handlePrefsUpdated);
			initSmallLED();
		}
		
		protected function initSmallLED():void
		{
			view.queueSlide(model.getNext());
		}
		
		protected function handlePrefsUpdated(event:Event):void
		{
			view.updateToPrefs();
		}
		
		
	}
}
