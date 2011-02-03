package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.view.PreferencesPane;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.Event;

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
			eventMap.mapListener(eventDispatcher, PreferencesPane.TOGGLE_PREF_PANE, handleTogglePrefPane);
		}
		
		protected function handleTogglePrefPane(event:Event):void
		{
			view.toggleHidden();
		}
	}
}
