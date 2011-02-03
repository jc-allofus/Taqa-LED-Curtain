package com.allofus.taqa.led.service
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusFileUpdateErrorEvent;
	import air.update.events.StatusFileUpdateEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;

	import com.allofus.shared.logging.GetLogger;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jc
	 */
	public class ApplicationUpdaterService extends Actor
	{
		public static var UPDATE_COMPLETE:String = "appUpdaterService/complete";
		public static var UPDATE_FAIL:String = "appUpdaterService/fail";
		
		protected var applicationUpdater:ApplicationUpdaterUI;
		protected var timer:Timer;
		
		public function ApplicationUpdaterService()
		{
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, handlerTimerTick);
		}
		
		protected function handlerTimerTick(event:TimerEvent):void
		{
			if(! applicationUpdater.isUpdateInProgress)
			{
				logger.warn("all of a sudden we are not in update; user possibly clicked the 'download later' button, cancelled a download in progress, or there was some sort of general error...");
				finishUpdate();
			}
		}
		
		public function checkForUpdate(updateURL:String):void
		{
			appUpdater.updateURL = updateURL;
			appUpdater.initialize();
		}
		
		protected function finishUpdate():void
		{
			if(timer)
			{
				timer.stop();
				timer = null;
			}
			dispatch(new Event(ApplicationUpdaterService.UPDATE_COMPLETE));
		}
		
		protected function get appUpdater():ApplicationUpdaterUI
		{
			if(applicationUpdater == null)
			{
				applicationUpdater = new ApplicationUpdaterUI();
				applicationUpdater.isCheckForUpdateVisible = false;
				applicationUpdater.isInstallUpdateVisible = false;
				//applicationUpdater.isUpdateInProgress
				applicationUpdater.addEventListener(MouseEvent.CLICK, handleClicked);
				applicationUpdater.addEventListener(UpdateEvent.INITIALIZED, handlieInitialized);
				applicationUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, handleCheckForUpdate);				applicationUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL, handleBeforeInstall);				applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_START, handleDownloadStart);				applicationUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, handleDownloadComplete);				applicationUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, handleDownloadError);				applicationUpdater.addEventListener(ErrorEvent.ERROR, handleError);				applicationUpdater.addEventListener(ProgressEvent.PROGRESS, handleDownloadProgress);
				applicationUpdater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, handleFileUpdateStatus);
				applicationUpdater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, handleFileUpdateError);
				applicationUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, handleUpdateStatus);
				applicationUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, handleUpdateError);
			}
			return applicationUpdater;
		}
		
		protected function handleClicked(event:MouseEvent):void
		{
			logger.info("clicked " + event);
		}

		private function handleUpdateStatus(event : StatusUpdateEvent) : void
		{
			logger.debug("update status: available:" + event.available + ", version: " + appUpdater.currentVersion + ", details: " + event.details);
			if(!event.available)
			{
				// no update available, we have the most up to date version installed
				finishUpdate();
			}
		}

		private function handleDownloadProgress(event : ProgressEvent) : void
		{
			logger.debug("downloaded: " + event.bytesLoaded + " / " + event.bytesTotal + "\n" + event);
		}
		
		/*
		 * after the updater successfully validates the file in the call to the installFromAIRFile() method
		 */
		private function handleFileUpdateStatus(event : StatusFileUpdateEvent) : void
		{
			logger.debug(" file update status: available:" + event.available + ", path: " + event.path + ", version: " + event.version + " \n" + event);
		}

		private function handleError(event : ErrorEvent) : void
		{
			//log the error and dispatch to system
			logger.error("generic error in update process: " + event.text + "\n" + event);
			dispatch(new Event(ApplicationUpdaterService.UPDATE_FAIL));
		}

		private function handleDownloadStart(event : UpdateEvent) : void
		{
			logger.debug("download started: " + event);
		}

		private function handleDownloadError(event : DownloadErrorEvent) : void
		{
			logger.error("handleDownloadError: " + event.text  + "\n"  +event);
			dispatch(new Event(ApplicationUpdaterService.UPDATE_FAIL));
		}

		private function handleDownloadComplete(event : UpdateEvent) : void
		{
			logger.info(" finished downloading update file: " + event);
		}

		private function handleCheckForUpdate(event : UpdateEvent) : void
		{
			logger.debug(" checking for update: " + event );
		}
		
		private function handleBeforeInstall(event : UpdateEvent) : void
		{
			logger.info(" before install: " + event);
		}
		
		private function handleUpdateError(event : StatusUpdateErrorEvent) : void
		{
			logger.error("handleUpdateError: " + event.text + "\n" + event);
			logger.error("current version: " + applicationUpdater.currentVersion);
			dispatch(new Event(ApplicationUpdaterService.UPDATE_FAIL));
		}

		/*
		 * an error occurs validating the file passed as the airFile parameter in a call to the installFromAIRFile() method
		 */
		private function handleFileUpdateError(event : StatusFileUpdateErrorEvent) : void
		{
			logger.error("handleFileUpdateError: " + event.text + "\n" + event);
			dispatch(new Event(ApplicationUpdaterService.UPDATE_FAIL));
		}

		private function handlieInitialized(event : UpdateEvent) : void
		{
			logger.debug("application updater initialized, check for update : " + event);
			timer.start();
			appUpdater.checkNow();
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( ApplicationUpdaterService );
	}
}
