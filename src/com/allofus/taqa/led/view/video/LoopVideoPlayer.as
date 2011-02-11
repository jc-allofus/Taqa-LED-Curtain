package com.allofus.taqa.led.view.video
{
	import com.allofus.shared.logging.GetLogger;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author jc
	 */
	public class LoopVideoPlayer extends Sprite
	{
		
		public static const TRANSITION_DURATION:int = 2;
		
		protected var vid1:VideoPlayer;
		protected var vid2:VideoPlayer;
		
		protected var vids:Array;
		
		protected var currentIndex:int = 0;
		protected var queuedIndex:int;
		
		protected var currentPlayer:VideoPlayer;
		protected var queuedPlayer:VideoPlayer;
		
		protected var transitionTimer:Timer;
		
		public function LoopVideoPlayer(width:int, height:int, vids:Array)
		{
			this.vids = vids;
			
			transitionTimer = new Timer(250);
			transitionTimer.addEventListener(TimerEvent.TIMER, handleTimerTick);
			
			vid1 = new VideoPlayer("player 1", width, height);

			
			vid2 = new VideoPlayer("player 2", width, height);
			
			vid1.queueVideo(vids[currentIndex], true);
			queuedIndex = getNext();
			vid2.queueVideo(vids[queuedIndex]);
			
			currentPlayer = vid1;
			queuedPlayer = vid2;
			
			addChild(vid2);
			addChild(vid1);
			
			transitionTimer.start();
		}

		private function handleTimerTick(event : TimerEvent) : void
		{
			//if(currentPlayer.currentTime - currentPlayer.duration)
			//logger.debug("time left: " + String(currentPlayer.duration - currentPlayer.currentTime));
			if((currentPlayer.duration - currentPlayer.currentTime) < TRANSITION_DURATION)
			{
				transitionTimer.stop();
				startTransition();
			}
		}
		
		protected function startTransition():void
		{
//			logger.debug("starting transition.");
			bringToTop(currentPlayer);
			queuedPlayer.alpha = 1;
			queuedPlayer.visible = true;
			queuedPlayer.play();
			TweenMax.to(currentPlayer, TRANSITION_DURATION, {autoAlpha:0, onComplete:transitionComplete});
		}
		
		protected function transitionComplete():void
		{
			currentIndex = queuedIndex;
			queuedIndex = getNext();
			
			//switch references
			var cvp:VideoPlayer = currentPlayer;
			currentPlayer = queuedPlayer;
			queuedPlayer = cvp;
			
			queuedPlayer.queueVideo(vids[queuedIndex]);
			
//			logger.debug("switched videos: " 
//				+ "  currentIndex: " + currentIndex
//				+ ", queuedIndex: " + queuedIndex 
//				+ ", next video: " + vids[queuedIndex]
//				+ ", currentPlayer: " + currentPlayer
//				+ ", queuedPlayer: " + queuedPlayer
//			);
			
			transitionTimer.start();
		}
		
		protected function getNext():int
		{
			return (currentIndex + 1 >= vids.length) ? 0 : currentIndex+1;
		}
		
		protected function bringToTop(vp:VideoPlayer):void
		{
			setChildIndex(vp, numChildren -1);
		}

		public function dispose() : void
		{
			logger.fatal("im disposing");
			TweenMax.killTweensOf(currentPlayer);
			transitionTimer.removeEventListener(TimerEvent.TIMER, handleTimerTick);
			transitionTimer.stop();
			transitionTimer = null;
			
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			
			vids.length = 0;
			vids = null;
			
			currentPlayer = null;
			queuedPlayer = null;
			
			vid1.dispose();
			vid1 = null;

			vid2.dispose();
			vid2 = null;
		}
		private static const logger : ILogger = GetLogger.qualifiedName(LoopVideoPlayer);
	}
}
