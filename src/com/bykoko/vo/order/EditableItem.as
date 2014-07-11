package com.bykoko.vo.order
{
	import com.bykoko.domain.Constants;
	import com.bykoko.presentation.product.designer.EditableBase;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.presentation.product.designer.EditableImage;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.presentation.product.designer.EditableTextBase;
	import com.bykoko.presentation.product.designer.IEditable;
	import com.bykoko.util.ColorUtil;
	import com.bykoko.util.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class EditableItem
	{
		private static const TIP_IMAGE:String = "img";
		private static const TIP_TEXT:String = "txt";

		[Required]
		public var id:String;
		
		[Required]
		public var width:Number;
		
		[Required]
		public var height:Number;
		
		[Required]
		public var x:Number;
		
		[Required]
		public var y:Number;
		
		//type of the item: text or image (image can be a design or an uploaded photo)
		[Required]
		public var tip:String;
		
		//[Required] not required because the object can have rotation = 0
		public var transform:String;
		
		//in case the item is an image		
		public var imageFileName:String;
		
		//in case the item is an image
		public var removeBackground:String;
		
		//in case there is a tint color (for designs)
		public var color:String;

		[Required]
		public var pvp:Number;
		
		[Required]
		public var piva:Number;
		
		//formatted text in SVG format
		[ChildTextNode]
		public var svg:String;
		
		//formatted text in TLF format
		[ChildTextNode]
		public var tlf:String;
		
		public function EditableItem()
		{
			
		}
		
		
		public function setItem(editableBase:EditableBase):void
		{
			id = editableBase.assetId.toString();
			tip = (editableBase is EditableTextBase)?	TIP_TEXT:TIP_IMAGE;
			
			//width and height are calculated different for text elements and the rest
			width = MathUtil.round((editableBase as IEditable).size.width, 2);
			height = MathUtil.round((editableBase as IEditable).size.height, 2);
			
			//prices: send 0 for texts and images. Send the pvp/piva for designs
			if(editableBase is EditableDesign)
			{
				pvp = (editableBase as EditableDesign).design.pvp;
				piva = (editableBase as EditableDesign).design.piva;	
			}
			else
			{
				pvp = piva = 0;
			}
			
			//position is calculated different for text elements and the rest
			var position:Point = (editableBase as IEditable).positionForSVG;
			x = position.x;
			y = position.y;
			
			if(editableBase.isRotated)
			{
				transform = editableBase.rotationTransform;
			}

			if(editableBase is EditableImage)
			{
				imageFileName = (editableBase as EditableImage).fileName;
				removeBackground = (editableBase as EditableImage).removeBackground.toString();
			}
			
			if(editableBase is EditableDesign && (editableBase as EditableDesign).color > -1)
			{
				color = ColorUtil.toHtmlString((editableBase as EditableDesign).color);
			}
		}
		
		
		
		public function getDegreesFromRotationTransform(transformStr:String):Number
		{
			//expects an string as rotate( 50.21245429870058 , 97.75 , 116.00)
			var rotateStr:String = Constants.SVG_ATTRIBUTE_ROTATE + Constants.SVG_ATTRIBUTE_OPENING;
			var index:int = transformStr.indexOf(rotateStr);
			if(index != -1)
			{
				return Number(transformStr.substring(rotateStr.length , transformStr.indexOf(",")));
			}
			else
			{
				return 0;
			}
		}
	}
}