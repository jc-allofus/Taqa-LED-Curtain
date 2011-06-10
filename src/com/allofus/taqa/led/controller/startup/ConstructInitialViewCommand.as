package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.view.components.CinemaLED;
	import com.allofus.taqa.led.view.components.SmallLEDSliced;
	import com.allofus.taqa.led.view.components.SmallLEDSource;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;

	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class ConstructInitialViewCommand extends Command
	{
		[Inject] public var configProxy:ConfigProxy;
		
		override public function execute():void
		{
			logger.info("constructing initial view." );
			
			var main:TaqaLEDCurtain = contextView as TaqaLEDCurtain;
			
			var smallLEDSource:SmallLEDSource = new SmallLEDSource();
			main.addChild(smallLEDSource);
			
			var smallLEDSliced:SmallLEDSliced = new SmallLEDSliced(smallLEDSource);
			main.addChild(smallLEDSliced);
			
			var cinemaLED:CinemaLED = new CinemaLED();
			main.addChild(cinemaLED);
			
			var preferencesPane:PreferencesPane = new PreferencesPane(configProxy.randomArabic);
			main.addChild(preferencesPane);
			
			main.fullscreen(false); //default the app to fullscreen
			
			TLFTextManager.listFonts();
			
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.CONSTRUCTING_VIEW_COMPLETE));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ConstructInitialViewCommand );
	}
}
