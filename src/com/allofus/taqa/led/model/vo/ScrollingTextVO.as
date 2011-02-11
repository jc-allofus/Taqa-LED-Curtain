package com.allofus.taqa.led.model.vo
{

	import com.allofus.taqa.led.model.SlideTypes;
	/**
	 * @author jc
	 */
	public class ScrollingTextVO implements ISlideVO
	{
		protected var _id:String; //do NOT rely on this to be unique; should we add something to the api that gives us unique id?
		protected var _isHeadline:Boolean;
		public var text:String;
		public var language:String;
		public var theme:String;
		public var bgVidsDir:String;
		public static const TYPE:String = SlideTypes.SCROLLING_TEXT_SMALL;
		
		
		public function toString():String
		{
			return "[ScrollingTextVO]: "
			+ "  id: " + id
			+ ", isHeadline: " + isHeadlineContent
			+ ", language: " + language
			+ ", theme: " + theme
			+ ", vidsDir: " + bgVidsDir
			+ ", text" + text
			;
		}
		
		public function get id() : String
		{
			return _id;
		}
		
		public function set id(id : String) : void
		{
			_id = id;
		}

		public function get isHeadlineContent() : Boolean
		{
			return _isHeadline;
		}
		
		public function set isHeadlineContent(value : Boolean) : void
		{
			_isHeadline = value;
		}

		public function get type() : String
		{
			return TYPE;
		}
	}
}
