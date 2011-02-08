package com.allofus.taqa.led.view.components
{
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;

	import mx.logging.ILogger;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	/**
	 * @author jc
	 */
	public class SmallLEDSliced extends Sprite
	{
		protected var _source:SmallLEDSource;
		
		
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
		
		protected var bitmaps:Vector.<Bitmap>;
		
		public function SmallLEDSliced(source:SmallLEDSource)
		{
			_source = source;
			bitmaps = new Vector.<Bitmap>();
			if(!stage)
			{
				addEventListener(Event.ADDED_TO_STAGE, initBannerSnapshot);
			}
			else
			{
				initBannerSnapshot();
			}
		}
		
		public function updateToPrefs():void
		{
			x = PositionPreferences.SLICED_SMALL_LED_X;
			y = PositionPreferences.SLICED_SMALL_LED_Y;
			if(bitmaps.length > 0)
			{
				for (var i : int = 0; i < bitmaps.length; i++) 
				{
					bitmaps[i].rotation = PositionPreferences.SLICED_SMALL_LED_ROTATION;
					bitmaps[i].x = i* PositionPreferences.SLICED_SMALL_LED_SPACING;
				}
			}
			bm1.rotation = bm2.rotation = bm3.rotation = bm4.rotation = PositionPreferences.SLICED_SMALL_LED_ROTATION;
		}
		
		protected function initBannerSnapshot(e:Event = null):void
		{
			bmd1 = new BitmapData(217, 34,false,0xFFFFFF);
			bm1 = new Bitmap(bmd1);
			addChild(bm1);
			
			bmd2 = new BitmapData(217, 34,false,0x00cc00);
			m2 = new Matrix(1,0,0,1,-217,0);
			bm2 = new Bitmap(bmd2);
			addChild(bm2);
			
			bmd3 = new BitmapData(217, 34, false, 0x00cc00);
			m3 = new Matrix(1,0,0,1,-434,0);
			bm3 = new Bitmap(bmd3);
			addChild(bm3);
			
			bmd4 = new BitmapData(197, 34, false, 0x00cc00);
			m4 = new Matrix(1,0,0,1,-651, 0);
			bm4 = new Bitmap(bmd4);
			addChild(bm4);
			
			bitmaps.push(bm1,bm2,bm3,bm4);
			
			updateToPrefs();
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleEnterFrame(event : Event) : void
		{
			bmd1.draw(_source);
			bmd2.draw(_source, m2);
			bmd3.draw(_source, m3);
			bmd4.draw(_source, m4);
		}

		public function queueSlide(getNext : ISlideVO) : void
		{
			
		}
		
		private static const logger : ILogger = GetLogger.qualifiedName(SmallLEDSliced);
	}
}
