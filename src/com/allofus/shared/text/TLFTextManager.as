package com.allofus.shared.text
{
	import com.allofus.taqa.led.view.text.TLFContainer;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.LineBreak;

	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.engine.FontLookup;
	import flash.text.engine.RenderingMode;
	/**
	 * @author jcehle
	 */
	public class TLFTextManager
	{
		
		public static const LOREM_IPSUM:String = "Alia detracto ex his, iriure sadipscing et qui, \nat nam aliquip adipiscing. Nisl tempor argumentum vix cu, ne ius ornatus platonem prodesset. Dolor solet nullam mei in. \nAd quo clita cotidieque theophrastus. Et labore referrentur nam. Rebum decore sanctus pri cu, animal alienum phaedrum ea es";
		
		public static var styleSheet:StyleSheet;
		
		public static function createText(copy : String = null, format:TextLayoutFormat = null) : TLFContainer
		{
			var txt : String = copy || LOREM_IPSUM;
			
			var container:TLFContainer = new TLFContainer();
			var flow:TextFlow = new TextFlow();
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement = new SpanElement();

			var controller : ContainerController = new ContainerController(container, NaN);
			flow.flowComposer.addController(controller);
			flow.format = format || getFormat();
			span.text = txt;
			p.addChild(span);
			flow.addChild(p);
			flow.flowComposer.updateAllControllers();
//			container.graphics.beginFill(0x00cc00, 0.5);
//			container.graphics.drawRect(0, 0, container.width, container.height);
			container.flow = flow;
			
			return container;
		}
		
		public static function getFormat():TextLayoutFormat
		{
			var f : TextLayoutFormat = new TextLayoutFormat();
			f.lineBreak = LineBreak.EXPLICIT;
			//f.fontLookup = FontLookup.EMBEDDED_CFF;
			f.direction = Direction.LTR;
			
			f.fontFamily = "Arial, ";
			f.fontSize = 20;
			f.color = 0xff0000;
			return f;
		}
		
		public static function listFonts():void
		{
			logger.info("embedded fonts: ");
			var fonts:Array = Font.enumerateFonts();
			for (var i:uint = 0; i < fonts.length; i++)
			{
				logger.debug("registered: " + fonts[i]["fontName"] + ", " + fonts[i]["fontStyle"] + ", " + fonts[i]["fontType"]);
				//MonsterDebugger.trace("------FONT: ", fonts[i]);
			}
		}
				
		//public static function
		private static const logger:ILogger = GetLogger.qualifiedName(TLFTextManager);
		
	}
}
