package
{
	import com.allofus.taqa.led.controller.WriteNewPreferencesCommand;
	import com.allofus.taqa.led.model.InternetConnectionProxy;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.view.mediator.SmallLEDSlicedMediator;
	import com.allofus.taqa.led.view.SmallLEDSliced;
	import com.allofus.taqa.led.view.mediator.CinemaLEDMediator;
	import com.allofus.taqa.led.view.CinemaLED;
	import com.allofus.taqa.led.view.mediator.SmallLEDSourceMediator;
	import com.allofus.taqa.led.view.SmallLEDSource;
	import com.allofus.taqa.led.view.mediator.PreferencesPaneMediator;
	import com.allofus.taqa.led.view.PreferencesPane;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.controller.startup.PrepareFSMCommand;
	import com.allofus.taqa.led.service.ApplicationUpdaterService;
	import com.allofus.taqa.led.service.PreferencesService;
	import com.allofus.taqa.led.view.mediator.ApplicationMediator;

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
			injector.mapSingleton(ConfigProxy);
			injector.mapSingleton(InternetConnectionProxy);
			injector.mapSingleton(SmallLEDProxy);
			injector.mapSingleton(CinemaLEDProxy);
			
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
			commandMap.mapEvent(PreferencesPane.CHANGED, WriteNewPreferencesCommand);
			
			//kick it off!
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( TaqaLEDCurtainContext );
	}
}
