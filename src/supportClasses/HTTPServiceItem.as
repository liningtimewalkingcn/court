package supportClasses {
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	public class HTTPServiceItem {
		private var _service:HTTPService = new HTTPService();
		private var _callback:Function;
		public var isbusy:Boolean;
		public var data:*;
		public var isjson:Boolean;
		
		public function HTTPServiceItem(url:String, data:*, showBusyCursor:Boolean) {
			_service.method = "POST";
			_service.url = url;
			_service.resultFormat = "text";
			_service.showBusyCursor = showBusyCursor;
			_service.addEventListener(ResultEvent.RESULT, invokeCallback);
			this.data = data;
		}
		
		public function send(cbk:Function, params:*):void {
			_callback = cbk;
			isbusy = true;
			_service.send(params);
		}
		
		private function invokeCallback(e:ResultEvent):void {
			if (_callback != null) {
				if (data != null) {
					if (isjson) {
						_callback.call(_service, JSON.parse(e.result + ""), data);
					} else {
						_callback.call(_service, e.result + "", data);
					}
				} else {
					if (isjson) {
						_callback.call(_service, JSON.parse(e.result + ""));
					} else {
						_callback.call(_service, e.result + "");
					}
				}
				_callback = null;
			}
			isbusy = false;
		}
	}
}