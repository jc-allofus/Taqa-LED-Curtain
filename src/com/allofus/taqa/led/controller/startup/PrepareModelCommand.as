package com.allofus.taqa.led.controller.startup
{
	import com.allofus.taqa.led.model.SettingsProxy;
	import com.allofus.taqa.led.model.CinemaLEDProxy;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.model.SmallLEDProxy;
	import com.allofus.taqa.led.service.XMLFeedService;
	import mx.logging.ILogger;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;



	/**
	 * @author jc
	 */
	public class PrepareModelCommand extends Command
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
		private static const logger:ILogger = GetLogger.qualifiedName( PrepareModelCommand );
	}
}
