package
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.shared.logging.LogWriter;
	import com.allofus.shared.logging.MonsterDebuggerTarget;
	import com.allofus.shared.logging.SOSLoggingTarget;
	import com.allofus.shared.logging.formatters.JSONFormatter;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	[SWF(backgroundColor="#000000", frameRate="31", width="1064", height="440")]
	public class TaqaLEDCurtain extends Sprite
	{
		private static const logger:ILogger = GetLogger.qualifiedName( TaqaLEDCurtain );
		
		private var _invoked:Boolean = false;
		private var context:TaqaLEDCurtainContext;
		
		//sprite layers
		
		public function TaqaLEDCurtain()
		{
			if(stage)initApp();
			else addEventListener(Event.ADDED_TO_STAGE, initApp);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onApplicationInvoked);
		}
		
		protected function initApp(event : Event = null) : void
		{
			trace("init app");
//			initializeMonsterDebuggerLogging();
			//initializeTraceLogging();
			//initializeMonsterDebuggerLogging();
			initializeSOSLogging();
			initializeFileLogging();
			createLayers();
			createContext();
		}
		
		protected function onApplicationInvoked(event : InvokeEvent) : void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onApplicationInvoked);
			if(!_invoked)
			{
//				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
//				stage.scaleMode = StageScaleMode.SHOW_ALL;
				_invoked = true;
			}
		}
		
		protected function initializeMonsterDebuggerLogging():void
		{
			var monsterTarget : MonsterDebuggerTarget = new MonsterDebuggerTarget(this);
			monsterTarget.includeCategory = true;
			monsterTarget.includeDate = false;
			monsterTarget.includeLevel = true;
			monsterTarget.includeTime = false;
			Log.addTarget(monsterTarget);
		}		
		
		protected function initializeSOSLogging() : void
		{
			var sosLoggingTarget : SOSLoggingTarget = new SOSLoggingTarget();
			sosLoggingTarget.includeCategory = true;
			sosLoggingTarget.includeDate = true;
			sosLoggingTarget.includeLevel = true;
			sosLoggingTarget.includeTime = true;
//			sosLoggingTarget.level = LogEventLevel.WARN;
			Log.addTarget(sosLoggingTarget);
		}
		
		protected function initializeFileLogging() : void
		{
			var logFile:File = File.applicationStorageDirectory.resolvePath("log/application_log.txt");
			var fileLogTarget : LogWriter = new LogWriter(logFile, new JSONFormatter());
			fileLogTarget.includeCategory = true;
			fileLogTarget.includeDate = true;
			fileLogTarget.includeLevel = true;
			fileLogTarget.includeTime = true;
			//only log level WARN and above
			fileLogTarget.level = LogEventLevel.WARN;
			Log.addTarget(fileLogTarget);
		}
		
		protected function createLayers():void
		{
//			var a:Array = ["assets/videos/s1_01_sun_848x34.mp4", "assets/videos/s1_01_wind_848x34.mp4"];
//			var vidLoop1:LoopVideoPlayer = new LoopVideoPlayer(848, 34, a,true);
//			vidLoop1.x = 75;
//			vidLoop1.y = 150;
//			addChild(vidLoop1);
//			
//			var b:Array = ["assets/videos/s2_sun_640x127.mp4", "assets/videos/s2_wind_640x127.mp4"];
//			var vidLoop2:LoopVideoPlayer = new LoopVideoPlayer(640, 127, b);
//			vidLoop2.x = 75;
//			vidLoop2.y = 200;
//			addChild(vidLoop2);
//			
//			var snapshot:BannerSnapshot = new BannerSnapshot(vidLoop1);
//			addChild(snapshot);
//			
//			vidLoop1.showTestPattern(0.4);
			

//			_statsLayer = new Sprite();
//			//_statsLayer.visible = false;
//			
//			addChild(_statsLayer);

//			addChild(new PreferencesPane());
			
			
		}
		
		protected function createContext() : void
		{
			context = new TaqaLEDCurtainContext(this);
		}
	}
}
