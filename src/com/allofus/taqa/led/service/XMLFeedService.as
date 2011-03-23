package com.allofus.taqa.led.service
{
	import nl.demonsters.debugger.MonsterDebugger;

	import com.allofus.shared.logging.GetLogger;
	import com.allofus.taqa.led.model.IXMLProxy;
	import com.allofus.taqa.led.service.events.XMLFeedEvent;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.data.LoaderMaxVars;

	import org.robotlegs.mvcs.Actor;

	import mx.logging.ILogger;

	/**
	 * @author jc
	 * this will fetch xml from a remote server and push the result into a model
	 */
	public class XMLFeedService extends Actor
	{
		
		protected var loaderId:String = "xmlFeedLoader";
		protected var _loader:LoaderMax;
		
		protected var pendingRequests:Vector.<XMLFeedVO>;
		
		public function XMLFeedService()
		{
			pendingRequests = new Vector.<XMLFeedVO>();
		}
		
		public function retrieveFeed(url:String, targetModel:IXMLProxy):void
		{
			logger.info("retrieveFeed " + url + " into " + targetModel);
			var vo:XMLFeedVO = new XMLFeedVO();
			vo.url = url;
			//vo.url = url + "BROKEN!";
			vo.targetModel = targetModel;
			pendingRequests.push(vo);
			loadResult(vo);
		}
		
		protected function loadResult(vo:XMLFeedVO):void
		{
			var xldr:XMLLoader = new XMLLoader(vo.url, {name:vo.url});
			loader.append(xldr);
			switch(loader.status)
				{
					case LoaderStatus.READY:
					case LoaderStatus.PAUSED:
					case LoaderStatus.COMPLETED:
						_loader.load();
						break;

					case LoaderStatus.LOADING:
						//logger.info("loader already in loading state, should just pick up our append: " + _loader.status);
						break;
				}
		}
		
		protected function get loader():LoaderMax
		{
			if(!_loader)
			{
				var lmv:LoaderMaxVars = new LoaderMaxVars();
				lmv.name = loaderId;
				lmv.onError = handleLoadError;
				lmv.onFail = handleLoadFail;
				lmv.onIOError = handleIOError;
				lmv.onChildComplete = handleItemComplete;
				lmv.onComplete = handleQueueComplete;
				_loader = new LoaderMax(lmv);
			}
			return _loader;
		}
		
		protected function handleItemComplete(event:LoaderEvent):void
		{
			logger.debug("item complete: " + event);
			var vo:XMLFeedVO;
			var xloader:XMLLoader;
			var xml:XML;
			for (var i : int = 0; i < pendingRequests.length; i++) 
			{
				vo = pendingRequests[i];
				xloader = loader.getLoader(vo.url);
				xml = xloader.getContent(vo.url) as XML;
				if(xml)
				{
					vo.data = xml;
					xloader.dispose(true);
					vo.targetModel.data = vo.data;
					dispatch(new XMLFeedEvent(XMLFeedEvent.FETCH_COMPLETED, vo));//do we need to dispatch this to the system? we are injecting data to our models anyway, maybe let them dispatch that their data has refreshed...
					pendingRequests.splice(i, 1);
					i--;
				}
			}
		}
		
		protected function handleQueueComplete(event:LoaderEvent):void
		{
			MonsterDebugger.trace("+++++", event);
			logger.info("queueComplete: ");
		}
		
		protected function handleLoadError(event:LoaderEvent):void
		{
			logger.error("handleLoadError: " + event.target + " : " + event.text + " event: " + event);
		}
		
		protected function handleLoadFail(event:LoaderEvent):void
		{
			logger.error("handleLoadFail: " + event.target + " : " + event.text + " event: " + event);
		}
		
		protected function handleIOError(event:LoaderEvent):void
		{
			logger.error("handleIOError: " + event.target + " : " + event.text + " event: " + event);
			var vo:XMLFeedVO;
			for (var i : int = 0; i < pendingRequests.length; i++) 
			{
				vo = pendingRequests[i];
				vo.targetModel.data = null;
			}
		}
		
		private static const logger:ILogger = GetLogger.qualifiedName( XMLFeedService );
	}
}
