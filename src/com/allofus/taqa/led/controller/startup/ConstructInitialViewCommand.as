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
			
			var smallLEDSource:SmallLEDSource = new SmallLEDSource();
			contextView.addChild(smallLEDSource);
			
			var smallLEDSliced:SmallLEDSliced = new SmallLEDSliced(smallLEDSource);
			contextView.addChild(smallLEDSliced);
			
			var cinemaLED:CinemaLED = new CinemaLED();
			contextView.addChild(cinemaLED);
			
			var preferencesPane:PreferencesPane = new PreferencesPane(configProxy.randomArabic);
			contextView.addChild(preferencesPane);
			
			TLFTextManager.listFonts();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ConstructInitialViewCommand );
	}
}
