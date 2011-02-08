package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 */
	public class SmallLEDProxy extends Actor implements IXMLProxy
	{
		[Inject] public var configProxy:ConfigProxy; 
		
		protected var allItems:Vector.<ISlideVO>;
		protected var headlineItems:Vector.<ISlideVO>;
		protected var notHeadlineItems:Vector.<ISlideVO>;
		
		protected var history:Vector.<ISlideVO>;
		
		protected var  basePathRegex:RegExp;
		
		public function SmallLEDProxy()
		{
			allItems = new Vector.<ISlideVO>();
			headlineItems = new Vector.<ISlideVO>();
			notHeadlineItems = new Vector.<ISlideVO>();
			
			//basePathRegex= new RegExp(configProxy.apiBaseURL + configProxy.imageBasePath, "g");
			logger.debug("dp" + configProxy);
		}
		
		public function getNext():ISlideVO
		{
			var selected:ISlideVO;
			selected = allItems[0];
			history.push(selected);
			return allItems[0];	
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
					allItems.push(vo);
					vo.isHeadlineContent ? headlineItems.push(vo) : notHeadlineItems.push(vo);
				}
				vo = null;
			}
		}

		protected function parseImageSlideVO(item:XML) : ImageSlideVO
		{
			var vo:ImageSlideVO = new ImageSlideVO();
			vo.id = item.body.toString();
			vo.id = vo.id.replace(basePathRegex, "");
			vo.imageURL = item.body.toString();
			return vo;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( SmallLEDProxy );
	}
}
