package com.bykoko.vo
{
	import com.bykoko.vo.xmlmapping.product.Talla;

	[Bindable]
	public class TeamProductItemData
	{
		private var _num:String;
		private var _name:String;
		public var talla:Talla;
		
		public function TeamProductItemData()
		{
		}

		public function get name():String
		{
			if(_name == null)
				_name = "";
			return _name.toUpperCase();
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get num():String
		{
			if(_num == null)
				_num = "";
			return _num.toUpperCase();
		}

		public function set num(value:String):void
		{
			_num = value;
		}


	}
}