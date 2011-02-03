package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.view.SmallLEDSource;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author jc
	 */
	public class SmallLEDSourceMediator extends Mediator
	{
		[Inject] public var smallLED:SmallLEDSource;
		
		public function SmallLEDSourceMediator()
		{
		}
		
		
	}
}
