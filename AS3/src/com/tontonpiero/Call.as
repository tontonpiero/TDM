package com.tontonpiero 
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Call 
	{
		public var url:String;
		public var params:*;
		public var onComplete:Function;
		public var onError:Function;
		public var options:*;
		
		private var _loader:CallLoader;
		private var _timeoutId:uint;
		private var _startTime:Number;
		private var _openTime:Number;
		private var _callInfo:*;
		
		public function Call(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null) {
			this.url = url;
			this.params = params ? params : {};
			this.onComplete = onComplete;
			this.onError = onError;
			this.options = options ? options : { };
			this._callInfo = { };
		}
		
		public function load(loader:CallLoader):void {
			_loader = loader;
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.addEventListener(Event.COMPLETE, onLoadingComplete);
			_loader.addEventListener(Event.OPEN, onLoadingOpen);
			log("[Call::load] " + this + " (" + _loader.id +")");
			var request:URLRequest = new URLRequest(url);
			if ( CallManager.headers && getOption("header", true) ) request.requestHeaders = CallManager.headers;
			request.method = getOption("method", "post");
			
			var data:* = params;
			if ( getOption("contentType") ) {
				request.contentType = getOption("contentType");
			}
			else {
				if ( params && !(params is String) ) {
					data = new URLVariables();
					for (var key:String in params) data[key] = params[key];
				}
			}
			//trace(request.method, request.contentType, request.url);
			request.data = data;
			var timeout:Number = getOption("timeout", CallManager.defaultTimeout);
			if ( timeout > 0 ) _timeoutId = setTimeout(onTimeout, timeout);
			_startTime = new Date().time;
			_loader.load(request);
		}
		
		private function onLoadingOpen(e:Event):void 
		{
			_openTime = new Date().time;
			_loader.removeEventListener(Event.OPEN, onLoadingOpen);
		}
		
		public function getOption(key:String, defaultValue:* = null):* {
			return options && options[key] != undefined ? options[key] : defaultValue;
		}
		
		private function onTimeout():void 
		{
			callbackError("call timeout", 0);
			close();
		}
		
		private function log(msg:*):void {
			if ( CallManager.loggerFunction != null && getOption("debug", true) ) {
				CallManager.loggerFunction.call(null, msg);
			}
		}
		
		private function onLoadingComplete(e:Event):void 
		{
			var data:* = null;
			try { data = CallManager.parseFunction.call(null, _loader.data.replace(/\r\n/g, "")); } catch (err:Error) { data = null; }
			if ( data && data.hasOwnProperty("error") ) {
				callbackError(data.error, data.errorCode);
			}
			else {
				callbackComplete(data ? data : _loader.data);
			}
			close();
		}
		
		private function callbackComplete(data:*):void 
		{
			_callInfo.totalTime = new Date().time - _startTime;
			_callInfo.openingTime = _openTime - _startTime;
			_callInfo.receiptTime = new Date().time - _openTime;
			var params:Array = [data];
			if( getOption("info", false) ) params = params.concat(_callInfo);
			if( getOption("parameters") ) params = params.concat(getOption("parameters"));
			if ( onComplete != null ) onComplete.apply(null, params);
		}
		
		private function callbackError(msg:String, code:int):void 
		{
			_callInfo.totalTime = code > 0 ? new Date().time - _startTime : 0;
			log("[Call::error] " + this + " : " + msg + " (" + code +")");
			var params:Array = [ { msg:msg, code:code } ];
			if( getOption("info", false) ) params = params.concat(_callInfo);
			if( getOption("parameters") ) params = params.concat(getOption("parameters"));
			if ( onError != null ) onError.apply(null, params);
		}
		
		private function retry():void 
		{
			if ( _loader ) {
				removeListeners();
				load(_loader);
			}
		}
		
		private function onIOErrorEvent(e:IOErrorEvent):void 
		{
			callbackError(e.text, e.errorID);
			close();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			callbackError(e.text, e.errorID);
			close();
		}
		
		private function removeListeners():void 
		{
			if( _loader ) {
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_loader.removeEventListener(Event.COMPLETE, onLoadingComplete);
				_loader.removeEventListener(Event.OPEN, onLoadingOpen);
			}
		}
		
		public function close():void {
			log("[Call::close] " + this + " (totalTime=" + _callInfo.totalTime + "ms receiptTime=" + _callInfo.receiptTime + ")");
			clearTimeout(_timeoutId);
			if( _loader ) {
				removeListeners();
				_loader.close();
			}
			_loader = null;
			onError = null;
			onComplete = null;
			params = null;
			options = null;
			setTimeout(CallManager.checkQueue, 1);
		}
		
		public function toString():String {
			return "[Call url=\"" + url + "\"]";
		}
		
	}

}