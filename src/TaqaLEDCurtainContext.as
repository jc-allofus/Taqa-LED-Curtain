package
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.controller.WriteNewPreferencesCommand;
	import com.allofus.taqa.led.controller.startup.PrepareFSMCommand;
	import com.allofus.taqa.led.controller.startup.PrepareModelCommand;
	import com.allofus.taqa.led.model.CinemaLEDProxy;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.model.InternetConnectionProxy;
	import com.allofus.taqa.led.model.LEDRefreshPollProxy;
	import com.allofus.taqa.led.model.SettingsProxy;
	import com.allofus.taqa.led.model.SmallLEDProxy;
	import com.allofus.taqa.led.service.ApplicationUpdaterService;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.service.XMLFeedService;
	import com.allofus.taqa.led.view.components.CinemaLED;
	import com.allofus.taqa.led.view.components.SmallLEDSliced;
	import com.allofus.taqa.led.view.components.SmallLEDSource;
	import com.allofus.taqa.led.view.mediator.ApplicationMediator;
	import com.allofus.taqa.led.view.mediator.CinemaLEDMediator;
	import com.allofus.taqa.led.view.mediator.ImageSlideMediator;
	import com.allofus.taqa.led.view.mediator.PixelTextSlideMediator;
	import com.allofus.taqa.led.view.mediator.PositionPreferencesMediator;
	import com.allofus.taqa.led.view.mediator.PreferencesPaneMediator;
	import com.allofus.taqa.led.view.mediator.ScrollingTextSlideMediator;
	import com.allofus.taqa.led.view.mediator.SmallLEDSlicedMediator;
	import com.allofus.taqa.led.view.mediator.SmallLEDSourceMediator;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;
	import com.allofus.taqa.led.view.slides.ImageSlide;
	import com.allofus.taqa.led.view.slides.PixelTextSlide;
	import com.allofus.taqa.led.view.slides.ScrollingTextSlide;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import mx.logging.ILogger;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author jc
	 */
	public class TaqaLEDCurtainContext extends Context
	{
		public function TaqaLEDCurtainContext(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			//MODEL
			injector.mapSingleton(ConfigProxy); 									// loads config.xml; stores values from it for later access
			injector.mapSingleton(InternetConnectionProxy); 						// keeps track of user's internet connection
			injector.mapSingleton(SettingsProxy); 									// parses & stores results from SettingsFeed (defined in config.xml)
			injector.mapSingleton(SmallLEDProxy); 									// parses & stores results from SmallLEDFeed (defined in config.xml)
			injector.mapSingleton(CinemaLEDProxy);	 								// parses & stores results from CinemaLEDFeed (defined in config.xml)
			injector.mapSingleton(LEDRefreshPollProxy);								// Polls the CMS to frequently check for updates to content
			
			//SERVICE			
			injector.mapSingleton(XMLFeedService);									// loads remote xml & pushes result into specified proxy
			injector.mapSingleton(ApplicationUpdaterService);						// checks remote update.xml to see if a newer build is available
			injector.mapSingleton(PreferencesService);								// reads/writes the prefs xml files
			
			//VIEW
			//mediate main view
			mediatorMap.mapView(TaqaLEDCurtain, ApplicationMediator);				// document class
			mediatorMap.createMediator(contextView); 								// mediate document class
			
			mediatorMap.mapView(PreferencesPane, PreferencesPaneMediator);			
			mediatorMap.mapView(PositionPreferences, PositionPreferencesMediator);
			mediatorMap.mapView(SmallLEDSource, SmallLEDSourceMediator);
			mediatorMap.mapView(CinemaLED, CinemaLEDMediator);
			mediatorMap.mapView(SmallLEDSliced, SmallLEDSlicedMediator);
			mediatorMap.mapView(ScrollingTextSlide, ScrollingTextSlideMediator);
			mediatorMap.mapView(PixelTextSlide, PixelTextSlideMediator);
			mediatorMap.mapView(ImageSlide, ImageSlideMediator);
			
			//CONTROLLER
			commandMap.mapEvent(ContextEvent.STARTUP, PrepareFSMCommand);
			commandMap.mapEvent(PreferencesPane.UPDATE, WriteNewPreferencesCommand);
			commandMap.mapEvent(LEDRefreshPollProxy.UPDATE, PrepareModelCommand);		// Dispatched when LED content has been updated, triggers content refresh
			
			//kick it off!
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( TaqaLEDCurtainContext );
	}
}
