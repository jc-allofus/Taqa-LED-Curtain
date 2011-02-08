package com.allofus.taqa.led.model.vo
{
	/**
	 * @author jc
	 */
	public interface ISlideVO
	{
		function get id():String;
		function set id(id:String):void;
		
		function get isHeadlineContent():Boolean;
		function set isHeadlineContent(value:Boolean):void;
		
		function get type():String; //read-only
	}
}