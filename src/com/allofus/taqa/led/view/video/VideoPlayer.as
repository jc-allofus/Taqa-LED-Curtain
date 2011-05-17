package com.allofus.taqa.led.view.video
{
	import com.allofus.shared.logging.GetLogger;

	import mx.logging.ILogger;

	import flash.display.DisplayObject;
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
		
		public static const READY:String = "videoplayer/ready";
		
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
		

		public function VideoPlayer(id:String, width:int, height:int)
		{
			this.id = id;
			
			videoWidth = width;
			videoHeight = height;
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
			//logger.debug("initPlayer.");
			
			removeEventListener(Event.ADDED_TO_STAGE, initPlayer);
			
			connection = new NetConnection();
			connection.connect(null);
			
			stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			stream.client = this;
			
			attachVideo();
		}

		protected function attachVideo():void
		{
//			logger.debug("creating video object..");
			video = new Video(videoWidth, videoHeight);
//			video.addEventListener(VideoEvent.RENDER_STATE, handleVideoObjectRender); //available in flash player v10.2, not sure which air runtime
			video.attachNetStream(stream);
			addChild(video);
			_videoAttached = true;
			
			if(_vidURL)
			{
				queueVideo(_vidURL, _autoplay);
			}
		}

		private function handleNetStatus(event : NetStatusEvent) : void
		{
			//logger.debug("status: " + event.info.code);
			switch(event.info["code"])
			{
				case "NetStream.Play.Stop":
					// finished
					logger.debug("stream reached end finished.");
					dispatchEvent(new Event(Event.COMPLETE));
					break;
					
				case "NetStream.Play.StreamNotFound":
					logger.error("stream not found" + _vidURL);
					break;
					
				default:
					//logger.info("here is info: " + event.info);
					break;
			}
		}
		
		public function onMetaData(e:Object):void
		{
			//logger.debug("loaded video metadata: " + e["duration"]);
			_duration = Number(e["duration"]);
			dispatchEvent(new Event(READY));
		}
		
		public function onXMPData(e:Object):void
		{
			//logger.debug("got XMPData : " + e);
		}
		
		public function queueVideo(vidURL : String, autoplay:Boolean = false) : void
		{
			//logger.debug("queue video: " + vidURL + ", autoplay: " + autoplay);
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
		}
		
		public function get currentTime():Number
		{
			return stream.time;
		}

		public function get duration() : Number
		{
			return _duration;
		}
		
		override public function toString():String
		{
			return "[VideoPlayer] -> " + id;
		}
		
		protected function bringToTop(vp:DisplayObject):void
		{
			setChildIndex(vp, numChildren -1);
		}

		public function dispose() : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initPlayer);
			
			video.attachNetStream(null);
			video.clear();
			if(contains(video))removeChild(video);
			video = null;

			stream.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
			stream.close();
			stream = null;

			connection.close();
			connection = null;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(VideoPlayer);
	}
}
