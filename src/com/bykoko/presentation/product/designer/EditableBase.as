package com.bykoko.presentation.product.designer
{
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.IEditableMessage;
	import com.bykoko.presentation.common.MarchingAntsSelectionRectangle;
	import com.bykoko.util.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElementContainer;
	
	import spark.core.SpriteVisualElement;


	public class EditableBase extends SpriteVisualElement implements IEditable
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public var assetId:int;
		protected var loader:Loader;
		private var _content:SpriteVisualElement;
		
		//each class extending this base class hold a different type of content (text, swf, image)
		//so the content's bounds are calculated different for each one
		public var assetBounds:Rectangle;

		//holder to be used as reference to get the coordinates of this editable item
		//based on the valid area of design
		public var referenceHolder:SpriteVisualElement;
		
		//coordinates of the object for the SVG version
		protected var _positionForSVG:Point;
		
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		//
		public function EditableBase(id:int, asset:*):void
		{
			this.assetId = id;
		}

		
		
		//Removes the element from the displayList. Before that, it's position for the svg order is calculated
		public function remove():void
		{
			//call the getter just to update the internal value _positionForSVG
			var position:Point = positionForSVG;
			(parent as IVisualElementContainer).removeElement(this);
		}
		
		
		
		//
		public function resizeBy(scaleX:Number, scaleY:Number):void 
		{
			content.scaleX *= Math.abs(scaleX); 
			content.scaleY *= Math.abs(scaleY);
		}
		
		
		
		//
		public function resizeTo(scaleX:Number, scaleY:Number):void 
		{
			content.scaleX = Math.abs(scaleX); 
			content.scaleY = Math.abs(scaleY);
		}
		
		
		
		//
		public function rotate(angle:Number):void
		{
			content.rotation += angle;
		}
		
		
		
		//
		public function rotateTo(angle:Number):void
		{
			content.rotation = angle;
		}
		
		
		
		//
		public function rotateBy(degrees:Number):void
		{
			content.rotation += degrees;
		}
		
		
		
		//
		public function translate(offsetX:Number, offsetY:Number):void
		{
			this.x += offsetX;
			this.y += offsetY;
		}
		
		

		//
		public function get rotationTransform():String
		{
			//get the bounds of the editable item based on parent
			//when getting the bounds, get it without rotation in content
			var angle:Number = content.rotation;
			content.rotation = 0;
			var bounds:Rectangle = getBounds(this.parent);
			content.rotation = angle;

			//return the rotation transformation properties in svg format:
			// "rotate( 50.21245429870058 , 97.75 , 116.00)"
			/*	SVG REFERENCE:
				rotate(<rotate-angle> [<cx> <cy>]), which specifies a rotation by <rotate-angle> degrees about a given point.
				If optional parameters <cx> and <cy> are supplied, the rotate is about the point (cx, cy). 
				The operation represents the equivalent of the following specification: 
				translate(<cx>, <cy>) rotate(<rotate-angle>) translate(-<cx>, -<cy>).
			*/
			//optional parameters are supplied because the rotation always is done around the inner center
			//of our item, so width/2 and height/2 are applied. 
			//Also, pay attention to:
			//a)The position of the item. If the object is not in (0,0), the distance 
			//	from the center has to be added to continue rotating around the center of the object.
			//b)in SVG, the y coordinate is relative to the base line of the text, not to the ascent	
			var positionFromCenter:Point = positionForSVG;
			return Constants.SVG_ATTRIBUTE_ROTATE +
				Constants.SVG_ATTRIBUTE_OPENING +
				MathUtil.round(content.rotation, 2).toString() +
				Constants.SVG_SEPARATOR_VALUE + 
				Number(MathUtil.round(bounds.width / 2, 2) + positionFromCenter.x).toString() +
				Constants.SVG_SEPARATOR_VALUE +
				Number(MathUtil.round(bounds.height / 2, 2) + positionFromCenter.y).toString() +
				Constants.SVG_ATTRIBUTE_ENCLOSING;
		}
		
		
		
		//
		public function get size():Rectangle
		{
			var angle:Number = content.rotation;
			content.rotation = 0;
			var size:Rectangle = getBounds(parent).clone();
			content.rotation = angle;
			return size;
		}
		
		
		
		//
		public function get scale():Number
		{
			return content.scaleX;
		}

		
		
		//setter only used for object that belongs to an existing order (called in the bootstrap)
		public function set positionForSVG(p:Point):void
		{
			_positionForSVG = p.clone();	
		}
		
		
		
		//
		public function get positionForSVG():Point
		{
			//1) objects that belong to a product display which is not active, they already have a value
			//for _positionForSVG, as the remove function estimates the value before removing the
			//element from the display list. 
			
			//reference holder can be null for those object that belong to an existing order
			//that has been loaded. These objects will not be modified
			if((_positionForSVG == null || this.stage != null) && referenceHolder != null)
			{
				var target:DisplayObject = (this is EditableTextBase)?	(this as EditableTextBase).bitmap : this.content;
				_positionForSVG = calculatePositionForSVG(target);
			}
			return _positionForSVG;
		}
		
		
		
		//
		public function get isRotated():Boolean
		{
			return (content.rotation != 0); 
		}
		
		
		//
		public function get isScaled():Boolean
		{
			return (content.scaleX != 1);
		}
		
		
		public function get content():SpriteVisualElement
		{
			if(_content == null)
				_content = new SpriteVisualElement();
			return _content;
		}
		
		public function set content(value:SpriteVisualElement):void
		{
			_content = value;
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		protected function setupContent(asset:*, assetBounds:Rectangle):void
		{
			this.assetBounds = assetBounds;

			//add the loaded image
			content.addChild(asset);

			if(asset is Bitmap)
				(asset as Bitmap).smoothing = true;
			
			//center the bitmap according its parent, so we
			//can rotate and translate it based on the center
			asset.x = -assetBounds.width/2;
			asset.y = -assetBounds.height/2;
			
			addChild(content);
			
			//items that belong to an existing order that is being recreated: 
			//if the user is the owner of the order, these items are added into the context.
			//Otherwise, are not added into the context (these items are not included into
			//the appDomain with the function addEditableDesign (which includes them into the context)
			if(dispatcher != null)
			{
				dispatcher( new IEditableMessage(IEditableMessage.COMPLETE, this));
			}
		}
		
		
		
		//
		protected function calculatePositionForSVG(target:DisplayObject):Point
		{
			//get the position based on the holder that holds the active design area.
			//when getting the bounds, get it without rotation in content
			var angle:Number = content.rotation;
			content.rotation = 0;

			//get coordinates of the content (a bitmap for EditableTextBase instances)
			var topLeftContent:Point = target.getBounds(referenceHolder).topLeft.clone();

			//get coordinates of the valid design area
			var topLeftDesignArea:Point = (referenceHolder.getChildAt(0) as MarchingAntsSelectionRectangle).getBounds(referenceHolder).topLeft.clone(); 
			
			//set the angle again
			content.rotation = angle;

			//return the position based on the top left corner of the design area
			var position:Point = topLeftContent.subtract(topLeftDesignArea);
			position.x = Math.round(position.x);
			position.y = Math.round(position.y);
			return position;
		}
	}
}