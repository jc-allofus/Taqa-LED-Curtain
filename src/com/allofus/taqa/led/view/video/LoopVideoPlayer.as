package com.allofus.taqa.led.view.video
{
	import com.allofus.taqa.led.view.EnglishScrollText;
	import com.allofus.taqa.ledcurtain.swcassets.TestBitmapSlice;
	import com.allofus.shared.logging.GetLogger;
	import com.greensock.TweenMax;

	import mx.logging.ILogger;

	import flash.display.Bitmap;
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
		
		protected var testPattern:Bitmap;
		
		public function LoopVideoPlayer(width:int, height:int, vids:Array, useScrollingText:Boolean = false)
		{
			this.vids = vids;
			
			transitionTimer = new Timer(250);
			transitionTimer.addEventListener(TimerEvent.TIMER, handleTimerTick);
			
			vid1 = new VideoPlayer("player 1", width, height, true);

			
			vid2 = new VideoPlayer("player 2", width, height);
			
			if(useScrollingText)
			{
				logger.debug("showing scrolltext");
				vid2.addTextScroller(new EnglishScrollText());
			}

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
			logger.warn("starting transition.");
			bringToTop(currentPlayer);
			queuedPlayer.alpha = 1;
			queuedPlayer.visible = true;
			queuedPlayer.play();
			if(currentPlayer.usingMask)
			{
				currentPlayer.alphaMaskOut();
				TweenMax.delayedCall(TRANSITION_DURATION, transitionComplete);
			}
			else
			{
				TweenMax.to(currentPlayer, TRANSITION_DURATION, {autoAlpha:0, onComplete:transitionComplete});
			}
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
			
			logger.info("switched videos: " 
				+ "  currentIndex: " + currentIndex
				+ ", queuedIndex: " + queuedIndex 
				+ ", next video: " + vids[queuedIndex]
				+ ", currentPlayer: " + currentPlayer
				+ ", queuedPlayer: " + queuedPlayer
			);
			
			transitionTimer.start();
			if(currentPlayer.hasScrollText)
			{
				currentPlayer.startTextScrolling();
			}
		}
		
		protected function getNext():int
		{
			return (currentIndex + 1 >= vids.length) ? 0 : currentIndex+1;
		}
		
		protected function bringToTop(vp:VideoPlayer):void
		{
			var ti:int = testPattern ? numChildren-2 : numChildren -1;
			setChildIndex(vp, ti);
		}
		
		public function showTestPattern(alpha:Number = 1):void
		{
			if(!testPattern)
			{
				testPattern = new Bitmap(new TestBitmapSlice(0, 0));
				testPattern.alpha = alpha;
				addChild(testPattern);
			}
		}
		
		public function hideTestPattern():void
		{
			if(testPattern)
			{
				if(contains(testPattern))
				{
					removeChild(testPattern);
				}
				testPattern.bitmapData.dispose();
				testPattern = null;
			}
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( LoopVideoPlayer );
	}
}
