package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.text.FontManager;
	import com.allofus.taqa.led.view.PreferencesPane;
	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Command;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class ConstructInitialViewCommand extends Command
	{
		override public function execute():void
		{
			logger.info("constructing initial view.");
			
			var preferencesPane:PreferencesPane = new PreferencesPane();
			contextView.addChild(preferencesPane);
			FontManager.listFonts();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ConstructInitialViewCommand );
	}
}
