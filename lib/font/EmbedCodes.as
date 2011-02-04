package
{
	import mx.core.FontAsset;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.describeType;

	public class EmbedCodes extends Sprite
	{
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/Al Abdali 8 Regular.otf", mimeType="application/x-font-truetype", fontName="pixelArabic", embedAsCFF="false")] // All
		public var font0:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/HelveticaNeueLTArabic-Bold.ttf", mimeType="application/x-font-truetype", fontName="helveticaArabic", embedAsCFF="false")] // All
		public var font1:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/Unibody 8-Regular.otf", mimeType="application/x-font-truetype", fontName="pixelEnglish", embedAsCFF="false")] // All
		public var font2:Class;
		[Embed(source="/env/workspace_fdt/TaqaLEDCurtain/lib/font/FUTURAB.TTF", mimeType="application/x-font-truetype", fontName="font4", embedAsCFF="false")] // All
		public var font3:Class;

		public function EmbedCodes()
		{
			FontAsset;
			Security.allowDomain("*");
			var xml:XML = describeType(this);
			for (var i:uint = 0; i < xml.variable.length(); i++)
			{
				Font.registerFont(this[xml.variable[i].@name]);
			}
		}
	}
}