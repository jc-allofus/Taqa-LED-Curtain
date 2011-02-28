package com.allofus.taqa.led.view.slides
{
	/**
	 * @author jc
	 */
	public interface IScrollingContentSlide
	{
		function get slideWidth():Number;
		
		function get scrollingSpeed():int;
		function set scrollingSpeed(value:int):void;
	}
}
