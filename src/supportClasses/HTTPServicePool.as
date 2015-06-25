package supportClasses{
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	public class HTTPServicePool {
		public var httpServices:Vector.<HTTPServiceItem> = new Vector.<HTTPServiceItem>();
		public var showBusyCursor:Boolean = true;
		public function post(url:String, params:* = null, data:* = null, callback:Function = null):void {
			if (params != null && params is Function) {
				callback = params;
				params = {};
			}
			
			if (data != null && data is Function) {
				callback = data;
				data = null;
			}
			
			var idleService:HTTPServiceItem = null;
			for each(var service:HTTPServiceItem in httpServices) {
				if (!service.isbusy) {
					idleService = service;
					break;
				}
			}
			idleService = new HTTPServiceItem(url, data, showBusyCursor);
			httpServices.push(idleService);
			
			var newparams:* = {};
			if (params == null)
				params = {};
			
			for (var key:* in params)
				newparams[key] = encodeURIComponent(params[key]);
			
			idleService.send(callback, newparams);
		}
		
		public function getJSON(url:String, params:*, data:* = null, callback:Function = null):void {
			if (params != null && params is Function) {
				callback = params;
				params = {};
			}
			
			if (data != null && data is Function) {
				callback = data;
				data = null;
			}
			
			var idleService:HTTPServiceItem = null;
			for each(var service:HTTPServiceItem in httpServices) {
				if (!service.isbusy) {
					idleService = service;
					break;
				}
			}
			idleService = new HTTPServiceItem(url, data, showBusyCursor);
			idleService.isjson = true;
			httpServices.push(idleService);
			
			var newparams:* = {};
			for (var key:* in params)
				newparams[key] = encodeURIComponent(params[key]);
			
			idleService.send(callback, newparams);
		}
	}
}