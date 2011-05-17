package com.allofus.taqa.led.model
{
	import flash.utils.getTimer;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;
	import com.allofus.shared.logging.GetLogger;
	import mx.logging.ILogger;
	import flash.events.Event;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;

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

			// reset
			allItems.length = 0;
			history.length = 0;

			var type:String;
			var vo:ISlideVO;
			if(xml)
			{
				for each(var item:XML in xml.node)
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
			}
			dispatch(new Event(UPDATED));
		}
		
		override protected function getDefaultMessage():ISlideVO
		{
			if(configProxy && configProxy.defaultCinemaVidoes && configProxy.defaultCinemaVidoes.length > 0)
			{
				var index:int = Math.round(Math.random() * (configProxy.defaultCinemaVidoes.length -1));
				var vidURL:String = configProxy.defaultCinemaVidoes[index];
				if(vidURL)
				{
					var vo:VideoSlideVO = new VideoSlideVO();
					vo.id = "vid" + getTimer();
					vo.videoURL = vidURL;
					vo.type = SlideTypes.VIDEO_CINEMA;
					return vo;
				}
			}
			logger.fatal("problem getting a default message for the cinema screen.");
			return null;
		}

		private static const logger:ILogger = GetLogger.qualifiedName(CinemaLEDProxy);
	}
}
