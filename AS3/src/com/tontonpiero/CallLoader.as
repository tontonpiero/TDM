package com.tontonpiero 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class CallLoader extends URLLoader 
	{
		public var id:String;
		public var url:String;
		
		public function CallLoader(id:String) 
		{
			super(null);
			this.id = id;
			this.url = null;
		}
		
		override public function load(request:URLRequest):void 
		{
			super.load(request);
			if ( request ) url = request.url;
		}
		
		override public function close():void 
		{
			super.close();
			url = null;
		}
		
		override public function toString():String {
			return "[CallLoader id=" + id + " available=" + available + "]";
		}
		
		public function get available():Boolean { return url == null; }
		
	}

}