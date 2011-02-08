package com.allofus.taqa.led.view.preferences
{
	import net.hires.debug.Stats;

	import com.allofus.shared.logging.GetLogger;
	import com.bit101.components.Component;
	import com.bit101.components.Style;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jc
	 * these constants below could probably be re-factored into a "PreferencesModel"
	 */
	public class PreferencesPane extends Sprite
	{
		//events
		public static const TOGGLE_PREF_PANE:String = "show/hidePrefPane";
		public static const UPDATE:String = "preferencepane/updatePrefs";
		
		protected var page1:PositionPreferences;
		
		protected var page2:TypeStylePreferences;
		
		protected var _sampleArabicString:String;
		
		public function PreferencesPane(sampleArabicString:String = null)
		{
			visible = true;
			_sampleArabicString = sampleArabicString;
			if(!stage)
			{
				addEventListener(Event.ADDED_TO_STAGE, initPanel);
			}
			else
			{
				initPanel();
			}
		}
		
		protected function initPanel(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initPanel);
			
			Style.setStyle(Style.DARK);
			Component.initStage(stage);
			
			page1 = new PositionPreferences();
			page1.addEventListener(PositionPreferences.CHANGED, handlePositinoPrefsChanged);			addChild(page1);
			
			page2 = new TypeStylePreferences(_sampleArabicString);
			page2.addEventListener(PositionPreferences.CHANGED, handlePositinoPrefsChanged);
			addChild(page2);
			
			addChild(new Stats());
			
			showPage(1);
		}

		protected function handlePositinoPrefsChanged(event : Event) : void
		{
			dispatchEvent(new Event(UPDATE));
		}
		


		public function toggleHidden() : void
		{
			visible = !visible;
		}
		
		public function showPage(pageNum:uint = 1):void
		{
			switch(pageNum)
			{
				case 1:
					page1.visible = true;
					page2.visible = false;
					break;
					
				case 2:
					page1.visible = false;
					page2.visible = true;
					break;
			}
		}
		

				

		private static const logger : ILogger = GetLogger.qualifiedName(PreferencesPane);
	}
}
