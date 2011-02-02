package com.allofus.taqa.led.view.video
{
	import flash.display.DisplayObject;
	import com.allofus.taqa.led.view.EnglishScrollText;
	import com.greensock.TweenMax;
	import nl.demonsters.debugger.MonsterDebugger;

	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author jc
	 */
	public class VideoPlayer extends Sprite
	{
		
		public var id:String;
		
		protected var videoWidth:int;
		protected var videoHeight:int;
				
		protected var connection:NetConnection;
		protected var stream:NetStream;
		protected var video:Video;
		
		protected var _renderState:String;
		
		private var _videoAttached : Boolean = false;
		
		private var _vidURL:String;
		private var _autoplay:Boolean = false;
		private var _duration:Number;
		private var _useMask:Boolean;
		
		private var _mask : Shape;
		private var scrollText : EnglishScrollText;

		public function VideoPlayer(id:String, width:int, height:int, useMask:Boolean = false)
		{
			this.id = id;
			
			videoWidth = width;
			videoHeight = height;
			_useMask = useMask;
			if(stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, initPlayer);
			}
			else
			{
				initPlayer();
			}
		}
		
		public function clearVideo():void
		{
			video.clear();
		}

		protected function initPlayer(event : Event = null) : void
		{
			logger.debug("initPlayer.");
			connection = new NetConnection();
			connection.connect(null);
			
			stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			stream.client = this;
			
			attachVideo();
		}

		protected function attachVideo():void
		{
			logger.info("creating video object..");
			video = new Video(videoWidth, videoHeight);
//			video.addEventListener(VideoEvent.RENDER_STATE, handleVideoObjectRender); //available in flash player v10.2, not sure which air runtime
			video.attachNetStream(stream);
			addChild(video);
			_videoAttached = true;
			
			if(_useMask)
			{
				_mask = new Shape();
				_mask.graphics.beginFill(0x0000cc);
				_mask.graphics.drawRect(0, 0, videoWidth, videoHeight);
				addChild(_mask);
				mask = _mask;
			}
			
					
			
			if(_vidURL)
			{
				queueVideo(_vidURL, _autoplay);
			}
		}

//		private function handleVideoObjectRender(event : VideoEvent) : void
//		{
//			logger.info("event status: " + event.status);
//			switch (event.status)
//			{
//				case VideoEvent.RENDER_STATUS_ACCELERATED:
//					_renderState = VideoEvent.RENDER_STATUS_ACCELERATED;
//					logger.info("GPU decoding, compositing in software.");
//					break;
//					
//				case VideoEvent.RENDER_STATUS_SOFTWARE:
//					_renderState = VideoEvent.RENDER_STATUS_SOFTWARE;
//					logger.info("no GPU decoding, no GPU compositing");
//					break;
//					
//				case VideoEvent.RENDER_STATUS_UNAVAILABLE:
//					_renderState = VideoEvent.RENDER_STATUS_UNAVAILABLE;
//					logger.info("unavialiable from regular video object.");
//					break;
//					
//				default:
//					logger.info("regular video object got a status that can't be recognized: " + event.status);
//					break;
//			}
//		}

		private function handleNetStatus(event : NetStatusEvent) : void
		{
			//logger.fatal("status: " + event.info.code);
			switch(event.info["code"])
			{
				case "NetStream.Play.Stop":
					// finished
					logger.info("intro finished.");
					break;
			}
		}
		
		public function onMetaData(e:Object):void
		{
			logger.debug("loaded video metadata: " + e["duration"]);
			MonsterDebugger.trace("metadata: " , e);
			_duration = Number(e["duration"]);
		}
		
		public function onXMPData(e:Object):void
		{
			logger.debug("got XMPData : " + e);
		}
		
		public function queueVideo(vidURL : String, autoplay:Boolean = false) : void
		{
			logger.debug("queue video: " + vidURL + ", autoplay: " + autoplay);
			_autoplay = autoplay;
			if (_vidURL != vidURL)
			{
				_vidURL = vidURL;
			}
			
			if(!video) return;

			stream.play(vidURL);
			
			if(stream.time > 0)
			{
				stream.seek(0);
			}
			
			if(_mask)
			{
				_mask.scaleX = 1;
			}
			
			if(hasScrollText)
			{
				scrollText.stopScrolling();
			}
			
			if(_autoplay)
			{
				play();
			}
			else
			{
				pause();
			}
		}
		
		public function pause():void
		{
			stream.pause();
		}

		public function play() : void
		{
			stream.resume();
			if(_mask)
			{
				_mask.scaleX = 1;
			}
		}
		
		public function get currentTime():Number
		{
			return stream.time;
		}


		public function get duration() : Number
		{
			return _duration;
		}
		
		public function get usingMask():Boolean
		{
			return _useMask;
		}
		
		override public function toString():String
		{
			return "[VideoPlayer] -> " + id;
		}
		

		public function alphaMaskOut() : void
		{
			TweenMax.to(_mask, LoopVideoPlayer.TRANSITION_DURATION, {scaleX:0});
		}

		private static const logger : ILogger = GetLogger.qualifiedName(VideoPlayer);

		public function addTextScroller(value:EnglishScrollText) : void
		{
			scrollText = value;
			addChild(scrollText);
		}
		
		public function get hasScrollText():Boolean
		{
			if(!scrollText) return false;
			return contains(scrollText);
		}

		public function startTextScrolling() : void
		{
			bringToTop(scrollText);
			scrollText.startScrolling(videoWidth);
		}
		
		protected function bringToTop(vp:DisplayObject):void
		{
			setChildIndex(vp, numChildren -1);
		}
	}
}
