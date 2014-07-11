package com.bykoko.presentation.common
{
	import spark.components.Button;
	import spark.primitives.BitmapImage;
	
	public class IconButton extends Button
	{
		public function IconButton():void
		{
			super();
			useHandCursor = true;
			buttonMode = true;
		}
		
		/**
		 *  @private
		 *  Internal storage for the icon property.
		 */
		private var _icon:Class;
		
		
		
		/**
		 *  
		 */
		[Bindable]
		public function get icon():Class
		{
			return _icon;
		}
		
		
		
		/**
		 *  @private
		 */
		public function set icon(val:Class):void
		{
			_icon = val;
			
			if (iconElement != null)
				iconElement.source = _icon;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var iconElement:BitmapImage;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (icon !== null && instance == iconElement)
				iconElement.source = icon;
		}
	}
}