package com.bykoko.presentation.product.designer
{
	import com.bykoko.vo.order.EditableItem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//Editable items that are not text (pictures and designs), share some functionality as
	//the way they execute its autoSetup functionality
	
	public class EditablePictureBase extends EditableBase
	{
		public function EditablePictureBase(id:int, asset:*)
		{
			super(id, asset);
		}
		
		
		public function autoSetup(asset:DisplayObject, editableItem:EditableItem, topLeftCornerDesignArea:Point):void
		{
			//add the swf to the displayList
			setupContent(asset, new Rectangle(0, 0, asset.width, asset.height));
			
			//apply the transforms indicated
			resizeTo( editableItem.width / asset.width, editableItem.height / asset.height);
			
			//the coords of the editableItem are relative to the design area. These coords are the left-top
			//corner of the design
			this.x = topLeftCornerDesignArea.x + editableItem.x + (editableItem.width/2);
			this.y = topLeftCornerDesignArea.y + editableItem.y + (editableItem.height/2);
			
			//apply rotation
			if(editableItem.transform && editableItem.transform.length > 0)
			{
				rotateTo(editableItem.getDegreesFromRotationTransform(editableItem.transform));
			}
		}
	}
}