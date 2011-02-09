package com.allofus.taqa.led.view.preferences
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.taqa.led.view.text.TypeStyles;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.utils.MinimalConfigurator;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.logging.ILogger;



	/**
	 * @author jcehle
	 */
	public class TypeStylePreferences extends Sprite
	{
		public static const FILE_ID:String = "prefs-fonts.xml";
		public static const CHANGED:String = "positinoPrefs/prefChanged";
		
		public var es_fontsize:HUISlider;
		public var es_color:ColorChooser;
		
		public var el_fontsize:HUISlider;
		public var el_color:ColorChooser;
		
		public var as_fontsize:HUISlider;
		public var as_color:ColorChooser;
		
		public var al_fontsize:HUISlider;
		public var al_color:ColorChooser;
		
		protected var englishSmallLabel:Label;
		protected var englishSmallSample:TLFContainer;
		
		protected var englishLargeLabel:Label;
		protected var englishLargeSample:TLFContainer;
		
		protected var arabicSmallLabel:Label;
		protected var arabicSmallSample:TLFContainer;
		
		protected var arabicLargeLabel:Label;
		protected var arabicLargeSample:TLFContainer;
		
		protected var config:MinimalConfigurator;
		
		protected var _sampleArabicString:String;
		
		private static const PADDING_VERTICAL:int = 5;
		
		public function TypeStylePreferences(sampleArabicString:String = null)
		{
			
			_sampleArabicString = sampleArabicString;
			
			graphics.beginFill(0xffffff, 0.9);
			graphics.drawRect(0, 0, ApplicationGlobals.APP_WIDTH, ApplicationGlobals.APP_HEIGHT);
			
			config = new MinimalConfigurator(this);
			config.parseXML(preferencesXML);
			
			englishSmallLabel = new Label(this,15,100,"English small sample:");
			englishSmallSample = TLFTextManager.createText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tellus mi, pretium ac tristique non, pharetra in nisl. Curabitur ac lorem odio. Sed at vestibulum sem.", TypeStyles.englishSmall);
			addChild(englishSmallSample);
			
			englishLargeLabel = new Label(this,15, 110, "English large sample:");
			englishLargeSample = TLFTextManager.createText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tellus mi, pretium ac tristique non, pharetra in nisl. Curabitur ac lorem odio. Sed at vestibulum sem.", TypeStyles.englishLarge);
			addChild(englishLargeSample);
			
			arabicSmallLabel = new Label(this,15, 120, "Arabic small example:");
			arabicSmallSample = TLFTextManager.createText(_sampleArabicString, TypeStyles.arabicSmall);
			addChild(arabicSmallSample);
			
			arabicLargeLabel = new Label(this, 15, 130, "Arabic large example:");
			arabicLargeSample = TLFTextManager.createText(_sampleArabicString, TypeStyles.arabicLarge);
			addChild(arabicLargeSample);
			
			redraw();
			addListeners();
		}
		
		protected function addListeners():void
		{
			es_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			es_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			el_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			el_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			as_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			as_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			al_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			al_color.addEventListener(Event.CHANGE, handlePrefsChanged);
		}

		private function handlePrefsChanged(event : Event) : void
		{
			logger.warn("dispatch updated pos prefs");
			updateValues();
			redraw();
			dispatchEvent(new Event(CHANGED));
		}
		
		protected function updateValues():void
		{
			_xml..HUISlider.(@id == "es_fontsize").@value = TypeStyles.ES_fontSize = es_fontsize.value;
			_xml..ColorChooser.(@id == "es_color").@value = TypeStyles.ES_color = es_color.value;
			
			_xml..HUISlider.(@id == "el_fontsize").@value = TypeStyles.EL_fontSize = el_fontsize.value;
			_xml..ColorChooser.(@id == "el_color").@value = TypeStyles.EL_color = el_color.value;
			
			_xml..HUISlider.(@id == "as_fontsize").@value = TypeStyles.AS_fontSize = as_fontsize.value;
			_xml..ColorChooser.(@id == "as_color").@value = TypeStyles.AS_color = as_color.value;
			
			_xml..HUISlider.(@id == "al_fontsize").@value = TypeStyles.AL_fontSize = al_fontsize.value;
			_xml..ColorChooser.(@id == "al_color").@value = TypeStyles.AL_color = al_color.value;
		}
		
		
		public static function get preferencesXML():XML
		{
			return _xml; 
		}
		
		public static function set preferencesXML(value:XML):void
		{
			_xml = value;
			
			TypeStyles.ES_fontSize = _xml..HUISlider.(@id == "es_fontsize").@value;
			TypeStyles.ES_color = _xml..ColorChooser.(@id == "es_color").@value;
			
			TypeStyles.EL_fontSize = _xml..HUISlider.(@id == "el_fontsize").@value;
			TypeStyles.EL_color = _xml..ColorChooser.(@id == "el_color").@value;
			
			TypeStyles.AS_fontSize = _xml..HUISlider.(@id == "as_fontsize").@value;
			TypeStyles.AS_color = _xml..ColorChooser.(@id == "as_color").@value;
			
			TypeStyles.AL_fontSize = _xml..HUISlider.(@id == "al_fontsize").@value;
			TypeStyles.AL_color = _xml..ColorChooser.(@id == "al_color").@value;
		}
		
		protected function redraw():void
		{
			englishSmallSample.format = TypeStyles.englishSmall;
			positionUnder(englishSmallSample, englishSmallLabel);
			
			englishLargeSample.format = TypeStyles.englishLarge;
			positionUnder(englishLargeLabel, englishSmallSample);
			positionUnder(englishLargeSample, englishLargeLabel);
			
			arabicSmallSample.format = TypeStyles.arabicSmall;
			positionUnder(arabicSmallLabel, englishLargeSample);
			positionUnder(arabicSmallSample, arabicSmallLabel);
			
			arabicLargeSample.format = TypeStyles.arabicLarge;
			positionUnder(arabicLargeLabel, arabicSmallSample);
			positionUnder(arabicLargeSample, arabicLargeLabel);
		}
		
		protected function positionUnder(obj:DisplayObject, goesUnder:DisplayObject):void
		{
			obj.x = goesUnder.x;
			obj.y = goesUnder.y + goesUnder.height + PADDING_VERTICAL;
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
	    			
	    			<!-- ENGLISH LARGE FONTS -->
					<Window width="200" title="English Large style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="el_fontsize" label="font size:" minimum="6" maximum="80" tick="1" labelPrecision="0" value={TypeStyles.EL_fontSize} />
	        				<ColorChooser id="el_color" label="color:" value={TypeStyles.EL_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			<!-- ARABIC SMALL FONTS -->
					<Window width="200" title="Arabic Small style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="as_fontsize" label="font size:" minimum="6" maximum="48" tick="1" labelPrecision="0" value={TypeStyles.AS_fontSize} />
	        				<ColorChooser id="as_color" label="color:" value={TypeStyles.AS_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			<!-- ARABIC LARGE FONTS -->
					<Window width="200" title="Arabic Large style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="al_fontsize" label="font size:" minimum="6" maximum="80" tick="1" labelPrecision="0" value={TypeStyles.AL_fontSize} />
	        				<ColorChooser id="al_color" label="color:" value={TypeStyles.AL_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			
    		 	</HBox>
			</Panel>
		</comps>;
		
		private static const logger:ILogger = GetLogger.qualifiedName(TypeStylePreferences);
	}
}
