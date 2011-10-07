package com.allofus.taqa.led.model
{
	/**
	 * @author jc
	 */
	public class SlideTypes
	{
		//small LED
		public static const IMAGE_SMALL:String 			= "s_led_image";		//display an image for a fixed amount of time, then fade out
		public static const VIDEO_SMALL:String 			= "s_led_video";		//play a video from start to finish then fade out
		public static const SCROLLING_TEXT_SMALL:String	= "s_led_text";			//scroll text across the screen (direction depends on language)
		public static const SCROLLING_TEXT_PIXEL:String	= "s_led_pixel_text";	//scroll english & arabic across the screen at the same time (not currently in use)
		public static const ENGLISH_AND_ARABIC:String 	= "ktf_stat";			//choose between either english or arabic, convert selected into SCROLLING_TEXT_SMALL
		
		//cinema LED
		public static const VIDEO_CINEMA:String			= "c_led_video";
		public static const IMAGE_CINEMA:String			= "c_led_image";
	}
}
