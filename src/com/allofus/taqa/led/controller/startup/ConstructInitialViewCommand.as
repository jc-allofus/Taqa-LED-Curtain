package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.text.FontManager;
	import com.allofus.shared.text.TLFTextManager;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.view.preferences.PreferencesPane;
	import flash.display.Sprite;
	import flashx.textLayout.formats.Direction;
	import mx.logging.ILogger;
	import org.robotlegs.mvcs.Command;

	/**
	 * @author jc
	 */
	public class ConstructInitialViewCommand extends Command
	{
		[Inject] public var configProxy:ConfigProxy;
		
		override public function execute():void
		{
			logger.info("constructing initial view." );
			
			var preferencesPane:PreferencesPane = new PreferencesPane();
			contextView.addChild(preferencesPane);
			FontManager.listFonts();

//			var tf : Sprite = TLFTextManager.createText(configProxy.randomArabic);
//			contextView.addChild(tf);
//			tf.x = 15;
//			tf.y = 150;
//
//			var tf1 : Sprite = TLFTextManager.createText(TLFTextManager.LOREM_IPSUM);
//			contextView.addChild(tf1);
//			tf1.x = 15;
//			tf1.y = 250;
			
			TLFTextManager.listFonts();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ConstructInitialViewCommand );
	}
}
