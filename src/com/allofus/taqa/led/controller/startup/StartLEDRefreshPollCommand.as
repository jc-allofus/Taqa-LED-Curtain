package com.allofus.taqa.led.controller.startup
{
	import com.allofus.taqa.led.model.LEDRefreshPollProxy;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author chrismullany
	 */
	public class StartLEDRefreshPollCommand extends Command
	{
		[Inject] public var ledRefreshPollProxy:LEDRefreshPollProxy;
		
		override public function execute():void
		{
			ledRefreshPollProxy.start();
		}
	}
}
