package com.allofus.shared.logging.formatters.vo
{
	/**
	 * @author jcehle
	 */
	public class LogEventVO
	{
		protected var _message:String;
		protected var _level:int;
		protected var _category : String;
		protected var _date : Date;		protected var _time : Date;
		
		public function toString():String
		{
			return "[LogEventVO]: message: " + _message + " category: " + _category; 
		}

		public function get message() : String
		{
			return _message;
		}

		public function set message(message : String) : void
		{
			_message = message;
		}

		public function get level() : int
		{
			return _level;
		}

		public function set level(level : int) : void
		{
			_level = level;
		}

		public function get category() : String
		{
			return _category;
		}

		public function set category(category : String) : void
		{
			_category = category;
		}

		public function get date() : Date
		{
			return _date;
		}

		public function set date(date : Date) : void
		{
			_date = date;
		}

		public function get time() : Date
		{
			return _time;
		}

		public function set time(time : Date) : void
		{
			_time = time;
		}
		
	}
}
