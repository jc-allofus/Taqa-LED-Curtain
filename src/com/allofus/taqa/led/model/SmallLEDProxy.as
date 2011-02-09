package com.allofus.taqa.led.model
{
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
			
			//basePathRegex= new RegExp(configProxy.apiBaseURL + configProxy.imageBasePath, "g");
			logger.debug("dp" + configProxy);
		}
		
		public function getNext():ISlideVO
		{
			var selected:ISlideVO;
			if(allItems && allItems.length > 0)
			{
				selected = allItems[index];
				history.push(selected);
				logger.fatal("sending: " + selected + " i: " + index);
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
						
					default:
						logger.warn("cannot handle this type in proxy for small LED: " + type);
						vo = null;
						break;
				}
				
				if(vo)
				{
					logger.fatal("push to all items: " + vo);
					logger.fatal("is it headline: " + vo.isHeadlineContent);
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
		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDProxy );
	}
}
