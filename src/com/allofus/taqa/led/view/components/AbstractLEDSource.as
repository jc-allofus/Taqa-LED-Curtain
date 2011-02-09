package com.allofus.taqa.led.view.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class AbstractLEDSource extends Sprite
	{
		
		public static const PLAYING_NEXT_SLIDE:String = "abstractLEDSource/playingNext";
		
		public function AbstractLEDSource()
		{
		}
		
		protected function notifyNextPlaying():void
		{
			dispatchEvent(new Event(PLAYING_NEXT_SLIDE));
		}
		
		protected function bringToTop(vp:DisplayObject):void
		{
			var ti:int = numChildren -1;
			setChildIndex(vp, ti);
		}
	}
}
