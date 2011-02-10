package com.allofus.taqa.led.controller.startup
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.ConfigProxy;
	import com.allofus.taqa.led.view.preferences.PositionPreferences;

	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	public class CopyVideosCommand extends Command
	{
		[Inject] public var configProxy:ConfigProxy;
		
		protected var packagedVideos:File;
		
		override public function execute():void
		{
			logger.info("copy videos ");
			
			var dir:File = configProxy.videosDir;
			
			if(!dir.exists)
			{
				logger.debug("dir does not exist, create it and copy over any assets we have packaged w/ it.");
				dir.createDirectory();
				packagedVideos = File.applicationDirectory.resolvePath("assets/videos");
				if(packagedVideos.exists)
				{
					logger.debug("i see we have some packaged vids, bring 'em over.");
					packagedVideos.addEventListener(Event.COMPLETE, complete);
					packagedVideos.addEventListener(IOErrorEvent.IO_ERROR, fail);
					packagedVideos.copyToAsync(dir,true);
				}
				else
				{
					complete();
				}
			}
			else
			{
				complete();
			}
			
		}
		
		protected function complete(event:Event = null):void
		{
			PositionPreferences.VIDEOS_DIR = configProxy.videosDir;
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.COPY_VIDEOS_COMPLETE));
		}
		
		protected function fail(event:IOErrorEvent):void
		{
			logger.fatal("we couldn't copy videos: " + event);
			dispatch(new StateEvent(StateEvent.ACTION, FSMConstants.COPY_VIDEOS_FAIL));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( CopyVideosCommand );
	}
}
