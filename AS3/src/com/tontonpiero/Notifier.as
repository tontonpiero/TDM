package com.tontonpiero 
{
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Notifier 
	{
		static private var _listeners:* = {};
		
		public function Notifier() { }
		
		static public function listen(id:String, callback:Function):void {
			if ( !_listeners[id] ) _listeners[id] = new Array();
			for each (var fct:Function in _listeners[id]) {
				if ( fct == callback ) return;
			}
			_listeners[id].push(callback);
		}
		
		static public function remove(callback:Function):void {
			for (var id:String in _listeners) 
			{
				var index:int = _listeners[id].indexOf(callback);
				if ( index >= 0 ) _listeners[id].splice(index, 1);
			}
		}
		
		static public function notify(id:String, data:* = null):void {
			if ( !_listeners[id] ) return;
			for each (var fct:Function in _listeners[id]) {
				fct.call(null, data);
			}
		}
		
	}

}