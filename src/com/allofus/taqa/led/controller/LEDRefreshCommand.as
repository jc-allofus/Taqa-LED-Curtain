package com.allofus.taqa.led.controller
{
	import com.allofus.taqa.led.controller.startup.PrepareModelCommand;
	import com.allofus.shared.logging.GetLogger;
	import mx.logging.ILogger;
	import com.allofus.taqa.led.controller.startup.FSMConstants;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import com.allofus.taqa.led.service.XMLFeedService;
	import com.allofus.taqa.led.model.CinemaLEDProxy;
	import com.allofus.taqa.led.model.SmallLEDProxy;
	import com.allofus.taqa.led.model.SettingsProxy;
	import com.allofus.taqa.led.model.ConfigProxy;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author chrismullany
	 */
	public class LEDRefreshCommand extends Command
	{
		[Inject] public var configProxy:ConfigProxy;
		
		[Inject] public var settingsProxy:SettingsProxy;
		
		[Inject] public var smallLEDProxy:SmallLEDProxy;
		
		[Inject] public var cinemaLEDProxy:CinemaLEDProxy;
		
		[Inject] public var xmlFeedService:XMLFeedService;
		
		override public function execute():void
		{
			logger.info("preparing models...");
			logger.debug("xmlFeedService: " + xmlFeedService);
			
			//load "global" settings
			xmlFeedService.retrieveFeed(configProxy.settingsFeedPath, settingsProxy);
			
			//load small LED content feed
			xmlFeedService.retrieveFeed(configProxy.smallLEDFeedPath, smallLEDProxy);
			
			//load cinema content feed
			xmlFeedService.retrieveFeed(configProxy.cinemaLEDFeedPath, cinemaLEDProxy);
			
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.PREPARE_MODELS_SUCCESS));
		}
		private static const logger:ILogger = GetLogger.qualifiedName( LEDRefreshCommand );

	}
}
