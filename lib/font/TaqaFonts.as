package
{
	import flash.display.Sprite;
	import mx.core.FontAsset;
	import flash.text.Font;

	/**
	 * @author jc
	 */
	public class TaqaFonts extends Sprite
	{
		
		[Embed(source="IT Gaza Demo Prod.ttf", mimeType="application/x-font-truetype", fontName="pixelArabic", embedAsCFF="true")] // All
		public var PixelArabic:Class;
		[Embed(source="HelveticaNeueLTArabic-Bold.ttf", mimeType="application/x-font-truetype", fontName="helveticaArabic", embedAsCFF="true")] // All
		public var HelveticaArabic:Class;
		[Embed(source="Unibody 8-Regular.otf", mimeType="application/x-font-truetype", fontName="pixelEnglish", embedAsCFF="true")] // All
		public var PixelEnglish:Class;
		[Embed(source="FUTURAB.TTF", mimeType="application/x-font-truetype", fontName="futuraEnglish", embedAsCFF="true")] // All
		public var FuturaEnglish:Class;
		
		public function TaqaFonts()
		{
			super();
			FontAsset;
			registerFonts();
		}

		private function registerFonts() : void
		{
			Font.registerFont(PixelArabic);
			Font.registerFont(HelveticaArabic);
			Font.registerFont(PixelEnglish);
			Font.registerFont(FuturaEnglish);
			//add more if needed...
			//Font.registerFont(AnotherFontClass);
		}
	}
}
