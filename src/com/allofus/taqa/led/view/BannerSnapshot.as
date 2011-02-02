package com.allofus.taqa.led.view
{
	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author jc
	 */
	public class BannerSnapshot extends Sprite
	{
		protected var bmd1:BitmapData;
		protected var bmd2:BitmapData;
		protected var bmd3:BitmapData;
		protected var bmd4:BitmapData;
		
		protected var m2:Matrix;
		protected var m3:Matrix;
		protected var m4:Matrix;
		
		protected var bm1:Bitmap;
		protected var bm2:Bitmap;
		protected var bm3:Bitmap;
		protected var bm4:Bitmap;
		
		private static const OFFSET_X: int = 800;
		private static const OFFSET_Y:int = 200;
		
		protected var _source:DisplayObject;
		
		
		public function BannerSnapshot(source:DisplayObject)
		{
			_source = source;
			if(!stage)
			{
				addEventListener(Event.ADDED_TO_STAGE, initBannerSnapshot);
			}
			else
			{
				initBannerSnapshot();
			}
		}
		
		protected function initBannerSnapshot(e:Event = null):void
		{
			var r1:Rectangle = _source.getBounds(_source);	
			logger.fatal("r1: " + r1);
			var r2:Rectangle = _source.getBounds(stage);
			logger.fatal("r2: " + r2);
			
			bmd1 = new BitmapData(217, 34,false,0xFFFFFF);
			bm1 = new Bitmap(bmd1);
			bm1.x = OFFSET_X;
			bm1.y = OFFSET_Y;
			addChild(bm1);
			
			bmd2 = new BitmapData(217, 34,false,0x00cc00);
			m2 = new Matrix(1,0,0,1,-217,0);
			bm2 = new Bitmap(bmd2);
			bm2.x = OFFSET_X;
			bm2.y = 35 + OFFSET_Y;
			addChild(bm2);
			
			bmd3 = new BitmapData(217, 34, false, 0x00cc00);
			m3 = new Matrix(1,0,0,1,-434,0);
			bm3 = new Bitmap(bmd3);
			bm3.x = OFFSET_X;
			bm3.y = 69 + OFFSET_Y;
			addChild(bm3);
			
			bmd4 = new BitmapData(197, 34, false, 0x00cc00);
			m4 = new Matrix(1,0,0,1,-651, 0);
			bm4 = new Bitmap(bmd4);
			bm4.x = OFFSET_X;
			bm4.y = 103 +OFFSET_Y;
			addChild(bm4);
			
			//bm1.rotation = bm2.rotation = bm3.rotation = bm4.rotation = 90;
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleEnterFrame(event : Event) : void
		{
			bmd1.draw(_source);
			bmd2.draw(_source, m2);
			bmd3.draw(_source, m3);
			bmd4.draw(_source, m4);
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( BannerSnapshot );
	}
}
