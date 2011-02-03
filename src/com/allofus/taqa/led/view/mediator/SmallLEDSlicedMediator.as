package com.allofus.taqa.led.view.mediator
{
	import com.allofus.taqa.led.view.SmallLEDSliced;

	/**
	 * @author jc
	 */
	public class SmallLEDSlicedMediator extends SmallLEDSourceMediator
	{
		
		[Inject] public var smallSlicedLED:SmallLEDSliced;
		
		public function SmallLEDSlicedMediator()
		{
			super();
		}
	}
}
