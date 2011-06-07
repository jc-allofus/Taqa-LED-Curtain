package com.allofus.taqa.led.view.mediator
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.SettingsProxy;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.preferences.TypeStylePreferences;
	import com.allofus.taqa.led.view.slides.PixelTextSlide;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class PixelTextSlideMediator extends Mediator
	{
		
		[Inject] public var view:PixelTextSlide;
		
		[Inject] public var settingsProxy:SettingsProxy;
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, PreferencesService.UPDATED, setScrollSpeed);
			eventMap.mapListener(eventDispatcher, SettingsProxy.UPDATE, onSettingsUpdated);
			//set initial speed:
			setScrollSpeed();
		}
		
		protected function onSettingsUpdated(event:Event =null):void
		{
			logger.debug("pixel text sees settings updated");
			setScrollSpeed();
		}
		
		protected function setScrollSpeed(event:Event = null):void
		{
			switch(settingsProxy.textScrollSpeed)
			{
				case "slow":
					view.scrollingSpeed = TypeStylePreferences.SLOW;
					break;
					
				case "med":
					view.scrollingSpeed = TypeStylePreferences.MEDIUM;
					break;
					
				case "fast":
					view.scrollingSpeed = TypeStylePreferences.FAST;
					break;
					
				default:
					view.scrollingSpeed = 2;
					break;
			}
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( PixelTextSlideMediator );
	}
}
