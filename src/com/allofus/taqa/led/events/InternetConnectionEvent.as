package com.allofus.taqa.led.events
{
	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class InternetConnectionEvent extends Event
	{
		public static const STATUS:String = "InternetConnectionEvent/Result";
		
		private var _isConnected:Boolean; //returns true if connectivity is established
		private var _isInitialState:Boolean; //used to 
		
		public function InternetConnectionEvent(type : String, isConnected:Boolean, isInitial:Boolean, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			_isConnected = isConnected;
			_isInitialState = isInitial;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new InternetConnectionEvent(type, isConnected, isInitialState);
		}
		
		override public function toString():String
		{
			return "[InternetConnectionEvent]: type" + type + " isConnected: " + isConnected + " isInitialState: " + isInitialState;
		}

		public function get isConnected() : Boolean
		{
			return _isConnected;
		}

		public function get isInitialState() : Boolean
		{
			return _isInitialState;
		}
	}
}
