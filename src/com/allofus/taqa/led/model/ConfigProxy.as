package com.allofus.taqa.led.model
{
	import com.allofus.shared.logging.GetLogger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	import flash.events.Event;

	/**
	 * @author jc
	 */
	public class ConfigProxy extends Actor
	{
		//event strings
		public static const LOAD_COMPLETE:String = "ConfigProxy/LoadSuccess";
		public static const LOAD_FAIL:String = "ConfigProxy/LoadFail";
		
		private static const LOADER_ID:String = "ConfigProxyLoader";
		private static const CSS_LOADER_ID:String = "taqa-css";
		private static const FILE_ID:String = "configXML";
		private static const ESTIMATED_BYTES:int = 1024;
		
		protected var loader : LoaderMax;
		
		protected var _smallLEDFeedPath:String;
		protected var _cinemaLEDFeedPath:String;
		protected var _updateURL : String;
		protected var _apiBaseURL : String;
		private var _randomArabic : String;
		
		public function ConfigProxy()
		{
		}

		public function loadConfigFile(url : String) : void
		{
			logger.debug("load config file from url: " + url);
			loader = getLoader();
			loader.append(new XMLLoader(url, {name:FILE_ID, estimatedBytes:ESTIMATED_BYTES}));
			loader.load();
		}
		
		protected function getLoader():LoaderMax
		{
			if(!loader)
			{
				LoaderMax.activate([CSSLoader, SWFLoader]);//allows XMLLoader to recognize ImageLoader nodes inside the XML
				loader = new LoaderMax({name:LOADER_ID, onProgress:handleProgress, onComplete:handleLoadConfigSuccess, onError:handleError});
			}
			return loader;
		}
		
		protected function handleProgress(event:LoaderEvent):void
		{
			logger.debug("loading progress: " + event);
		}
		
		protected function handleError(event:LoaderEvent):void
		{
			logger.error("could not load config file: " + event.target + " : " + event.text);
			dispatch(new Event(ConfigProxy.LOAD_FAIL));
		}
		
		protected function handleLoadConfigSuccess(event:LoaderEvent):void
		{
			//config xml
			var result:XML = loader.getContent(FILE_ID) as XML;
			logger.debug("result: " + result);
			if(result)
			{
				_apiBaseURL = result.APIEndpoints.APIBaseURL.@path;
				_smallLEDFeedPath = result.APIEndpoints.SmallLEDFeed.@path;
				_cinemaLEDFeedPath = result.APIEndpoints.CinemaLEDFeed.@path;
				_updateURL = result.UpdateURL.@path;
				_randomArabic = result.RandomArabicString.toString();
				dispatch(new Event(ConfigProxy.LOAD_COMPLETE));
			}
			else
			{
				dispatch(new Event(ConfigProxy.LOAD_FAIL));
			}
		}
		
		public function get apiBaseURL():String
		{
			return _apiBaseURL;
		}

		public function get smallLEDFeedPath() : String
		{
			return _smallLEDFeedPath;
		}

		public function get cinemaLEDFeedPath() : String
		{
			return _cinemaLEDFeedPath;
		}

		public function get updateURL() : String
		{
			return _updateURL;
		}

		private static const logger : ILogger = GetLogger.qualifiedName(ConfigProxy);

		public function get randomArabic() : String
		{
			return _randomArabic;
		}
	}
}
