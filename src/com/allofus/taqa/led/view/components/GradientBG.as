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
		protected static const AQUA:Array 		= [0x41b5aa, 0x008d80];
		protected static const YELLOW:Array 	= [0xf5cc35, 0xedb440];
		protected static const GREEN:Array 		= [0x84c347, 0x37732f];
		protected static const RED:Array 		= [0xdc5a3c, 0xa72c2a];
		protected static const VIOLET:Array 	= [0x332777, 0x1a0c3d];
		protected static const PINK:Array 		= [0xb41e80, 0x70055d];
		
		protected static const COLORS:Array	= [AQUA, YELLOW, GREEN, RED, VIOLET, PINK];
		
		
		public function GradientBG(width:Number, height:Number)
		{
			var type:String = GradientType.LINEAR;
			var colors:Array = COLORS[Math.round(Math.random() * (COLORS.length-1) )];
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width, height);
			
			graphics.beginGradientFill(type, colors, alphas, ratios,matr, SpreadMethod.PAD);
			graphics.drawRect(0, 0, width, height);
		}
	}
}
