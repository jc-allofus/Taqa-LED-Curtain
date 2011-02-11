package com.allofus.taqa.led.model.vo
{
	/**
	 * @author jc
	 */
	public class ImageSlideVO implements ISlideVO
	{
		//vars on interface
		protected var _id:String;
		protected var _isHeadlineContent:Boolean;
		protected var _type:String;
		
		//vars specific to this content type
		public var imageURL:String;
		
		public function toString():String
		{
			return "[ImageSlideVO]:" 
			+ "  id: " + id
			+ "  imageURL: " + imageURL
			+ "  isheadlineContent: " + isHeadlineContent
			+ ", TYPE: " + type;
		}

		public function get id() : String
		{
			return _id;
		}
		
		public function set id(id : String) : void
		{
			_id = id;
		}

		public function get type() : String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}

		public function get isHeadlineContent() : Boolean
		{
			return _isHeadlineContent;
		}

		public function set isHeadlineContent(isHeadlineContent : Boolean) : void
		{
			_isHeadlineContent = isHeadlineContent;
		}
	}
}
