package com.allofus.taqa.led.model.vo
{

	import com.allofus.taqa.led.model.SlideTypes;
	/**
	 * @author jc
	 */
	public class VideoSlideVO implements ISlideVO
	{
		protected var _id:String;
		public var videoURL:String;
		public static const TYPE:String = SlideTypes.VIDEO_SMALL;
		
		public function toString():String
		{
			return "[VideoSlideVO]: "
			+ "  id: " + _id 
			+ ", videoURL: " + videoURL 
			+ ", type: " + TYPE
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

		//videos cannot be headline content
		public function get isHeadlineContent() : Boolean
		{
			return false;
		}

		public function get type() : String
		{
			return TYPE;
		}


		public function set isHeadlineContent(value : Boolean) : void
		{
		}
	}
}
