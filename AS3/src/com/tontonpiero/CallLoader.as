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
		public var available:Boolean;
		
		public function CallLoader(id:String) 
		{
			super(null);
			this.id = id;
			available = true;
		}
		
		override public function toString():String {
			return "[CallLoader id=" + id + " available=" + available + "]";
		}
		
	}

}