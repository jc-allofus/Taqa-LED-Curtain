package com.allofus.taqa.led.view.mediator
{
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * @author jc
	 */
	public class ApplicationMediator extends Mediator
	{
		
		[Inject] public var view:TaqaLEDCurtain;
		
		public function ApplicationMediator()
		{
		}
		
		public override function onRegister():void
		{
			eventMap.mapListener(view.stage, KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			//eventMap.mapListener(view.stage.
		}
		
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.P:
				case Keyboard.Q:
				case Keyboard.W:
					logger.info("dispatch to system (picked up by pref pane)");
					dispatch(event);
					break;
					
				case Keyboard.F:
					view.toggleFullscreen();
					break;
					
				default:
					break;
			}
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ApplicationMediator );
	}
}
