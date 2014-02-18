package com.tontonpiero 
{
	import flash.net.URLRequestHeader;
	import flash.utils.getDefinitionByName;
	
	/**
	 * This manager is an easy way to do http calls.
	 * It supports many features like doing post/get calls, sending post data.
	 * It reuses URLLoader (memory gains) and queue calls until a loader is available.
	 * It manages call timeout, error handling, http headers.
	 * It's easy to customize logger, data parsing, you can add dedicated loaders.
	 * Every call can be customized too, with many options :
		 * "debug" : set to false to disable logger for this call
		 * "info" : set to true to add call infos (like totalTime) in callbacks arguments
		 * "header" : set to false to not add headers
		 * "timeout" : overrides defaultTimeout
		 * "priority" : set to true to add call on the top of the queue
		 * "important" : set to true to add call in the queue even if the queue is full
		 * "parameters" : add custom parameters to "complete" and "error" callbacks (can be an array of parameters). Don't forget to catch them in the callbacks definition.
	 * @author Tontonpiero
	 */
	public class CallManager
	{
		static private var _baseUrl:String;
		static private var _parseFunction:Function;
		static public var headers:Array;
		static public var defaultTimeout:Number;
		static public var loggerFunction:Function;
		
		static private var _loaders:Vector.<CallLoader> = new Vector.<CallLoader>;
		static private var _dedicatedLoaders:* = {};
		static private var _queue:Vector.<Call> = new Vector.<Call>;
		static public var queueSize:uint = 0;
		
		public function CallManager() {}
		
		/**
		 * Setup manager, make sure to call this function before any http call
		 * @param	baseUrl				useful to avoid adding website domain on every call
		 * @param	pollSize			the number of URLLoader instances that can be used at the same time
		 * @param	defaultTimeout		the default timeout duration (in ms) apply on every call (0 to deactivate)
		 * @param	loggerFunction		the function called to log informations (ex : "trace") (one parameter of type String) set null to deactivate
		 * @param	parseFunction		the function used to decode received data (one parameter of type String that returns an Object) if null, JSON.parse will be used
		 * @param	queueSize			the maximum size of queued calls (0 = no limit)
		 */
		static public function setup(baseUrl:String = null, pollSize:uint = 2, defaultTimeout:Number = 10000, loggerFunction:Function = null, parseFunction:Function = null, queueSize:uint = 0):void {
			CallManager.parseFunction = parseFunction;
			CallManager.loggerFunction = loggerFunction;
			CallManager.defaultTimeout = defaultTimeout;
			CallManager.queueSize = queueSize;
			if ( baseUrl ) CallManager.baseUrl = baseUrl;
			if ( pollSize == 0 ) pollSize = 1;
			if( _loaders.length < pollSize ) for (var i:int = _loaders.length; i < pollSize; i++) _loaders.push(new CallLoader(i.toString()));
		}
		
		/**
		 * Do a http call with get parameters
		 * @param	url					the distant url. if url doesn't start with "http", it will be concatenated with baseUrl
		 * @param	params				the get parameters (key/value object)
		 * @param	onComplete			the complete callback (one parameter of type Object containing decoded received data)
		 * @param	onError				the error callback (one parameter of type Object containing error "msg" and "code")
		 * @param	options				the additional options (supported options are described in the class documentation)
		 * @return	a boolean that indicates if the call is executed now (otherwise it is added to the queue)
		 */
		static public function httpGet(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Boolean {
			if ( options ) options.method = "get"; else options = { method:"get" };
			return call(url, params, onComplete, onError, options);
		}
		
		/**
		 * Do a http call with post parameters
		 * @param	url					the distant url. if url doesn't start with "http", it will be concatenated with baseUrl
		 * @param	params				the post parameters (key/value object)
		 * @param	onComplete			the complete callback (one parameter of type Object containing decoded received data)
		 * @param	onError				the error callback (one parameter of type Object containing error "msg" and "code")
		 * @param	options				the additional options (supported options are described in the class documentation)
		 * @return	a boolean that indicates if the call is executed now (otherwise it is added to the queue)
		 */
		static public function httpPost(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Boolean {
			if ( options ) options.method = "post"; else options = { method:"post" };
			return call(url, params, onComplete, onError, options);
		}
		
		/**
		 * Do a http call with post data
		 * @param	url					the distant url. if url doesn't start with "http", it will be concatenated with baseUrl
		 * @param	data				the post data (such as byteArray, file, picture, etc.)
		 * @param	contentType			the data contentType
		 * @param	onComplete			the complete callback (one parameter of type Object containing decoded received data)
		 * @param	onError				the error callback (one parameter of type Object containing error "msg" and "code")
		 * @param	options				the additional options (supported options are described in the class documentation)
		 * @return	a boolean that indicates if the call is executed now (otherwise it is added to the queue)
		 */
		static public function postData(url:String, data:* = null, contentType:String = null, onComplete:Function = null, onError:Function = null, options:* = null):Boolean {
			if ( options ) options.method = "post"; else options = { method:"post" };
			options.contentType = contentType;
			return call(url, data, onComplete, onError, options);
		}
		
		static private function call(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null):Boolean {
			if ( queueSize > 0 && _queue.length >= queueSize ) {
				if( !options || !options.important ) return false;
			}
			if ( url == null ) return false;
			if ( url.charAt(0) == "/" ) url = url.substr(1, url.length - 1);
			if ( baseUrl && url.substr(0, 4) != "http" && url.substr(0, 1) != "." ) url = baseUrl + url;
			var call:Call = new Call(url, params, onComplete, onError, options);
			if ( call.getOption("priority", false) ) _queue.unshift(call); else _queue.push(call);
			return checkQueue();
		}
		
		/**
		 * check the call queue and call the first element if a loader is available
		 * @return a boolean that indicates if the call is executed
		 */
		static public function checkQueue():Boolean 
		{
			if ( _queue.length > 0 ) {
				var call:Call = _queue[0];
				var loader:CallLoader = null;
				if ( call.getOption("loaderId") ) loader = getDedicatedLoader(call.getOption("loaderId"));
				else loader = getAvailableLoader();
				if ( loader ) {
					call.load(loader);
					_queue.shift();
					return true;
				}
			}
			return false;
		}
		
		static private function getAvailableLoader():CallLoader 
		{
			for each (var loader:CallLoader in _loaders) 
			{
				if ( loader.available ) return loader;
			}
			return null;
		}
		
		/**
		 * Add a header to every calls
		 * @param	key					the header key
		 * @param	value				the header value
		 */
		static public function addHeader(key:String, value:String):void {
			if ( !headers ) headers = new Array();
			headers.push(new URLRequestHeader(key, value));
		}
		
		/**
		 * Instanciate a dedicated URLLoader. if a call specify this loader id, the call uses this loader. it's useful to avoid blocking standard poll loaders.
		 * @param	id					the dedicated loader id
		 */
		static public function addDedicatedLoader(id:String):void {
			if ( !_dedicatedLoaders[id] ) _dedicatedLoaders[id] = new CallLoader(id);
		}
		
		static private function getDedicatedLoader(id:String):CallLoader {
			return _dedicatedLoaders[id] && _dedicatedLoaders[id].available ? _dedicatedLoaders[id] : null;
		}
		
		static public function get baseUrl():String { return _baseUrl; }
		static public function set baseUrl(value:String):void {
			_baseUrl = value;
			if( _baseUrl && _baseUrl.charAt(_baseUrl.length - 1) != "/" ) _baseUrl += "/";
		}
		
		static public function get parseFunction():Function { return _parseFunction; }
		static public function set parseFunction(value:Function):void {
			_parseFunction = value;
			if ( _parseFunction == null ) _parseFunction = getDefinitionByName("JSON").parse;
		}
		
	}

}