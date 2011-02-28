package com.allofus.taqa.led.view.preferences
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.view.text.TLFContainer;
	import com.allofus.taqa.led.view.text.TypeStyles;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.utils.MinimalConfigurator;
	import mx.logging.ILogger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;



	/**
	 * @author jcehle
	 */
	public class TypeStylePreferences extends Sprite
	{
		public static const FILE_ID:String = "prefs-fonts.xml";
		public static const CHANGED:String = "positinoPrefs/prefChanged";
		
		public static var SHOW_SAMPLES:Boolean 	= true;
		public static var SLOW:int 				= 1;
		public static var MEDIUM:int 			= 5;
		public static var FAST:int 				= 10;
		
		public var showSamples:CheckBox;
		public var slow:HUISlider;
		public var medium:HUISlider;
		public var fast:HUISlider;
		
		public var es_fontsize:HUISlider;
		public var es_color:ColorChooser;
		public var es_offsetY:HUISlider;
		
		public var el_fontsize:HUISlider;
		public var el_color:ColorChooser;
		public var el_offsetY:HUISlider;
		
		public var as_fontsize:HUISlider;
		public var as_color:ColorChooser;
		public var as_offsetY:HUISlider;
		
		public var al_fontsize:HUISlider;
		public var al_color:ColorChooser;
		public var al_offsetY:HUISlider;
		
		protected var englishSmallLabel:Label;
		protected var englishSmallSample:TLFContainer;
		
		protected var englishLargeLabel:Label;
		protected var englishLargeSample:TLFContainer;
		
		protected var arabicSmallLabel:Label;
		protected var arabicSmallSample:TLFContainer;
		
		protected var arabicLargeLabel:Label;
		protected var arabicLargeSample:TLFContainer;
		
		protected var config:MinimalConfigurator;
		
		protected var sampleContainer:Sprite;
		protected var _sampleArabicString:String;
		
		private static const PADDING_VERTICAL:int = 5;
		
		public function TypeStylePreferences(sampleArabicString:String = null)
		{
			_sampleArabicString = sampleArabicString;
			
			sampleContainer = new Sprite();
			
			sampleContainer.graphics.beginFill(0, 0.9);
			sampleContainer.graphics.drawRect(0, 0, ApplicationGlobals.APP_WIDTH, ApplicationGlobals.APP_HEIGHT);
			
			config = new MinimalConfigurator(this);
			config.parseXML(preferencesXML);
			
			englishSmallLabel = new Label(sampleContainer,15,100,"English small sample:");
			englishSmallSample = TLFTextManager.createText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tellus mi, pretium ac tristique non, pharetra in nisl. Curabitur ac lorem odio. Sed at vestibulum sem.", TypeStyles.englishSmall);
			sampleContainer.addChild(englishSmallSample);
			
			englishLargeLabel = new Label(sampleContainer,15, 110, "English large sample:");
			englishLargeSample = TLFTextManager.createText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tellus mi, pretium ac tristique non, pharetra in nisl. Curabitur ac lorem odio. Sed at vestibulum sem.", TypeStyles.englishLarge);
			sampleContainer.addChild(englishLargeSample);
			
			arabicSmallLabel = new Label(sampleContainer,15, 120, "Arabic small example:");
			arabicSmallSample = TLFTextManager.createText(_sampleArabicString, TypeStyles.arabicSmall);
			sampleContainer.addChild(arabicSmallSample);
			
			arabicLargeLabel = new Label(sampleContainer, 15, 130, "Arabic large example:");
			arabicLargeSample = TLFTextManager.createText(_sampleArabicString, TypeStyles.arabicLarge);
			sampleContainer.addChild(arabicLargeSample);
			
			redraw();
			addListeners();
		}
		
		protected function addListeners():void
		{
			showSamples.addEventListener(MouseEvent.CLICK, handlePrefsChanged);
			slow.addEventListener(Event.CHANGE, handlePrefsChanged);
			medium.addEventListener(Event.CHANGE, handlePrefsChanged);
			fast.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			es_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			es_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			es_offsetY.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			el_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			el_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			el_offsetY.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			as_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			as_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			as_offsetY.addEventListener(Event.CHANGE, handlePrefsChanged);
			
			al_fontsize.addEventListener(Event.CHANGE, handlePrefsChanged);
			al_color.addEventListener(Event.CHANGE, handlePrefsChanged);
			al_offsetY.addEventListener(Event.CHANGE, handlePrefsChanged);
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
			_xml..CheckBox.(@id == "showSamples").@selected 	= SHOW_SAMPLES = showSamples.selected;
			_xml..HUISlider.(@id == "slow").@value 				= SLOW = slow.value;
			_xml..HUISlider.(@id == "medium").@value 			= SLOW = medium.value;
			_xml..HUISlider.(@id == "fast").@value 				= SLOW = fast.value;
			
			_xml..HUISlider.(@id == "es_fontsize").@value = TypeStyles.ES_fontSize = es_fontsize.value;
			_xml..ColorChooser.(@id == "es_color").@value = TypeStyles.ES_color = es_color.value;
			_xml..HUISlider.(@id == "es_offsetY").@value  = TypeStyles.ES_offsetY = es_offsetY.value;
			
			_xml..HUISlider.(@id == "el_fontsize").@value = TypeStyles.EL_fontSize = el_fontsize.value;
			_xml..ColorChooser.(@id == "el_color").@value = TypeStyles.EL_color = el_color.value;
			_xml..HUISlider.(@id == "el_offsetY").@value  = TypeStyles.EL_offsetY = el_offsetY.value;
			
			_xml..HUISlider.(@id == "as_fontsize").@value = TypeStyles.AS_fontSize = as_fontsize.value;
			_xml..ColorChooser.(@id == "as_color").@value = TypeStyles.AS_color = as_color.value;
			_xml..HUISlider.(@id == "as_offsetY").@value  = TypeStyles.AS_offsetY = as_offsetY.value;
			
			_xml..HUISlider.(@id == "al_fontsize").@value = TypeStyles.AL_fontSize = al_fontsize.value;
			_xml..ColorChooser.(@id == "al_color").@value = TypeStyles.AL_color = al_color.value;
			_xml..HUISlider.(@id == "al_offsetY").@value  = TypeStyles.AL_offsetY = al_offsetY.value;
		}
		
		
		public static function get preferencesXML():XML
		{
			return _xml; 
		}
		
		public static function set preferencesXML(value:XML):void
		{
			_xml = value;
			
			SHOW_SAMPLES = _xml..CheckBox.(@id == "showSamples").@selected == "true";
			SLOW = _xml..HUISlider.(@id == "slow").@value;
			MEDIUM = _xml..HUISlider.(@id == "medium").@value;
			FAST = _xml..HUISlider.(@id == "fast").@value;
			
			TypeStyles.ES_fontSize = _xml..HUISlider.(@id == "es_fontsize").@value;
			TypeStyles.ES_color = _xml..ColorChooser.(@id == "es_color").@value;
			TypeStyles.ES_offsetY = _xml..HUISlider.(@id == "es_offsetY").@value;
			
			TypeStyles.EL_fontSize = _xml..HUISlider.(@id == "el_fontsize").@value;
			TypeStyles.EL_color = _xml..ColorChooser.(@id == "el_color").@value;
			TypeStyles.EL_offsetY = _xml..HUISlider.(@id == "el_offsetY").@value;
			
			TypeStyles.AS_fontSize = _xml..HUISlider.(@id == "as_fontsize").@value;
			TypeStyles.AS_color = _xml..ColorChooser.(@id == "as_color").@value;
			TypeStyles.AS_offsetY = _xml..HUISlider.(@id == "as_offsetY").@value;
			
			TypeStyles.AL_fontSize = _xml..HUISlider.(@id == "al_fontsize").@value;
			TypeStyles.AL_color = _xml..ColorChooser.(@id == "al_color").@value;
			TypeStyles.AL_offsetY = _xml..HUISlider.(@id == "al_offsetY").@value;
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
			
			if(SHOW_SAMPLES)
			{
				if(!contains(sampleContainer))
				{
					addChildAt(sampleContainer, 0);
				}
			}
			else
			{
				if(contains(sampleContainer))
				{
					removeChild(sampleContainer);
				}
			}
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
				
					<!-- SPEED -->
					<Window width="175" title="Genaral">
						<VBox x="10" y="10" spacing="1">
							<CheckBox id="showSamples" label="show samples" maximum="35" labelPrecision="0" value={SHOW_SAMPLES} />
							<HUISlider id="slow" label="slow" maximum="20" labelPrecision="0" value={SLOW} />
							<HUISlider id="medium" label="med" maximum="20" labelPrecision="0" value={MEDIUM} />
							<HUISlider id="fast" label="fast" maximum="20" labelPrecision="0" value={FAST} />
						</VBox>
					</Window>
				
					<!-- ENGLISH SMALL FONTS -->
					<Window width="185" title="English Small style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="es_fontsize" label="font size:" minimum="6" maximum="48" tick="1" labelPrecision="0" value={TypeStyles.ES_fontSize} />
	        				<HUISlider id="es_offsetY" label="offset y:" minimum="-50" maximum="50" labelPrecision="0" value={TypeStyles.ES_offsetY} />
	        				<ColorChooser id="es_color" label="color:" value={TypeStyles.ES_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			<!-- ENGLISH LARGE FONTS -->
					<Window width="185" title="English Large style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="el_fontsize" label="font size:" minimum="6" maximum="80" tick="1" labelPrecision="0" value={TypeStyles.EL_fontSize} />
	        				<HUISlider id="el_offsetY" label="offset y:" minimum="-50" maximum="50" labelPrecision="0" value={TypeStyles.EL_offsetY} />
	        				<ColorChooser id="el_color" label="color:" value={TypeStyles.EL_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			<!-- ARABIC SMALL FONTS -->
					<Window width="185" title="Arabic Small style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="as_fontsize" label="font size:" minimum="6" maximum="48" tick="1" labelPrecision="0" value={TypeStyles.AS_fontSize} />
	        				<HUISlider id="as_offsetY" label="offset y:" minimum="-50" maximum="50" labelPrecision="0" value={TypeStyles.AS_offsetY} />
	        				<ColorChooser id="as_color" label="color:" value={TypeStyles.AS_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
	    			<!-- ARABIC LARGE FONTS -->
					<Window width="185" title="Arabic Large style:">
	        			<VBox x="10" y="10">
	        				<HUISlider id="al_fontsize" label="font size:" minimum="6" maximum="80" tick="1" labelPrecision="0" value={TypeStyles.AL_fontSize} />
	        				<HUISlider id="al_offsetY" label="offset y:" minimum="-50" maximum="50" labelPrecision="0" value={TypeStyles.AL_offsetY} />
	        				<ColorChooser id="al_color" label="color:" value={TypeStyles.AL_color} usePopup="true" />
	        			</VBox>
	    			</Window>
	    			
    		 	</HBox>
			</Panel>
		</comps>;
		
		private static const logger:ILogger = GetLogger.qualifiedName(TypeStylePreferences);
	}
}
