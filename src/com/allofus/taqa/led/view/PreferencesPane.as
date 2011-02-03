package com.allofus.taqa.led.view
{
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
		
		//SMALL LED SOURCE-> 848 x 34
		public static var SHOW_SMALL_VIDEO_SOURCE:Boolean = true;
		public static var SHOW_SMALL_VIDEO_TESTPATTERN:Boolean = true;
		public static var SMALL_BANNER_X:int = 75;
		public static var SMALL_BANNER_Y:int = 150;
		public var sbx:NumericStepper;
		public var sby:NumericStepper;
		
		//CINEMA LED -> 640 x 127
		public static var LARGE_BANNER_X:int = 75;
		public static var LARGE_BANNER_Y:int = 200;
		public var lbx:NumericStepper;
		public var lby:NumericStepper;
		
		//SLICED SMALL LED
		public static var SLICED_SMALL_BANNER_X:int = 800;
		public static var SLICED_SMALL_BANNER_Y:int = 200;
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
//			config.addEventListener(Event.COMPLETE, addListeners);
			config.parseXML(preferencesXML);
			
			addChild(new Stats());
			
			addListeners();
		}
		
		protected function addListeners():void
		{
			logger.fatal("ok lets try.");
			sbx.addEventListener(Event.CHANGE, onSBXChanged);
			sby.addEventListener(Event.CHANGE, onSBYChanged);
			lby.addEventListener(Event.CHANGE, onLBYChanged);
			lby.addEventListener(Event.CHANGE, onLBYChanged);
		}
		
		public static function get preferencesXML():XML
		{
			var xml:XML=
			<comps>
    			<Panel x="75" y="0" width={ApplicationGlobals.APP_WIDTH-75}>
    				<HBox>
    				
    				<!-- SMALL LED SOURCE -->
    				<Window width="200" title="Small LED source:">
	        			<VBox x="10" y="10">
	        				<CheckBox id="showSmallBannerSource" 		label="Show small banner source " selected={SHOW_SMALL_VIDEO_SOURCE} />
	        				<CheckBox id="showSmallBannerTestPattern" 	label="show " selected={SHOW_SMALL_VIDEO_TESTPATTERN} />
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="sbx" value={SMALL_BANNER_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="sby" value={SMALL_BANNER_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
        			</Window>
        			
        			<!-- Cinema BANNER SOURCE -->
    				<Window width="200" title="Cinema Banner:">
	        			<VBox x="10" y="10">
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="lbx" value={LARGE_BANNER_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="lby" value={LARGE_BANNER_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
        			</Window>
        			
        			<!-- SLICED SMALL BANNER -->
        			<Window width="200" title="Sliced Cinema LED:">
	        			<VBox x="10" y="10">
	        				<HBox>
	        					<Label text="x:" />
		            			<NumericStepper id="ssbx" value={SLICED_SMALL_BANNER_X} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_WIDTH} repeatTime="10" />
		            		</HBox>
		            		<HBox>
	        					<Label text="y:" />
		            			<NumericStepper id="ssby" value={SLICED_SMALL_BANNER_Y} labelPrecision="1" minimum="0" maximum={ApplicationGlobals.APP_HEIGHT} repeatTime="10" />
		            		</HBox>
	        			</VBox>
        			</Window>
        			
        		 </HBox>
    			</Panel>
			</comps>;
			
			return xml;
		}
		
		public function onSBXChanged(event:Event = null):void
		{
			logger.fatal("BLAM!" + sbx.value);	
		}
		
		public function onSBYChanged(event:Event = null):void
		{
			logger.fatal("BLAM!" + sby.value);	
		}
		
		public function onLBXChanged(event:Event = null):void
		{
			logger.fatal("BLAM!" + sbx.value);	
		}
		
		public function onLBYChanged(event:Event = null):void
		{
			logger.fatal("BLAM!" + sby.value);	
		}

		public function toggleHidden() : void
		{
			visible = !visible;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(PreferencesPane);
	}
}
