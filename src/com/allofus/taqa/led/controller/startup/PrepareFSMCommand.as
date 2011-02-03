package com.allofus.taqa.led.controller.startup
{
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;

	/**
	 * @author jc
	 */
	public class PrepareFSMCommand extends Command
	{
		override public function execute():void
		{
			var smInjector:FSMInjector = new FSMInjector( FSMConstants.FSM );
			var sm:StateMachine = new StateMachine(eventDispatcher);
			
			// map events in state change to commands in robotlegs
			commandMap.mapEvent(FSMConstants.LOAD_CONFIG, LoadConfigCommand);
			commandMap.mapEvent(FSMConstants.DETECT_INTERNET_CONNECTION, DetectInternetConnectionCommand);
			commandMap.mapEvent(FSMConstants.CHECK_APP_UPDATE, CheckApplicationUpdateCommand);
			commandMap.mapEvent(FSMConstants.CHECK_PREFERENCES, CheckPreferencesCommand);
			commandMap.mapEvent(FSMConstants.PREPARE_MODELS, PrepareModelCommand);
			commandMap.mapEvent(FSMConstants.CONSTRUCT_VIEW, ConstructInitialViewCommand);
			commandMap.mapEvent(FSMConstants.DO_APP_RUNNING, AppRunningCommand);
			commandMap.mapEvent(FSMConstants.DO_BOOTSTRAP_FAIL, DoBootstrapFailCommand);
			
			smInjector.inject(sm);
			dispatch(new StateEvent(StateEvent.ACTION));
		}
	}
}
