package com.allofus.taqa.led.model.vo
{
	import com.allofus.taqa.led.model.SlideTypes;
	/**
	 * @author jc
	 */
	public class ImageSlideVO implements ISlideVO
	{
		//vars on interface
		protected var _id:String;
		protected var _isHeadlineContent:Boolean;
		
		//vars specific to this content type
		public var imageURL:String;
		public static const TYPE:String = SlideTypes.IMAGE_SMALL;
		
		public function toString():String
		{
			return "[ImageSlideVO]:" 
			+ "  id: " + id
			+ "  imageURL: " + imageURL
			+ "  isheadlineContent: " + isHeadlineContent
			+ ", TYPE: " + TYPE;
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
			return TYPE;
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
