package com.tontonpiero 
{
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class TDM 
	{
		static private var _authKey:String = null;
		static private var _provider:String = null;
		static private var _identifier:String = null;
		static private var _status:String = "off";
		
		public function TDM() 
		{
			
		}
		
		static public function setup(provider:String, identifier:String, onSetupComplete:Function = null):void {
			_provider = provider;
			_identifier = identifier;
			CallManager.httpGet("", null, function(data:*):void {
				_status = data.status;
				if ( onSetupComplete != null ) onSetupComplete.call();
			}, function(error:*):void {
				_status = "off";
				if ( onSetupComplete != null ) onSetupComplete.call();
			});
		}
		
		static public function isAuthenticated():Boolean {
			return _status == "on" && _authKey != null;
		}
		
		static public function auth(onComplete:Function = null, onError:Function = null):void {
			if ( _status != "on" ) {
				if ( onError != null ) onError.call(null, { msg:"API status = " + _status, code:100 } );
				return;
			}
			CallManager.httpGet("auth", { id:_identifier }, function(data:*):void {
				_authKey = data.authKey;
				CallManager.addHeader("authKey", _authKey);
				if ( onComplete != null ) onComplete.call(null, data);
			}, function(error:*):void {
				if ( onError != null ) onError.call(null, error);
			});
		}
		
		static public function me(onComplete:Function = null, onError:Function = null):void {
			if ( !isAuthenticated() ) {
				if ( onError != null ) onError.call(null, { msg:"Not authenticated", code:101 } );
				return;
			}
			CallManager.httpGet("me", { id:_identifier }, function(data:*):void {
				if ( onComplete != null ) onComplete.call(null, data);
			}, function(error:*):void {
				if ( error.code == 4 ) {
					renewAuthKey(me, onComplete, onError);
					return;
				}
				if ( onError != null ) onError.call(null, error);
			});
		}
		
		static public function levels(onComplete:Function = null, onError:Function = null):void {
			if ( !isAuthenticated() ) {
				if ( onError != null ) onError.call(null, { msg:"Not authenticated", code:101 } );
				return;
			}
			CallManager.httpGet("levels", { id:_identifier }, function(data:*):void {
				if ( onComplete != null ) onComplete.call(null, data);
			}, function(error:*):void {
				if ( error.code == 4 ) {
					renewAuthKey(me, onComplete, onError);
					return;
				}
				if ( onError != null ) onError.call(null, error);
			});
		}
		
		static private function renewAuthKey(onComplete:Function, ...params):void {
			auth(function(data:*):void {
				if ( onComplete != null ) onComplete.apply(null, params);
			});
		}
		
	}

}