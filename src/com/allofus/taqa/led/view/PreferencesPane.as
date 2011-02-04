package com.allofus.taqa.led.view
{
	import flash.events.MouseEvent;
	import com.bit101.components.CheckBox;
	import net.hires.debug.Stats;

	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.bit101.components.Component;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;

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
		public static const CHANGED:String = "preferencepane/prefChanged";
		
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
		public var ssbx:NumericStepper;
		public var ssby:NumericStepper;
		
		protected var config:MinimalConfigurator;
		
		
		public function PreferencesPane()
		{
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
			
			config = new MinimalConfigurator(this);
			config.parseXML(preferencesXML);
			
			addChild(new Stats());
			
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
		}

		protected function handlePrefsChanged(event:Event):void
		{
			updateValues();
			dispatchEvent(new Event(CHANGED));
		}
		
		protected function updateValues():void
		{
			_xml..CheckBox.(@id == "showSmallBannerSource").@selected = PreferencesPane.SHOW_SMALL_LED_SOURCE = showSmallBannerSource.selected;
			_xml..CheckBox.(@id == "showSmallBannerTestPattern").@selected = PreferencesPane.SHOW_SMALL_LED_TESTPATTERN = showSmallBannerTestPattern.selected;
			_xml..NumericStepper.(@id == "sbx").@value = PreferencesPane.SMALL_LED_X = sbx.value;
			_xml..NumericStepper.(@id == "sby").@value = PreferencesPane.SMALL_LED_Y = sby.value;
			_xml..NumericStepper.(@id == "lbx").@value = PreferencesPane.CINEMA_LED_X = lbx.value;
			_xml..NumericStepper.(@id == "lby").@value = PreferencesPane.CINEMA_LED_Y = lby.value;
			_xml..NumericStepper.(@id == "ssbx").@value = PreferencesPane.SLICED_SMALL_LED_X = ssbx.value;
			_xml..NumericStepper.(@id == "ssby").@value = PreferencesPane.SLICED_SMALL_LED_Y = ssby.value;
		}

		public function toggleHidden() : void
		{
			visible = !visible;
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
				<Panel x="75" y="0" width={ApplicationGlobals.APP_WIDTH-75}>
					<HBox>
					
					<!-- SMALL LED SOURCE -->
					<Window width="200" title="Small LED source:">
	        			<VBox x="10" y="10">
	        				<CheckBox id="showSmallBannerSource" 		label="Show small LED source " selected={SHOW_SMALL_LED_SOURCE} />
	        				<CheckBox id="showSmallBannerTestPattern" 	label="show small LED test pattern" selected={SHOW_SMALL_LED_TESTPATTERN} />
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="sbx" value={SMALL_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="sby" value={SMALL_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    			<!-- Cinema BANNER SOURCE -->
					<Window width="200" title="Cinema Banner:">
	        			<VBox x="10" y="10">
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="lbx" value={CINEMA_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="lby" value={CINEMA_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    			<!-- SLICED SMALL BANNER -->
	    			<Window width="200" title="Sliced Cinema LED:">
	        			<VBox x="10" y="10">
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="ssbx" value={SLICED_SMALL_LED_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="ssby" value={SLICED_SMALL_LED_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
	    			</Window>
	    			
	    		 </HBox>
				</Panel>
			</comps>;
				

		private static const logger : ILogger = GetLogger.qualifiedName(PreferencesPane);
	}
}
