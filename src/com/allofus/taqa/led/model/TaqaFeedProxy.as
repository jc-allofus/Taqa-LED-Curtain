package com.allofus.taqa.led.model
{
	import com.allofus.taqa.led.model.vo.EnglishAndArabicTextVO;
	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.vo.ISlideVO;
	import com.allofus.taqa.led.model.vo.ImageSlideVO;
	import com.allofus.taqa.led.model.vo.PixelTextVO;
	import com.allofus.taqa.led.model.vo.ScrollingTextVO;
	import com.allofus.taqa.led.model.vo.VideoSlideVO;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.filesystem.File;
	import flash.utils.getTimer;

	/**
	 * @author jc
	 */
	public class TaqaFeedProxy extends Actor implements IXMLProxy
	{
		[Inject] public var configProxy:ConfigProxy;
		
		protected var imagePathRegex:RegExp;
		
		protected var allItems:Vector.<ISlideVO>;
		protected var headlineItems:Vector.<ISlideVO>;
		protected var notHeadlineItems:Vector.<ISlideVO>;
		protected var history:Vector.<ISlideVO>;
		
		protected var index:int = 0;
		
		public function TaqaFeedProxy()
		{
		}
		
		public function set data(xml:XML):void
		{
			logger.error("must implement set data() in descendant class.");
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
			// return getDefaultMessage, override in sub classes
			return getDefaultMessage();
			//return null;
		}
		
		protected function getDefaultMessage():ISlideVO
		{
			logger.error("getDefaultMessage needs to be overriden");
			return null;
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
			vo.videoURL = configProxy.videosDir.url + File.separator + item.body.toString();
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
			vo.bgVidsDir = configProxy.videosDir.url + File.separator + "backgrounds" + File.separator;
			return vo;
		}
		
		protected function parsePixelTextVO(item:XML):PixelTextVO
		{
			var vo:PixelTextVO = new PixelTextVO();
			vo.id = "pt"+getTimer();
			vo.isHeadlineContent = item.headline.toString() == "Yes";
			vo.text1 = item.body.toString();
			vo.text1Language = item.body_language.toString();
//			vo.text1Format = (vo.text1Language == Languages.ENGLISH) ? TypeStyles.englishSmall : TypeStyles.arabicSmall;
			vo.text2 = item.body_2.toString();
			vo.text2Language = item.body_2_language.toString();
//			vo.text2Format = (vo.text2Language == Languages.ENGLISH) ? TypeStyles.englishSmall : TypeStyles.arabicSmall;
			return vo;
		}
		
		protected function parseEnglishAndArabicVO(item : XML) : EnglishAndArabicTextVO
		{
			var vo:EnglishAndArabicTextVO = new EnglishAndArabicTextVO();
			vo.id = "eab" + getTimer();
			vo.isHeadlineContent = false;
			vo.englishText = item.english.toString();
			vo.arabicText = item.arabic.toString();
			vo.bgVidsDir = configProxy.videosDir.url + File.separator + "backgrounds" + File.separator;
			return vo;
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( TaqaFeedProxy );
	}
}
