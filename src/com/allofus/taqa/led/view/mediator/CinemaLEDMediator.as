package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.view.CinemaLED;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author jc
	 */
	public class CinemaLEDMediator extends Mediator
	{
		[Inject] public var view:CinemaLED;
		
		public function CinemaLEDMediator()
		{
		}
	}
}
