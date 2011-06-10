package
{
	import flash.display.StageAlign;
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
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1064", height="440")]
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
//			initializeMonsterDebuggerLogging();
			//initializeTraceLogging();
			//initializeMonsterDebuggerLogging();
			initializeSOSLogging();
			initializeFileLogging();
			createContext();
		}


		
		
		protected function onApplicationInvoked(event : InvokeEvent) : void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onApplicationInvoked);
			if(!_invoked)
			{
				//do stuff on invoked
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
		
		
		protected function createContext() : void
		{
			context = new TaqaLEDCurtainContext(this);
		}

		public function fullscreen(value : Boolean) : void
		{
			if(value)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}

		public function toggleFullscreen() : void
		{
			stage.displayState == StageDisplayState.NORMAL ? fullscreen(true) : fullscreen(false);
		}
	}
}
