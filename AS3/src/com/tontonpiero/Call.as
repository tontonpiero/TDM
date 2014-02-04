package com.tontonpiero 
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
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
		
		public function Call(url:String, params:* = null, onComplete:Function = null, onError:Function = null, options:* = null) {
			this.url = url;
			this.params = params ? params : {};
			this.onComplete = onComplete;
			this.onError = onError;
			this.options = options ? options : { };
		}
		
		public function load(loader:CallLoader):void {
			var vars:URLVariables = new URLVariables();
			for (var key:String in params) vars[key] = params[key];
			
			_loader = loader;
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.addEventListener(Event.COMPLETE, onLoadingComplete);
			//trace(this, _loader.id);
			var request:URLRequest = new URLRequest(url);
			if ( CallManager.headers ) request.requestHeaders = CallManager.headers;
			if ( options && options._method ) request.method = options._method;
			request.data = vars;
			_loader.available = false;
			_loader.load(request);
		}
		
		private function onLoadingComplete(e:Event):void 
		{
			var data:* = null;
			try { data = _loader.data ? JSON.parse(_loader.data) : null; } catch (err:Error){}
			if ( data && data.error ) {
				if ( data.errorCode == 4 ) { // authKey expired
					CallManager.httpGet("auth", { id:"xxx" }, function(data:*):void { CallManager.addHeader("authKey", data.authKey); retry(); } );
					return;
				}
				else {
					if ( onError != null ) onError.call(null, { msg:data.error, code:data.errorCode } );
				}
			}
			else {
				if ( !data ) data = _loader.data;
				if ( onComplete != null ) onComplete.call(null, data);
			}
			destroy();
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
			if ( onError != null ) onError.call(null, { msg:e.text, code:e.errorID });
			destroy();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			if ( onError != null ) onError.call(null, { msg:e.text, code:e.errorID } );
			destroy();
		}
		
		private function onHTTPStatusEvent(e:HTTPStatusEvent):void 
		{
			//if ( onError != null ) onError.call(null, e.toString());
			//destroy();
		}
		
		private function removeListeners():void 
		{
			if( _loader ) {
				_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_loader.removeEventListener(Event.COMPLETE, onLoadingComplete);
			}
		}
		
		public function destroy():void {
			if( _loader ) {
				removeListeners();
				_loader.available = true;
			}
			_loader = null;
			CallManager.checkQueue();
		}
		
		public function toString():String {
			return "[Call url=\"" + url + "\"]";
		}
		
	}

}