package com.allofus.taqa.led.view.preferences
{
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.view.TypeStyles;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HUISlider;
	import com.bit101.utils.MinimalConfigurator;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jcehle
	 */
	public class TypeStylePreferences extends Sprite
	{
		public static const FILE_ID:String = "prefs-fonts.xml";
		public static const CHANGED:String = "positinoPrefs/prefChanged";
		
		public var es_fontsize:HUISlider;
		public var es_color:ColorChooser;
		
		protected var englishSmallSample:TLFContainer;
		
		protected var config:MinimalConfigurator;
		
		public function TypeStylePreferences()
		{
			config = new MinimalConfigurator(this);
			config.parseXML(preferencesXML);
			
			englishSmallSample = TLFTextManager.createText("sample of english small text", TypeStyles.englishSmall);
			englishSmallSample.x = 15;
			englishSmallSample.y = 150;
			addChild(englishSmallSample);
			
			addListeners();
		}
		
		protected function addListeners():void
		{
			es_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			es_color.addEventListener(Event.CHANGE, handlePrefsChanged);
		}

		private function handlePrefsChanged(event : Event) : void
		{
			logger.warn("dispatch updated pos prefs");
			updateValues();
			updateSamples();
			dispatchEvent(new Event(CHANGED));
		}
		
		protected function updateValues():void
		{
			_xml..HUISlider.(@id == "es_fontsize").@value = TypeStyles.ES_fontSize = es_fontsize.value;
			_xml..ColorChooser.(@id == "es_color").@value = TypeStyles.ES_color = es_color.value;
		}
		
		protected function updateSamples():void
		{
			englishSmallSample.format = TypeStyles.englishSmall;
		}
		
		public static function get preferencesXML():XML
		{
			return _xml; 
		}
		
		public static function set preferencesXML(value:XML):void
		{
			_xml = value;
		}
		
		protected static var _xml:XML =
		<comps>
			<Panel x="70" y="0" width={ApplicationGlobals.APP_WIDTH-70}>
				<HBox>
				
					<!-- ENGLISH SMALL FONTS -->
					<Window width="200" title="English Small style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="es_fontsize" label="font size:" minimum="6" maximum="48" tick="1" labelPrecision="0" value={TypeStyles.ES_fontSize} />
	        				<ColorChooser id="es_color" label="color:" value={TypeStyles.ES_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			
    		 	</HBox>
			</Panel>
		</comps>;
		
		private static const logger:ILogger = GetLogger.qualifiedName(TypeStylePreferences);
	}
}
