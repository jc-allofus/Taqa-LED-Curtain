package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import flash.events.NativeWindowBoundsEvent;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Mediator;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class PositionPreferencesMediator extends Mediator
	{
		[Inject] public var view:PositionPreferences;
		
		public function PositionPreferencesMediator()
		{
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(contextView.stage.nativeWindow, NativeWindowBoundsEvent.MOVE, handleMove);
			logger.fatal("check to see here if i got that stuff set..." );
			contextView.stage.nativeWindow.x = PositionPreferences.WINDOW_POSITION_X;
			contextView.stage.nativeWindow.y = PositionPreferences.WINDOW_POSITION_Y;
		}
		
		private function handleMove(event : NativeWindowBoundsEvent) : void
		{
			//logger.warn("i see window moving: " + event);
			PositionPreferences.WINDOW_POSITION_X = event.afterBounds.x;
			PositionPreferences.WINDOW_POSITION_Y = event.afterBounds.y;
			view.updateValues();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( PositionPreferencesMediator );
	}
}
