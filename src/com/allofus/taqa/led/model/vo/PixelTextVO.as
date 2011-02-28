package com.allofus.taqa.led.model.vo
{

	import flashx.textLayout.formats.TextLayoutFormat;
	/**
	 * @author jc
	 */
	public class PixelTextVO implements ISlideVO
	{
		//vars on interface
		protected var _id:String; //do NOT rely on this to be unique; should we add something to the api that gives us unique id?
		protected var _isHeadlineContent:Boolean;
		protected var _type:String;
		
		public var text1:String;
		public var text1Language:String;
//		public var text1Format:TextLayoutFormat;
		public var text2:String;
		public var text2Language:String;
//		public var text2Format:TextLayoutFormat;
		
		public function toString():String
		{
			return "[PixelTextVO]: " 
					+ "  id: " + id
					+ "  text1: " + text1
					+ "  text1Language: " + text1Language
//					+ "  text1Format: " + text1Format
					+ "  text2: " + text2
					+ "  text2Language: " + text2Language
//					+ "  text2Format: " + text2Format
					+ ", type: " + type
					+ ", isHeadlineContent: " + isHeadlineContent
					;
		}
		
		public function get id() : String
		{
			return _id;
		}
		
		public function set id(value : String) : void
		{
			_id = value;
		}

		public function get isHeadlineContent() : Boolean
		{
			return _isHeadlineContent;
		}
		
		public function set isHeadlineContent(value : Boolean) : void
		{
			_isHeadlineContent = value;
		}

		public function get type() : String
		{
			return _type;
		}

		public function set type(value : String) : void
		{
			_type = value;
		}
	}
}
