package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.model.SettingsProxy;
	import com.allofus.taqa.led.view.slides.ImageSlide;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class ImageSlideMediator extends Mediator
	{
		[Inject] public var view:ImageSlide;
		
		[Inject] public var settingsProxy:SettingsProxy;
		
		override public function onRegister():void
		{
			view.timeoutSeconds = settingsProxy.imageDisplaySeconds;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ImageSlideMediator );
	}
}
