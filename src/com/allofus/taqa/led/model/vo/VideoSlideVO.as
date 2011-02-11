package com.allofus.taqa.led.model.vo
{

	/**
	 * @author jc
	 */
	public class VideoSlideVO implements ISlideVO
	{
		protected var _id:String;
		public var videoURL:String;
		public var _type:String;
		
		public function toString():String
		{
			return "[VideoSlideVO]: "
			+ "  id: " + _id 
			+ ", videoURL: " + videoURL 
			+ ", type: " + type
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
		
		public function set isHeadlineContent(value : Boolean) : void{}

		public function get type() : String
		{
			return _type;
		}

		public function set type(type : String) : void
		{
			_type = type;
		}
	}
}
