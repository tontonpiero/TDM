package com.tontonpiero 
{
	import flash.net.URLRequestHeader;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class CallManager
	{
		static public var baseUrl:String;
		static public var headers:Array;
		
		static private var _loaders:Vector.<CallLoader> = new Vector.<CallLoader>;
		static private var _queue:Vector.<Call> = new Vector.<Call>;
		
		public function CallManager() {}
		
		static public function setup(baseUrl:String, pollSize:int = 2):void {
			if ( baseUrl.charAt(baseUrl.length - 1) != "/" ) baseUrl += "/";
			CallManager.baseUrl = baseUrl;
			for (var i:int = 0; i < pollSize; i++) _loaders.push(new CallLoader(i));
		}
		
		static public function httpGet(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Call {
			if ( options ) options._method = "get" else options = { _method:"get" };
			return call(url, params, onComplete, onError, options);
		}
		
		static public function httpPost(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Call {
			if ( options ) options._method = "post" else options = { _method:"post" };
			return call(url, params, onComplete, onError, options);
		}
		
		static private function call(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Call {
			if ( url.substr(0, 4) != "http" ) url = baseUrl + url;
			var call:Call = new Call(url, params, onComplete, onError, options);
			_queue.push(call);
			checkQueue();
			return call;
		}
		
		static public function checkQueue():void 
		{
			if ( _queue.length > 0 ) {
				var loader:CallLoader = getAvailableLoader();
				if ( loader ) {
					var call:Call = _queue.shift();
					call.load(loader);
				}
			}
		}
		
		static private function getAvailableLoader():CallLoader 
		{
			for each (var loader:CallLoader in _loaders) 
			{
				if ( loader.available ) return loader;
			}
			return null;
		}
		
		static public function addHeader(key:String, value:String):void {
			if ( !headers ) headers = new Array();
			headers.push(new URLRequestHeader(key, value));
		}
		
	}

}