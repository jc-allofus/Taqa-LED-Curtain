package com.allofus.taqa.led.controller.startup
{
	import org.robotlegs.utilities.statemachine.StateEvent;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class PrepareModelCommand extends Command
	{
		
		[Inject] public var smallLEDProxy:SmallLEDProxy;
		
		[Inject] public var cinemaLEDProxy:CinemaLEDProxy;
		
		override public function execute():void
		{
			logger.info("preparing models...");
			logger.debug("smallLEDPRoxy: " + smallLEDProxy);
			logger.debug("cinemaLEDPRoxy: " + cinemaLEDProxy);
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.PREPARE_MODELS_SUCCESS));
		}
		private static const logger:ILogger = GetLogger.qualifiedName( PrepareModelCommand );
	}
}
