package com.allofus.taqa.led.view.components
{
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.Sprite;

	/**
	 * @author jc
	 */
	public class GradientBG extends Sprite
	{
		protected static const AQUA:Array 		= [0x1bb3a3, 0x179c8e];
		protected static const YELLOW:Array 	= [0xb39424, 0x997e1f];
		protected static const GREEN:Array 		= [0x67b31b, 0x589917];
		protected static const RED:Array 		= [0xb3371b, 0x992f17];
		protected static const VIOLET:Array 	= [0x321bb3, 0x2a1799];
		protected static const PINK:Array 		= [0xB31B7D, 0x99176b];
		
		protected static const COLORS:Array	= [AQUA, YELLOW, GREEN, RED, VIOLET, PINK];
		
		
		public function GradientBG(width:Number, height:Number, color1:uint = NaN, color2:Number = NaN)
		{
			var type:String = GradientType.LINEAR;
			var colors:Array;
			
			//if colors not provided, select a random from our COLORS array..
			if(isNaN(color1) || isNaN(color2))
			{
				colors = COLORS[Math.round(Math.random() * (COLORS.length-1) )];
			}
			else
			{
				colors = [color1, color2];
			}
			
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width, height, 90 * (Math.PI / 180));
			
			graphics.beginGradientFill(type, colors, alphas, ratios,matr, SpreadMethod.PAD);
			graphics.drawRect(0, 0, width, height);
		}
	}
}
