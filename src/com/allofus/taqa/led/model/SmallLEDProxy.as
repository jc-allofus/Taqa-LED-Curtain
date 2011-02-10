package com.allofus.taqa.led.model
{
	import flash.utils.getTimer;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class SmallLEDProxy extends Actor implements IXMLProxy
	{
		[Inject] public var configProxy:ConfigProxy; 
		
		public static const UPDATED:String = "smallLEDProxy/updated";
		
		protected var allItems:Vector.<ISlideVO>;
		protected var headlineItems:Vector.<ISlideVO>;
		protected var notHeadlineItems:Vector.<ISlideVO>;
		
		protected var history:Vector.<ISlideVO>;
		
		protected var imagePathRegex:RegExp;
		
		protected var index:int = 0;
		
		public function SmallLEDProxy()
		{
			allItems = new Vector.<ISlideVO>();
			headlineItems = new Vector.<ISlideVO>();
			notHeadlineItems = new Vector.<ISlideVO>();
			history = new Vector.<ISlideVO>();
		}
		
		public function getNext():ISlideVO
		{
			var selected:ISlideVO;
			if(allItems && allItems.length > 0)
			{
				selected = allItems[index];
				history.push(selected);
				if(index + 1 > allItems.length -1)
				{
					index = 0;
				}
				else
				{
					index++;
				}
				return selected;	
			}
			logger.warn("nothing to give.");
			return null;
		}
		
		public function set data(xml:XML):void
		{
			logger.debug("SMALL LED parse this into something useful: " + xml);
			var type:String;	
			var vo:ISlideVO;
			for each (var item:XML in xml.node)
			{
				type = item.Type.toString();
				switch(type)
				{
					case SlideTypes.IMAGE_SMALL:
						vo = parseImageSlideVO(item);
						break;
						
					case SlideTypes.VIDEO_SMALL:
						vo = parseVideoSlideVO(item);
						break;
						
					case SlideTypes.SCROLLING_TEXT_SMALL:
						vo = parseScrollingTextVO(item);
						break;
						
					case SlideTypes.SCROLLING_TEXT_PIXEL:
					default:
						logger.warn("no parsing implemented for: " + type);
						vo = null;
						break;
				}
				
				if(vo)
				{
					allItems.push(vo);
					vo.isHeadlineContent ? headlineItems.push(vo) : notHeadlineItems.push(vo);
				}
				vo = null;
			}
			dispatch(new Event(UPDATED));
		}

		protected function parseImageSlideVO(item:XML) : ImageSlideVO
		{
			var vo:ImageSlideVO = new ImageSlideVO();
			vo.id = item.body.toString();
			vo.id = vo.id.replace(imagePathRegex, "");
			vo.imageURL = configProxy.apiBaseURL + item.body.toString();
			return vo;
		}
		
		protected function parseVideoSlideVO(item:XML):VideoSlideVO
		{
			var vo:VideoSlideVO = new VideoSlideVO();
			vo.id = item.body.toString();
			vo.videoURL = configProxy.videosDir.url + "/" + item.body.toString();
			return vo;
		}
		
		protected function parseScrollingTextVO(item:XML):ScrollingTextVO
		{
			var vo:ScrollingTextVO = new ScrollingTextVO();
			vo.id = "st"+getTimer();
			vo.isHeadlineContent = item.headline.toString() == "Yes";
			vo.language = item.body_language.toString();
			vo.theme = item.theme.toString();
			vo.text = item.body.toString();
			return vo;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDProxy );
	}
}
