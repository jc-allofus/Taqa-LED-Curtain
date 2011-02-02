package com.allofus.taqa.led.view
{
	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author jc
	 */
	public class EnglishScrollText extends Sprite
	{
		private static const SCROLL_SPEED : Number = 2;
		protected var labelText:String;
		protected var label:TextField;
		protected var startX:int;
		
		protected var defaultText:String = "And thus, through the serene tranquillities of the tropical sea, among waves whose hand-clappings were suspended by exceeding rapture, Moby Dick moved on, still withholding from sight the full terrors of his submerged trunk, entirely hiding the wrenched hideousness of his jaw. ";
		
		public function EnglishScrollText(value:String = null)
		{
			labelText = value || defaultText;
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = labelText;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.bold = true;
			tf.color = 0xFFFFFF;
			tf.size = 30;
			
			label.setTextFormat(tf);
			
			addChild(label);
			
		}
		
		public function startScrolling(fromX:int):void
		{
			logger.debug("START SCROLLING");
			label.x = fromX;
			addEventListener(Event.ENTER_FRAME, doScroll);
			label.visible = true;
		}

		private function doScroll(event : Event) : void
		{
			label.x -= SCROLL_SPEED;
		}
		
		public function stopScrolling():void
		{
			removeEventListener(Event.ENTER_FRAME, doScroll);
			label.visible = false;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( EnglishScrollText );
	}
}
