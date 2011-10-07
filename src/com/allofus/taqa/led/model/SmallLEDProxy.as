package com.allofus.taqa.led.model
{
	import com.allofus.taqa.led.view.preferences.PositionPreferences;
	import com.allofus.taqa.led.model.vo.EnglishAndArabicTextVO;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;

	import mx.logging.ILogger;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.getTimer;

	/**
	 * @author jc
	 */
	public class SmallLEDProxy extends TaqaFeedProxy implements IXMLProxy
	{

		[Inject]
		public var settingsProxy:SettingsProxy;

		protected var _playlist:Vector.<ISlideVO>;


		public static const UPDATED:String = "smallLEDProxy/updated";

		protected static const DEFAULT_PLAYLIST_LENGTH:int = 100;
		protected var isErrorMsgEnglish:Boolean = true;

		public function SmallLEDProxy()
		{
			allItems = new Vector.<ISlideVO>();
			headlineItems = new Vector.<ISlideVO>();
			notHeadlineItems = new Vector.<ISlideVO>();
			history = new Vector.<ISlideVO>();
			_playlist = new Vector.<ISlideVO>();
		}

		override public function getNext():ISlideVO
		{
			// loop through playlist of weighted headline content vs. non-headline content
			if(PositionPreferences.SELECTED_PLAYLIST_TYPE == SmallBannerPlaylistTypes.SHUFFLED_PLAYLIST)
			{
				var selected:ISlideVO;
				if(_playlist && _playlist.length > 0)
				{
					selected = _playlist[index];
					history.push(selected);
					if(index + 1 > _playlist.length - 1)
					{
						index = 0;
					}
					else
					{
						index++;
					}
					return selected;
				}
			}

			else if(PositionPreferences.SELECTED_PLAYLIST_TYPE == SmallBannerPlaylistTypes.SPECIFIC_CONTENT)
			{
				 /*loop through specific type (mainly for debugging)*/
				 var vo:ISlideVO;
				 var hasCorrectType:Boolean = false;
				 while(!hasCorrectType)
				 {
					 vo = super.getNext();
					 if (vo is EnglishAndArabicTextVO)
					 {
					 	return vo;
					 }
				 }
			}

			else if (PositionPreferences.SELECTED_PLAYLIST_TYPE == SmallBannerPlaylistTypes.FEED_ORDER)
			{
				// loop through all items in order they appear in XML
				return super.getNext();
			}
			
			else
			{
				logger.warn("uh oh, wtf are we doing in here?")
			}
			
			return super.getNext();
		}

		override public function set data(xml:XML):void
		{
			allItems.length = 0;
			headlineItems.length = 0;
			notHeadlineItems.length = 0;
			history.length = 0;
			_playlist.length = 0;

			// logger.debug("SMALL LED parse this into something useful: " + xml);
			var type:String;
			var vo:ISlideVO;
			if(xml)
			{
				for each(var item:XML in xml.node)
				{
					type = item.Type.toString();
					switch(type)
					{
						case SlideTypes.IMAGE_SMALL:
							vo = parseImageSlideVO(item);
							vo.type = SlideTypes.IMAGE_SMALL;
							break;

						case SlideTypes.VIDEO_SMALL:
							vo = parseVideoSlideVO(item);
							vo.type = SlideTypes.VIDEO_SMALL;
							break;

						case SlideTypes.SCROLLING_TEXT_SMALL:
							vo = parseScrollingTextVO(item);
							vo.type = SlideTypes.SCROLLING_TEXT_SMALL;
							break;

						case SlideTypes.SCROLLING_TEXT_PIXEL:
							vo = parsePixelTextVO(item);
							vo.type = SlideTypes.SCROLLING_TEXT_PIXEL;
							break;
							
						case SlideTypes.ENGLISH_AND_ARABIC:
							vo = parseEnglishAndArabicVO(item);
							vo.type = SlideTypes.ENGLISH_AND_ARABIC;
							break;

						default:
							logger.warn("no parser for type: " + type);
							break;
					}

					if(vo)
					{
						allItems.push(vo);
						vo.isHeadlineContent ? headlineItems.push(vo) : notHeadlineItems.push(vo);
					}
					vo = null;
				}
			}
			//logger.fatal("how many total headline items:" + headlineItems.length);
			if(headlineItems.length > 0)
			{
				createHeadlineWeightedPlaylist();
			}
			dispatch(new Event(UPDATED));
		}

		protected function createHeadlineWeightedPlaylist():void
		{
			var playlistLength:int = DEFAULT_PLAYLIST_LENGTH;
			var headlineWeight:int = settingsProxy.headlineDisplayRate; //percentage that should be headline items
			var numHeadlineItems:int = Math.round((playlistLength * headlineWeight) / 100);
			var playlist:Vector.<ISlideVO> = new Vector.<ISlideVO>();
			var iheadline:int = 0;
			var inotHeadline:int = 0;
			for(var i:int = 0; i < playlistLength; i++)
			{
				if(i < numHeadlineItems)
				{
					playlist.push(headlineItems[iheadline]);
					// logger.debug(i + " add headline: " + iheadline + " / " + String(headlineItems.length -1));
					iheadline = (iheadline + 1 > headlineItems.length - 1) ? 0 : iheadline + 1;
				}
				else
				{
					playlist.push(notHeadlineItems[inotHeadline]);
					// logger.debug(i + " NON headline: " + inotHeadline + " / " + String(notHeadlineItems.length -1));
					inotHeadline = (inotHeadline + 1 > notHeadlineItems.length - 1 ) ? 0 : inotHeadline + 1;
				}
			}
			_playlist = randomize(playlist);
			index = 0;
			//showPlaylist();
		}

		protected function randomize(vec:Vector.<ISlideVO>):Vector.<ISlideVO>
		{
			var random:Vector.<ISlideVO> = new Vector.<ISlideVO>();
			while(vec.length > 0)
			{
				var obj:Vector.<ISlideVO> = vec.splice(Math.floor(Math.random() * vec.length), 1);
				random.push(obj[0]);
			}
			return random;
		}

		protected function showPlaylist():void
		{
			for(var i:int = 0; i < _playlist.length; i++)
			{
				if(_playlist[i].isHeadlineContent)
				{
					logger.warn(i + " headline ");
				}
				else
				{
					logger.error(i + " NOT headline");
				}
			}
		}
		
		override protected function getDefaultMessage():ISlideVO
		{
			var vo:ScrollingTextVO = new ScrollingTextVO();
			vo.id = "st"+getTimer();
			vo.isHeadlineContent = false;
			if (isErrorMsgEnglish)
			{
				vo.language = Languages.ENGLISH;
				vo.text = configProxy.errorMessageEnglish;
			}
			else
			{
				vo.language = Languages.ARABIC;
				vo.text = configProxy.errorMessageArabic;
			}
			isErrorMsgEnglish = !isErrorMsgEnglish;
			vo.theme = Themes.ATOMIC;
			vo.bgVidsDir = configProxy.videosDir.url + File.separator + "backgrounds" + File.separator;
			vo.type = SlideTypes.SCROLLING_TEXT_SMALL;
			return vo;
		}


		private static const logger:ILogger = GetLogger.qualifiedName(SmallLEDProxy);
	}
}
