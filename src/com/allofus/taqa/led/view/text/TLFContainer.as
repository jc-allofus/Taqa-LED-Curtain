package com.allofus.taqa.led.view.text
{
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;

	import flash.display.Sprite;

	/**
	 * @author jcehle
	 */
	public class TLFContainer extends Sprite
	{
		
		protected var _flow:TextFlow;
		
		public function TLFContainer()
		{
		}
		
		public function refresh():void
		{
			_flow.flowComposer.updateAllControllers();
//			graphics.clear();
//			graphics.beginFill(0x00cc00);
//			graphics.drawRect(0, 0, width, height);
		}
		
		public function set format(format:TextLayoutFormat):void
		{
			_flow.format = format;
			refresh();
		}
		
		public function get flow() : TextFlow
		{
			return _flow;
		}

		public function set flow(flow : TextFlow) : void
		{
			_flow = flow;
		}
	}
}
