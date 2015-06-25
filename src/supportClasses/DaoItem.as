package supportClasses {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.describeType;
	
	import mx.controls.Alert;

	public class DaoItem {
		
		public var conn:SQLConnection = new SQLConnection();
		
		private var stmt:SQLStatement = new SQLStatement();
		
		public var a:*;
		
		public var dbfilename:String;
		
		public var callback:Function;
		
		public function executeInsert():void {
			var appStorage:File = File.applicationDirectory;
			var dbFile:File = appStorage.resolvePath(dbfilename + ".db");
			
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.open(dbFile);
		}
	
		
		protected function openHandler(event:SQLEvent):void {
			
			conn.removeEventListener(SQLEvent.OPEN, openHandler);
			
			conn.addEventListener(SQLEvent.BEGIN, beginHandler);
			conn.begin();
		}
		
		protected function beginHandler(event:SQLEvent):void {
			conn.removeEventListener(SQLEvent.BEGIN, beginHandler);
			
				
			stmt.sqlConnection = conn;
			
			var clazzinfo:XML =  describeType(a);

			var props:XMLList = clazzinfo.variable;
			
			var colnames:Array = [];
			
			var questFlags:Array = [];
			for each(var prop:XML in props) {
				colnames.push(prop.@name);
				questFlags.push("?");
			}
			
			
			stmt.text = 
				"INSERT INTO " + a._tablename_ + " (" + colnames + ") " + 
				"VALUES (" + questFlags + ")";
			for (var i:int = 0; i < questFlags.length; ++i) {
				stmt.parameters[i] = a[colnames[i] + ""];
			}
			
			stmt.addEventListener(SQLEvent.RESULT, resultHandler);
			stmt.execute();
		}
		
		protected function resultHandler(event:SQLEvent):void {
			conn.commit();
			conn.close();
		}
		
		
		public function executeUpdate():void {
			var appStorage:File = File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(dbfilename + ".db");
			
			conn.addEventListener(SQLEvent.OPEN, openUpdateHandler);
			conn.open(dbFile);
		}
		
		
		protected function openUpdateHandler(event:SQLEvent):void {
			
			conn.removeEventListener(SQLEvent.OPEN, openUpdateHandler);
			
			conn.addEventListener(SQLEvent.BEGIN, beginUpdateHandler);
			conn.begin();
		}
		
		protected function beginUpdateHandler(event:SQLEvent):void {
			conn.removeEventListener(SQLEvent.BEGIN, beginHandler);
			
			
			stmt.sqlConnection = conn;
			
			var clazzinfo:XML =  describeType(a);
			
			var props:XMLList = clazzinfo.variable;
			
			var setsqls:Array = [];
			
			var colnames:Array = [];
			for each(var prop:XML in props) {
				if (prop.@name + "" != 'sid') {
					colnames.push(prop.@name + "");
					setsqls.push(prop.@name + "=?"); 
				}
			}
			
			stmt.text = 
				"update  " + a._tablename_ + " set " + setsqls + " where sid=?";
			for (var i:int = 0; i < colnames.length; ++i) {
				stmt.parameters[i] = a[colnames[i]];
			}
			
			stmt.parameters[colnames.length] = a.sid;
			
			stmt.addEventListener(SQLEvent.RESULT, resultUpdateHandler);
			stmt.execute();
		}
		
		protected function resultUpdateHandler(event:SQLEvent):void {
			conn.commit();
			conn.close();
		}
		
		// 查询执行
		public function query(sql:String):void {
			var appStorage:File = File.applicationDirectory;
			var dbFile:File = appStorage.resolvePath(dbfilename + ".db");
			stmt.text = sql;
			stmt.sqlConnection = conn;
			conn.addEventListener(SQLEvent.OPEN, openQueryHandler);
			conn.open(dbFile);
		}
		
		protected function openQueryHandler(event:SQLEvent):void {
			stmt.addEventListener(SQLEvent.RESULT, resultQueryHandler);
			stmt.execute();
		}		
		
		protected function resultQueryHandler(event:SQLEvent):void {
			if (callback != null) {
				callback(stmt.getResult().data);
			}
			conn.close();
		}
	}
}