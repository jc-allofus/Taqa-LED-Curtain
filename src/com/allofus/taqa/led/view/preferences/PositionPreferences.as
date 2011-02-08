package com.allofus.taqa.led.view.preferences
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.bit101.components.CheckBox;
	import com.bit101.components.NumericStepper;
	import com.bit101.utils.MinimalConfigurator;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jcehle
	 */
	public class PositionPreferences extends Sprite
	{
		public static const FILE_ID:String = "prefs-position.xml";
		public static const CHANGED:String = "positinoPrefs/prefChanged";
		
		//SMALL LED SOURCE-> 848 x 34
		public static var SHOW_SMALL_LED_SOURCE:Boolean = true;
		public static var SHOW_SMALL_LED_TESTPATTERN:Boolean = true;
		public static var SMALL_LED_X:int = 75;
		public static var SMALL_LED_Y:int = 150;
		public var showSmallBannerSource:CheckBox;
		public var showSmallBannerTestPattern:CheckBox;
		public var sbx:NumericStepper;
		public var sby:NumericStepper;
		
		//CINEMA LED -> 640 x 127
		public static var CINEMA_LED_X:int = 75;
		public static var CINEMA_LED_Y:int = 200;
		public var lbx:NumericStepper;
		public var lby:NumericStepper;
		
		//SLICED SMALL LED
		public static var SLICED_SMALL_LED_X:int = 800;
		public static var SLICED_SMALL_LED_Y:int = 200;
		public static var SLICED_SMALL_LED_ROTATION:int = 25;
		public static var SLICED_SMALL_LED_SPACING:int = 0;
		public var ssbx:NumericStepper;
		public var ssby:NumericStepper;
		public var ssbr:NumericStepper;
		public var ssbs:NumericStepper;
		
		protected var config:MinimalConfigurator;		
		
		public function PositionPreferences()
		{
			config = new MinimalConfigurator(this);
			config.parseXML(preferencesXML);
			addListeners();
		}
		
		protected function addListeners():void
		{
			showSmallBannerSource.addEventListener(MouseEvent.CLICK, handlePrefsChanged);
			showSmallBannerTestPattern.addEventListener(MouseEvent.CLICK, handlePrefsChanged);
			sbx.addEventListener(Event.CHANGE, handlePrefsChanged);
			sby.addEventListener(Event.CHANGE, handlePrefsChanged);
			lbx.addEventListener(Event.CHANGE, handlePrefsChanged);
			lby.addEventListener(Event.CHANGE, handlePrefsChanged);
			ssbx.addEventListener(Event.CHANGE, handlePrefsChanged);
			ssby.addEventListener(Event.CHANGE, handlePrefsChanged);
			ssbr.addEventListener(Event.CHANGE, handlePrefsChanged);
			ssbs.addEventListener(Event.CHANGE, handlePrefsChanged);
		}
		
		protected function handlePrefsChanged(event:Event):void
		{
			updateValues();
			dispatchEvent(new Event(CHANGED));
		}
		
		protected function updateValues():void
		{
			//set XML & statics based on values from the components
			_xml..CheckBox.(@id == "showSmallBannerSource").@selected = SHOW_SMALL_LED_SOURCE = showSmallBannerSource.selected;
			_xml..CheckBox.(@id == "showSmallBannerTestPattern").@selected = SHOW_SMALL_LED_TESTPATTERN = showSmallBannerTestPattern.selected;
			_xml..NumericStepper.(@id == "sbx").@value = SMALL_LED_X = sbx.value;
			_xml..NumericStepper.(@id == "sby").@value = SMALL_LED_Y = sby.value;
			_xml..NumericStepper.(@id == "lbx").@value = CINEMA_LED_X = lbx.value;
			_xml..NumericStepper.(@id == "lby").@value = CINEMA_LED_Y = lby.value;
			_xml..NumericStepper.(@id == "ssbx").@value = SLICED_SMALL_LED_X = ssbx.value;
			_xml..NumericStepper.(@id == "ssby").@value = SLICED_SMALL_LED_Y = ssby.value;
			_xml..NumericStepper.(@id == "ssbr").@value = SLICED_SMALL_LED_ROTATION = ssbr.value;
			_xml..NumericStepper.(@id == "ssbs").@value = SLICED_SMALL_LED_SPACING = ssbs.value;
		}
	
		public static function get preferencesXML():XML
		{
			return _xml; 
		}
		
		public static function set preferencesXML(value:XML):void
		{
			_xml = value;
			//set statics based on values from XML
			SHOW_SMALL_LED_SOURCE = _xml..CheckBox.(@id == "showSmallBannerSource").@selected == "true";
			SHOW_SMALL_LED_TESTPATTERN = _xml..CheckBox.(@id == "showSmallBannerTestPattern").@selected == "true";
			SMALL_LED_X = _xml..NumericStepper.(@id == "sbx").@value;
			SMALL_LED_Y = _xml..NumericStepper.(@id == "sby").@value;
			CINEMA_LED_X = _xml..NumericStepper.(@id == "lbx").@value;
			CINEMA_LED_Y = _xml..NumericStepper.(@id == "lby").@value;
			SLICED_SMALL_LED_X = _xml..NumericStepper.(@id == "ssbx").@value;
			SLICED_SMALL_LED_Y = _xml..NumericStepper.(@id == "ssby").@value;
			SLICED_SMALL_LED_ROTATION = _xml..NumericStepper.(@id == "ssbr").@value;
			SLICED_SMALL_LED_SPACING = _xml..NumericStepper.(@id == "ssbs").@value;
		}
		
		protected static var _xml:XML =
			<comps>
				<Panel x="70" y="0" width={ApplicationGlobals.APP_WIDTH-70}>
					<HBox>
					
					<!-- SMALL LED SOURCE -->
					<Window width="200" title="Small LED source:">
	        			<VBox x="10" y="10">
	        				<CheckBox id="showSmallBannerSource" 		label="Show small LED source " selected={SHOW_SMALL_LED_SOURCE} />
	        				<CheckBox id="showSmallBannerTestPattern" 	label="show small LED test pattern" selected={SHOW_SMALL_LED_TESTPATTERN} />
	        				<HBox>
		            			<NumericStepper id="sbx" value={SMALL_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            			<Label text="x position" />
		            		</HBox>
		            		<HBox>
		            			<NumericStepper id="sby" value={SMALL_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            			<Label text="y position" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    			<!-- Cinema BANNER SOURCE -->
					<Window width="150" title="Cinema Banner:">
	        			<VBox x="10" y="10">
	        				<HBox>
		            			<NumericStepper id="lbx" value={CINEMA_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            			<Label text="x position" />
		            		</HBox>
		            		<HBox>
		            			<NumericStepper id="lby" value={CINEMA_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            			<Label text="y position" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    			<!-- SLICED SMALL BANNER -->
	    			<Window width="300" title="Sliced Small LED:">
	        			<VBox x="10" y="10">
	        				<HBox>
		            			<NumericStepper id="ssbx" value={SLICED_SMALL_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
	        					<Label text="x position" />
		            		</HBox>
		            		<HBox>
		            			<NumericStepper id="ssby" value={SLICED_SMALL_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
	        					<Label text="y position" />
		            		</HBox>
	            		</VBox>
		            	<VBox x="150" y="10">
		            		<HBox>
		            			<NumericStepper id="ssbr" value={SLICED_SMALL_LED_ROTATION} labelPrecision="1" minimum="0" maximum="360" repeatTime="10" />
	        					<Label text="rotation" />
		            		</HBox>
		            		<HBox>
		            			<NumericStepper id="ssbs" value={SLICED_SMALL_LED_SPACING} labelPrecision="1" minimum="0" maximum="150" repeatTime="10" />
	        					<Label text="spacing" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    		 </HBox>
				</Panel>
			</comps>;
			
		private static const logger:ILogger = GetLogger.qualifiedName(PositionPreferences);
	}

}