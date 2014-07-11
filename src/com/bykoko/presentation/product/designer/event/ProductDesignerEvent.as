package com.bykoko.presentation.product.designer.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ProductDesignerEvent extends Event
	{
		public static var ADD_EDITABLES:String = "addEditables";
		public static var REMOVE_EDITABLES:String = "removeEditables";
		public static var PRODUCT_SELECTED:String = "productSelected";
		public static var CHANGE_PRODUCT_DISPLAY:String = "changeProductDisplay";
		
		private var _editables:ArrayCollection;
		
		public function ProductDesignerEvent(type:String, editables:ArrayCollection = null)
		{
			super(type);
			_editables = editables;
		}
		
		public function get editables():ArrayCollection
		{
			if(_editables == null)
				_editables = new ArrayCollection();
			
			return _editables;
		}

		public function set editables(value:ArrayCollection):void
		{
			_editables = value;
		}

	}
}