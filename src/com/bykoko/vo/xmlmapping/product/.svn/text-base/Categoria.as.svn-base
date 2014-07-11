package com.bykoko.vo.xmlmapping.product
{
	import mx.collections.ArrayCollection;

	public class Categoria
	{
		[Required]
		public var name:String;
		
		[Required]
		public var id:int;
		
		private var _subcategories:ArrayCollection;

		
		
		/**************************************************************************************
		 * GETTER / SETTER
		 *************************************************************************************/
		
		[Bindable]
		public function get subcategories():ArrayCollection
		{
			if(_subcategories == null)
				_subcategories = new ArrayCollection();
			
			return _subcategories;
		}
		
		[Ignore]
		public function set subcategories(value:ArrayCollection):void
		{
			_subcategories = value;
		}
	}
}