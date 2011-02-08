package
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.controller.WriteNewPreferencesCommand;
	import com.allofus.taqa.led.controller.startup.PrepareFSMCommand;
	import com.allofus.taqa.led.model.CinemaLEDProxy;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.model.InternetConnectionProxy;
	import com.allofus.taqa.led.model.SmallLEDProxy;
	import com.allofus.taqa.led.service.ApplicationUpdaterService;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.service.XMLFeedService;
	import com.allofus.taqa.led.view.components.CinemaLED;
	import com.allofus.taqa.led.view.components.SmallLEDSliced;
	import com.allofus.taqa.led.view.components.SmallLEDSource;
	import com.allofus.taqa.led.view.mediator.ApplicationMediator;
	import com.allofus.taqa.led.view.mediator.CinemaLEDMediator;
	import com.allofus.taqa.led.view.mediator.PreferencesPaneMediator;
	import com.allofus.taqa.led.view.mediator.SmallLEDSlicedMediator;
	import com.allofus.taqa.led.view.mediator.SmallLEDSourceMediator;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;
	import flash.display.DisplayObjectContainer;
	import mx.logging.ILogger;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

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
			injector.mapSingleton(ConfigProxy);
			injector.mapSingleton(InternetConnectionProxy);
			injector.mapSingleton(SmallLEDProxy);
			injector.mapSingleton(CinemaLEDProxy);
			injector.mapSingleton(XMLFeedService);
			
			//SERVICE			
			injector.mapSingleton(ApplicationUpdaterService);
			//injector.mapSingleton(UpdatePropertyInfoService);
			injector.mapSingleton(PreferencesService);
			
			//VIEW
			//mediate main view
			mediatorMap.mapView(TaqaLEDCurtain, ApplicationMediator);
			mediatorMap.createMediator(contextView); 
			
			mediatorMap.mapView(PreferencesPane, PreferencesPaneMediator);
			mediatorMap.mapView(SmallLEDSource, SmallLEDSourceMediator);
			mediatorMap.mapView(CinemaLED, CinemaLEDMediator);
			mediatorMap.mapView(SmallLEDSliced, SmallLEDSlicedMediator);
			
			//CONTROLLER
			commandMap.mapEvent(ContextEvent.STARTUP, PrepareFSMCommand);
			commandMap.mapEvent(PreferencesPane.UPDATE, WriteNewPreferencesCommand);
			
			//kick it off!
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( TaqaLEDCurtainContext );
	}
}
