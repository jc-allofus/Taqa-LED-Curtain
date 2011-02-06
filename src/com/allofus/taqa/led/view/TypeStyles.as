package com.allofus.taqa.led.view
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
		
		public static function get englishSmall():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.RTL;
			f.fontFamily = "pixelEnglish";
			f.fontSize = ES_fontSize;
			f.color = ES_color;
			return f;
		}
	}
	
}
