package com.allofus.taqa.led.view.mediator
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.components.SmallLEDSliced;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class SmallLEDSlicedMediator extends Mediator
	{
		
		[Inject] public var view:SmallLEDSliced;
		
		public function SmallLEDSlicedMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, PreferencesService.UPDATED, handlePrefsUpdated);
		}

		protected function handlePrefsUpdated(event:Event):void
		{
			view.updateToPrefs();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDSlicedMediator );
	}
}
