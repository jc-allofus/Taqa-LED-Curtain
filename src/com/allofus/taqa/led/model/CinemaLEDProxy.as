package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;

	import mx.logging.ILogger;

	import flash.events.Event;
	/**
	 * @author jc
	 */
	public class CinemaLEDProxy extends TaqaFeedProxy implements IXMLProxy
	{
		public static const UPDATED:String = "cinemaLEDProxy/updated";
		
		public function CinemaLEDProxy()
		{
			allItems = new Vector.<ISlideVO>();
			history = new Vector.<ISlideVO>();
		}
		
		override public function set data(xml:XML):void
		{
			logger.debug("CINEMA LED parse this into something useful: " + xml);
			var type:String;	
			var vo:ISlideVO;
			for each (var item:XML in xml.node)
			{
				type = item.Type.toString();
				switch(type)
				{
					case SlideTypes.IMAGE_CINEMA:
						vo = parseImageSlideVO(item);
						vo.type = SlideTypes.IMAGE_CINEMA;
						break;
						
					case SlideTypes.VIDEO_CINEMA:
						vo = parseVideoSlideVO(item);
						vo.type = SlideTypes.VIDEO_CINEMA;
						break;
						
					default:
						logger.warn("no parsing implemented for: " + type);
						vo = null;
						break;
				}
				
				if(vo)
				{
					allItems.push(vo);
				}
				vo = null;
			}
			dispatch(new Event(UPDATED));
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( CinemaLEDProxy );
	}
}
