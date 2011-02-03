package com.allofus.taqa.led.view.mediator
{
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

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
		}
		
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.P:
					logger.fatal("toggle show/hide pref pane.");
					break;
			}
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ApplicationMediator );
	}
}
