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
		
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/Al Abdali 8 Regular.otf", mimeType="application/x-font-truetype", fontName="pixelArabic", embedAsCFF="false")] // All
		public var PixelArabic:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/HelveticaNeueLTArabic-Bold.ttf", mimeType="application/x-font-truetype", fontName="helveticaArabic", embedAsCFF="false")] // All
		public var HelveticaArabic:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/Unibody 8-Regular.otf", mimeType="application/x-font-truetype", fontName="pixelEnglish", embedAsCFF="false")] // All
		public var PixelEnglish:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/FUTURAB.TTF", mimeType="application/x-font-truetype", fontName="futuraEnglish", embedAsCFF="false")] // All
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