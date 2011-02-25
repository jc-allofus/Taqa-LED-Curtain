package com.allofus.taqa.led.view.slides
{
	import com.allofus.taqa.led.ApplicationGlobals;
	import flash.events.TimerEvent;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;
	import com.allofus.taqa.led.view.video.VideoPlayer;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.utils.Timer;

	/**
	 * @author jc
	 */
	public class VideoSlide extends AbstractSlide
	{
		protected var _videoVO:VideoSlideVO;
		protected var player:VideoPlayer;
		protected var videoTimer:Timer;
		
		public static const TRANSITION_DURATION:int = 2;//seconds
		
		public function VideoSlide(vo:VideoSlideVO, videoWidth:int, videoHeight:int)
		{
			_videoVO = vo;
			player = new VideoPlayer(vo.id, videoWidth, videoHeight);
			player.addEventListener(VideoPlayer.READY, handleReady);
			player.addEventListener(Event.COMPLETE,handleStreamFinishedPlaying);
			player.queueVideo(vo.videoURL);
			addChild(player);
			
			videoTimer = new Timer(10);
			videoTimer.addEventListener(TimerEvent.TIMER, handleTimerTick);
		}

		override public function transitionIn():void
		{
			player.play();
			videoTimer.start();
			visible = true;
			alpha = 1;
			TweenMax.from(this, 0.5, {alpha:0, onComplete:handleTransitionInComplete});
		}

		protected function handleReady(event : Event) : void
		{
			event;
			ready = true;
		}
		
		protected function handleTimerTick(event : TimerEvent) : void
		{
			if((player.duration - player.currentTime) < ApplicationGlobals.FADE_DURATION + 0.5) 
			{
				videoTimer.stop();
				fadeOut();
			}
		}
		
		protected function fadeOut():void
		{
			TweenMax.to(this, ApplicationGlobals.FADE_DURATION, {alpha:0, onComplete:onComplete});	
		}

		protected function handleStreamFinishedPlaying(event : Event) : void
		{
			logger.warn("video is hopefully already transitioned out as we've now run out of stream");
		}
		
		override public function dispose():void
		{
			if(player)
			{
				player.removeEventListener(VideoPlayer.READY, handleReady);
				player.removeEventListener(Event.COMPLETE,handleStreamFinishedPlaying);
				player.dispose();
				if(contains(player))removeChild(player);
				player = null;
			}
			
			videoTimer.removeEventListener(TimerEvent.TIMER, handleTimerTick);
			videoTimer.stop();
			videoTimer = null;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( VideoSlide );
	}
}
