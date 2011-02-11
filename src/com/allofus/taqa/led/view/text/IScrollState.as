package com.allofus.taqa.led.view.text
{
	/**
	 * @author jc
	 */
	public interface IScrollState
	{
		function set speed(value:Number):void
		function initScroll():void
		function doScrollTick():void
		function get isFinishedScrolling():Boolean;
		function dispose():void
		
	}
}
