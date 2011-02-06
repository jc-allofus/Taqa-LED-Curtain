package com.allofus.taqa.led.view.mediator
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author jc
	 */
	public class PreferencesPaneMediator extends Mediator
	{
		[Inject] public var view:PreferencesPane;
		
		public function PreferencesPaneMediator()
		{
		}
		
		public override function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, KeyboardEvent.KEY_DOWN, handleKeyDown);
			eventMap.mapListener(view, PreferencesPane.UPDATE, handlePreferencesChanged);
		}
		
		
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.P:
					view.toggleHidden();
					break;
					
				case Keyboard.NUMBER_1:
					view.showPage(1);
					break;
					
				case Keyboard.NUMBER_2:
					view.showPage(2);
					break;
					
				default:
					break;
			}
		}
		
		protected function handlePreferencesChanged(event:Event):void
		{
			//relay to system
			dispatch(event);
		}
	}
}
