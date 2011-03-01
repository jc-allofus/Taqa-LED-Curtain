package com.allofus.taqa.led.model
{
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class SmallLEDProxy extends TaqaFeedProxy implements IXMLProxy
	{
		
		[Inject] public var settingsProxy:SettingsProxy;
		
		protected var _playlist:Vector.<ISlideVO>;
		
		
		public static const UPDATED:String = "smallLEDProxy/updated";
		
		protected var playlistLength:int = 100;
		
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
			//loop through playlist of weighted headline content vs. non-headline content
			var selected:ISlideVO;
			if(_playlist && _playlist.length > 0)
			{
				selected = _playlist[index];
				history.push(selected);
				if(index + 1 > _playlist.length -1)
				{
					index = 0;
				}
				else
				{
					index++;
				}
				return selected;	
			}
			return null;
			
			//loop through specific type 
//			var vo:ISlideVO;
//			var hasCorrectType:Boolean = false;
//			while(!hasCorrectType)
//			{
//				vo = super.getNext();
//				if (vo is ImageSlideVO)
//				{
//					return vo;
//				}
//			}
//			return null;
			
			//loop through all items in order they appear in XML
			//return super.getNext();
		}
		
		override public function set data(xml:XML):void
		{
			allItems.length = 0;
			headlineItems.length = 0;
			notHeadlineItems.length = 0;
			history.length = 0;
			_playlist.length = 0;
			
			//logger.debug("SMALL LED parse this into something useful: " + xml);
			var type:String;	
			var vo:ISlideVO;
			for each (var item:XML in xml.node)
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
						
					default:
						break;
				}
				
				if(vo)
				{
					allItems.push(vo);
					vo.isHeadlineContent ? headlineItems.push(vo) : notHeadlineItems.push(vo);
				}
				vo = null;
			}
			createPlaylist();
			dispatch(new Event(UPDATED));
		}
		
		protected function createPlaylist():void
		{
			var headlineWeight:int = settingsProxy.headlineDisplayRate;
			var playlist:Vector.<ISlideVO> = new Vector.<ISlideVO>();
			var iheadline:int = 0;
			var inotHeadline:int = 0;
			for (var i : int = 0; i < playlistLength; i++) 
			{
				if(i < headlineWeight)
				{
					playlist.push(headlineItems[iheadline]);
//					logger.fatal(i + " add headline: " + iheadline + " / " + String(headlineItems.length -1));
					iheadline = (iheadline+1 > headlineItems.length -1) ? 0 : iheadline+1;
				}
				else
				{
					playlist.push(notHeadlineItems[inotHeadline]);
//					logger.warn(i + " NON headline: " + inotHeadline + " / " + String(notHeadlineItems.length -1));
					inotHeadline = (inotHeadline+1 > notHeadlineItems.length -1 ) ? 0 : inotHeadline+1;
				}
			}
			_playlist = randomize(playlist);
			index = 0;
			//showPlaylist();
		}
		
		protected function randomize(vec:Vector.<ISlideVO>):Vector.<ISlideVO> 
		{
			var random:Vector.<ISlideVO> = new Vector.<ISlideVO>();
	        while(vec.length > 0){
	            var obj:Vector.<ISlideVO> = vec.splice(Math.floor(Math.random()*vec.length), 1);
	            random.push(obj[0]);
	        }
	        return random;
    	}
    	
    	protected function showPlaylist():void
    	{
    		for (var i : int = 0; i < _playlist.length; i++) 
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

		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDProxy );
	}
}
