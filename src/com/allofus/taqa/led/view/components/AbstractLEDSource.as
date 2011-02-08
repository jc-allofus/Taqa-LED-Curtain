package com.allofus.taqa.led.view.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author jc
	 */
	public class AbstractLEDSource extends Sprite
	{
		public function AbstractLEDSource()
		{
		}
		
		protected function bringToTop(vp:DisplayObject):void
		{
			var ti:int = numChildren -1;
			setChildIndex(vp, ti);
		}
	}
}
