package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class SmallLEDProxy extends TaqaFeedProxy implements IXMLProxy
	{
		public static const UPDATED:String = "smallLEDProxy/updated";
		
		public function SmallLEDProxy()
		{
			allItems = new Vector.<ISlideVO>();
			headlineItems = new Vector.<ISlideVO>();
			notHeadlineItems = new Vector.<ISlideVO>();
			history = new Vector.<ISlideVO>();
		}
		
		override public function getNext():ISlideVO
		{
			//TODO implement headline choosing, history etc...
//			var vo:ISlideVO;
//			var hasPixeltext:Boolean = false;
//			while(!hasPixeltext)
//			{
//				vo = super.getNext();
//				if (vo is PixelTextVO)
//				{
//					return vo;
//				}
//			}
//			return null;
			
			return super.getNext();
		}
		
		override public function set data(xml:XML):void
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
			dispatch(new Event(UPDATED));
		}

		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDProxy );
	}
}
