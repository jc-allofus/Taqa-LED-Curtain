package com.allofus.taqa.led.view.mediator
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.slides.ScrollingTextSlide;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class ScrollingTextSlideMediator extends Mediator
	{
		
		[Inject] public var view:ScrollingTextSlide;
		
		override public function onRegister():void
		{
			logger.fatal("create a settings proxy and set speed here  " + view);
			//view.scrollingSpeed = ;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ScrollingTextSlideMediator );
	}
}
