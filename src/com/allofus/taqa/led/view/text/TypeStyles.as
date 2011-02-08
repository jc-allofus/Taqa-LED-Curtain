package com.allofus.taqa.led.view.text
{
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.LineBreak;
	import flashx.textLayout.formats.TextLayoutFormat;

	import flash.text.engine.FontLookup;
	/**
	 * @author jcehle
	 */
	public class TypeStyles
	{
		//ENGLISH SMALL
		public static var ES_fontSize:Number = 20;
		public static var ES_color:uint = 0;
		
		//ENGLISH LARGE
		public static var EL_fontSize:Number = 25;
		public static var EL_color:uint = 0;
		
		//ARABIC SMALL
		public static var AS_fontSize:Number = 16;
		public static var AS_color:uint = 0;
		
		//ARABIC LARGE
		public static var AL_fontSize:Number = 26;
		public static var AL_color:uint = 0;
		
		public static function get englishSmall():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.RTL;
//			f.fontFamily = "pixelEnglish";
			f.fontFamily = "helveticaArabic";
			f.fontSize = ES_fontSize;
			f.color = ES_color;
			return f;
		}
		
		public static function get englishLarge():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.RTL;
			f.fontFamily = "futuraEnglish";
			f.fontSize = EL_fontSize;
			f.color = EL_color;
			return f;
		}
		
		public static function get arabicSmall():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.RTL;
//			f.fontFamily = "pixelEnglish";
			f.fontFamily = "pixelArabic";
			f.fontSize = AS_fontSize;
			f.color = AS_color;
			return f;
		}
		
		public static function get arabicLarge():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.RTL;
			f.fontFamily = "helveticaArabic";
			f.fontSize = AL_fontSize;
			f.color = AL_color;
			return f;
		}
		
	}
	
}
