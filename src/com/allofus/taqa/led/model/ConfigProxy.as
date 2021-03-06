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
	import flash.filesystem.File;

	/**
	 * @author jc
	 */
	public class ConfigProxy extends Actor
	{
		//event strings
		public static const LOAD_COMPLETE:String = "ConfigProxy/LoadSuccess";
		public static const LOAD_FAIL:String = "ConfigProxy/LoadFail";
		
		private static const LOADER_ID:String = "ConfigProxyLoader";
		private static const FILE_ID:String = "configXML";
		private static const ESTIMATED_BYTES:int = 1024;
		
		protected var loader : LoaderMax;
		
		protected var _settingsFeedPath:String;
		protected var _smallLEDFeedPath:String;
		protected var _cinemaLEDFeedPath:String;
		protected var _updatedFeedPath:String;
		protected var _updateURL : String;
		protected var _apiBaseURL : String;
		protected var _imageBasePath:String;
		protected var _videosDir:File;
		protected var _defaultCinemaVidoes:Vector.<String>;
		private var _randomArabic : String;
		protected var _errorMessageEnglish:String;
		protected var _errorMessageArabic:String;
		protected var _updatedSettingsCheckFrequency:int;
		
		public function ConfigProxy()
		{
		}

		public function loadConfigFile(url : String) : void
		{
			_defaultCinemaVidoes = new Vector.<String>();
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
			if(result)
			{
				_apiBaseURL = result.APIEndpoints.APIBaseURL.@path;
				/*	making these relative to above so simpler to edit config file
					also doesn't look like _imageBasePath is ever used so omitting and removing from config
				 
				_settingsFeedPath = result.APIEndpoints.SettingsFeed.@path;
				_smallLEDFeedPath = result.APIEndpoints.SmallLEDFeed.@path;
				_cinemaLEDFeedPath = result.APIEndpoints.CinemaLEDFeed.@path;
				_updatedFeedPath = result.APIEndpoints.UpdatedFeed.@path;
				_updateURL = result.UpdateURL.@path;
				_imageBasePath = result.ImageBasePath.@path;
				*/
				_settingsFeedPath = _apiBaseURL + result.APIEndpoints.SettingsFeed.@path;
				_smallLEDFeedPath = _apiBaseURL + result.APIEndpoints.SmallLEDFeed.@path;
				_cinemaLEDFeedPath = _apiBaseURL + result.APIEndpoints.CinemaLEDFeed.@path;
				_updatedFeedPath = _apiBaseURL + result.APIEndpoints.UpdatedFeed.@path;
				_updateURL = _apiBaseURL + result.UpdateURL.@path;
				 
				 var vidPath:String =result.VideoPath.@path; 
				_videosDir = File.documentsDirectory.resolvePath(vidPath);
				for each(var video:XML in result.DefaultCinemaVideos.children())
				{
					var p:String = _videosDir.url + File.separator + video.@path;
					_defaultCinemaVidoes.push(p);
				}
				_randomArabic = result.RandomArabicString.toString();
				_errorMessageEnglish = result.ErrorMessageEnglish.toString();
				_errorMessageArabic = result.ErrorMessageArabic.toString();
				_updatedSettingsCheckFrequency = int(result.UpdatedSettingsCheckFrequency);
				
				dispatch(new Event(ConfigProxy.LOAD_COMPLETE));
			}
			else
			{
				dispatch(new Event(ConfigProxy.LOAD_FAIL));
			}
		}
		
		public function get settingsFeedPath() : String
		{
			return _settingsFeedPath;
		}

		public function set settingsFeedPath(settingsFeedPath : String) : void
		{
			_settingsFeedPath = settingsFeedPath;
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

		public function get randomArabic() : String
		{
			return _randomArabic;
		}

		public function get imageBasePath() : String
		{
			return _imageBasePath;
		}

		public function get videosDir() : File
		{
			return _videosDir;
		}
		
		public function get defaultCinemaVidoes() : Vector.<String>
		{
			return _defaultCinemaVidoes;
		}

		public function get updatedFeedPath():String
		{
			return _updatedFeedPath;
		}

		public function set updatedFeedPath(updatedFeedPath:String):void
		{
			_updatedFeedPath = updatedFeedPath;
		}

		public function get updatedSettingsCheckFrequency():int
		{
			return _updatedSettingsCheckFrequency;
		}

		public function set updatedSettingsCheckFrequency(updatedSettingsCheckFrequency:int):void
		{
			_updatedSettingsCheckFrequency = updatedSettingsCheckFrequency;
		}

		public function get errorMessageEnglish():String
		{
			return _errorMessageEnglish;
		}

		public function set errorMessageEnglish(errorMessageEnglish:String):void
		{
			_errorMessageEnglish = errorMessageEnglish;
		}

		public function get errorMessageArabic():String
		{
			return _errorMessageArabic;
		}

		public function set errorMessageArabic(errorMessageArabic:String):void
		{
			_errorMessageArabic = errorMessageArabic;
		}

		private static const logger:ILogger = GetLogger.qualifiedName(ConfigProxy);

	}
}
