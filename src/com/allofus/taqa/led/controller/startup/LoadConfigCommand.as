package com.allofus.taqa.led.controller.startup
{
	import org.robotlegs.utilities.statemachine.StateEvent;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.ApplicationGlobals;
	import com.allofus.taqa.led.model.ConfigProxy;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	public class LoadConfigCommand extends Command
	{
		[Inject] public var configProxy:ConfigProxy;
		
		override public function execute():void
		{
			var file : File = File.applicationDirectory.resolvePath(ApplicationGlobals.CONFIG_XML);
			logger.info("Loading config file: " + file);
			attachListeners();
			configProxy.loadConfigFile(ApplicationGlobals.CONFIG_XML);
		}
		
		protected function attachListeners():void
		{
			configProxy.eventDispatcher.addEventListener(ConfigProxy.LOAD_COMPLETE, handleComplete);
			configProxy.eventDispatcher.addEventListener(ConfigProxy.LOAD_FAIL, handleFail);
		}
		
		protected function removeListeners():void
		{
			configProxy.eventDispatcher.removeEventListener(ConfigProxy.LOAD_COMPLETE, handleComplete);
			configProxy.eventDispatcher.removeEventListener(ConfigProxy.LOAD_FAIL, handleFail);
		}
		
		protected function handleComplete(event:Event):void
		{
			logger.debug("here the shizzle succeded, do something w/ it");
			removeListeners();
			//move the state machine along.
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.LOADING_CONFIG_SUCCESS));
		}
		
		protected function handleFail(event:Event):void
		{
			logger.fatal("there was issue loading the config file, app has no chance, im failing.");
			removeListeners();
			//crap on the state machine.
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.LOADING_CONFIG_FAILED));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( LoadConfigCommand );
	}
}
