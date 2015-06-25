package supportClasses {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.states.State;
	
	public class Dao {
		
		public var daoitems: Vector.<DaoItem> = new <DaoItem>[];
		
		public var dbfilename:String;
		
		
		public function insertOrUpdate(a:*):void {
			var daoitem:DaoItem = new DaoItem();
			daoitem.a = a;
			daoitem.dbfilename = dbfilename;
			daoitem.callback = function(data:Array):void {
				var daoitem:DaoItem = new DaoItem();
				daoitem.a = a;
				daoitem.dbfilename = dbfilename;
				if (data[0].ct == 0) {
					daoitem.executeInsert();
				} else {
					daoitem.executeUpdate();
				}
				
				daoitems.push(daoitem);
			}
			daoitem.query("select count(*) ct from " + a._tablename_ + " where sid='" + a.sid + "'");
			daoitems.push(daoitem);
		}
		
		public function query(sql:String, callback: Function):void {
			var daoitem:DaoItem = new DaoItem();
			daoitem.dbfilename = dbfilename;
			daoitem.callback = callback;
			daoitem.query(sql);
			daoitems.push(daoitem);
		}
		
		public function updateBySQL(sql:String):void {
			var daoitem:DaoItem = new DaoItem();
			daoitem.dbfilename = dbfilename;
			daoitem.query(sql);
			daoitems.push(daoitem);
		}
	}
}