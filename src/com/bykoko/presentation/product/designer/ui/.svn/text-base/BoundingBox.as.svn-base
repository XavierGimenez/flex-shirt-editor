package com.bykoko.presentation.product.designer.ui
{
	import assets.AssetsManager;
	
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.EditableTextMessage;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.common.MarchingAntsSelectionRectangle;
	import com.bykoko.presentation.product.designer.EditableBase;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.presentation.product.designer.EditableTextBase;
	import com.bykoko.presentation.product.designer.EditableTextTeam;
	import com.bykoko.presentation.product.designer.IEditable;
	import com.bykoko.util.MathUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.compose.TextFlowLine;
	
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;
	import mx.resources.ResourceManager;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	
	public class BoundingBox extends SpriteVisualElement
	{
		private const ICON_ACTIVE_STATE:Boolean = true;
		private const ICON_INACTIVE_STATE:Boolean = false;
		
		public var editableDesign:IEditable;
		public var parentLayer:Group;
		protected var marchingAntsRect:MarchingAntsSelectionRectangle;
		
		//holders for the transforming icon tools
		protected var icons:Array = [];
		
		//icons
		protected static const iconSize:int = 23;
		protected var scaleIcon:Sprite;
		protected var rotateIcon:Sprite;
		protected var translateIcon:Sprite;
		protected var removeIcon:Sprite;
		protected var activeIcon:Sprite; //icon being used
		
		protected var warningIcon:Sprite;
		protected var toolTip:IToolTip; 
		
		protected var rotatePoint:Point;
		protected var translationPoint:Point;
		protected var translationInitPosition:Point;
		protected var translationInitBoundingBoxPosition:Point;
		protected var initialScale:Point;
		protected var currentDegrees:Number = NaN;
		
		//draggable editable design
		protected var drag:DragItem;

		//minimum and maximum sizes when scaling the editable design
		private static const MAX_SIZE:int = 500;
		private static const MIN_SIZE:int = iconSize;

		[MessageDispatcher]
		public var dispatcher:Function;

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function BoundingBox(editableDesign:IEditable, parentLayer:Group, isDraggable:Boolean = true)
		{
			super();
			this.editableDesign = editableDesign;
			this.parentLayer = parentLayer;
			
			//create bounding box and transformation controls
			create();
			
			//make the editable design draggable
			if (isDraggable) 
			{
				new RemovableDragItem(this as DisplayObject);
				drag = new DragItem(editableDesign as DisplayObject);
				drag.addEventListener(Event.CHANGE, function():void
				{
					//notify that the editable item is changing its properties (is being translated)
					dispatcher(new ProductMessage(ProductMessage.EDITABLE_ITEM_CHANGING));
				});
			}
			
			//reset function will release the editable design from being draggable
			this.stage.addEventListener(MouseEvent.MOUSE_UP, reset );
		}
		
		
		
		//
		public function undoTranslation():void
		{
			if(translationInitPosition)
			{
				(editableDesign as EditableBase).x = translationInitPosition.x;
				(editableDesign as EditableBase).y = translationInitPosition.y;
				this.x = translationInitBoundingBoxPosition.x;
				this.y = translationInitBoundingBoxPosition.y;
				translationInitPosition = translationInitBoundingBoxPosition = null;
			}
		}
		
		
		
		//
		public function set showWarning(value:Boolean):void
		{
			warningIcon.visible = value;
		}
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		[MessageHandler(selector="numLinesChange")]
		public function handleEditableTextMessage(editableTextMessage:EditableTextMessage):void
		{
			drawRect();
		}
		
		
		
		//Receives the events launched from a subclass of an EditableTextBase instance when
		//the format of the text of the instance is being changed
		[MessageHandler(selector="textFormatChange")]
		public function handleTextFormatChangeEditableTextMessage(editableTextMessage:EditableTextMessage):void
		{
			drawRect();
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function create():void 
		{
			//add this BoundingBox
			parentLayer.addElement(this);
			
			//place this sprite in the center of the IEditable. The left-top corner of this
			//boundingbox will be at the center of the IEditable. The bounding rectangle will
			//be drawn around this center
			var editableItemBounds:Rectangle = (editableDesign as EditableBase).getBounds(parentLayer);
			x = editableItemBounds.x + editableItemBounds.width/2;
			y = editableItemBounds.y + editableItemBounds.height/2;
			
			//add holder for the icon bitmaps.It will be relocated once the rectangle is drawn
			icons.push(addChild(scaleIcon = new Sprite()));
			icons.push(addChild(rotateIcon = new Sprite()));
			icons.push(addChild(removeIcon = new Sprite()));
			icons.push(addChild(translateIcon = new Sprite()));
			icons.push(addChild(warningIcon = new Sprite()))

			//add bitmap for each icon holder
			scaleIcon.addChild(new AssetsManager.buttonScaleDesignOver());
			scaleIcon.addChild(new AssetsManager.buttonScaleDesign());
			rotateIcon.addChild(new AssetsManager.buttonRotateDesignOver());
			rotateIcon.addChild(new AssetsManager.buttonRotateDesign());
			removeIcon.addChild(new AssetsManager.buttonRemoveDesignOver());
			removeIcon.addChild(new AssetsManager.buttonRemoveDesign());
			translateIcon.addChild(new AssetsManager.buttonTranslateDesignOver());
			translateIcon.addChild(new AssetsManager.buttonTranslateDesign());
			warningIcon.addChild(new AssetsManager.boundingBoxWarning());
			
			//center each bitmap on its parent (when rotating the bounding
			//box, the icons are rotated in the reverse direction they always
			//keep visually without rotation
			for each(var iconHolder:Sprite in icons)
			{
				iconHolder.buttonMode = iconHolder.useHandCursor = true;
				for(var i:uint = 0; i<iconHolder.numChildren; i++)
				{
					iconHolder.getChildAt(i).x -= iconSize/2;
					iconHolder.getChildAt(i).y -= iconSize/2;
					(iconHolder.getChildAt(i) as Bitmap).smoothing = true;
				}
				
				if(iconHolder != warningIcon)
				{
					//hide the over state bitmap of the icon
					iconHolder.getChildAt(0).visible = false;
					iconHolder.addEventListener(MouseEvent.MOUSE_OVER, mouseOverIcon);
					iconHolder.addEventListener(MouseEvent.MOUSE_OUT, mouseOutIcon);
				}
					
				//if the bounding box is holding an EditableTextTeam instance, it can
				//not be modified, so hide the transform icons
				iconHolder.visible = !(editableDesign is EditableTextTeam);
			}
			
			//add actions to the transformation icons
			scaleIcon.addEventListener(MouseEvent.MOUSE_DOWN, resize);
			rotateIcon.addEventListener(MouseEvent.MOUSE_DOWN, rotate);
			translateIcon.addEventListener(MouseEvent.MOUSE_DOWN, translate);
			removeIcon.addEventListener(MouseEvent.MOUSE_DOWN, remove );
			
			//hide warning icon. It's shown when the editable item is outside
			//its valid design area
			warningIcon.visible = false;
			
			drawRect();
		}
		
		
		
		//
		protected function drawRect(rect:Rectangle = null):void 
		{
			if(rect == null)
			{
				rect = (editableDesign as EditableBase).getBounds(this);
			}

			if(marchingAntsRect && contains(marchingAntsRect))
			{
				marchingAntsRect.clear();
				removeChild(marchingAntsRect);
				marchingAntsRect = null;
			}
			
			marchingAntsRect = new MarchingAntsSelectionRectangle();
			marchingAntsRect.rect = rect;
			addChild(marchingAntsRect);
			setChildIndex(marchingAntsRect, 0);
			
			//if the bounding box is holding an EditableTextTeam instance, it can
			//not be modified, so hide the bounding box
			marchingAntsRect.visible = !(editableDesign is EditableTextTeam);
			
			layoutIcons();
		}
		
		
		
		//
		protected function layoutIcons():void
		{
			removeIcon.x = marchingAntsRect.rect.x;
			removeIcon.y = marchingAntsRect.rect.y;
			rotateIcon.x = marchingAntsRect.rect.x + marchingAntsRect.rect.width;
			rotateIcon.y = marchingAntsRect.rect.y;
			translateIcon.x = marchingAntsRect.rect.x;
			translateIcon.y = marchingAntsRect.rect.y + marchingAntsRect.rect.height;
			scaleIcon.x = marchingAntsRect.rect.x + marchingAntsRect.rect.width;
			scaleIcon.y = marchingAntsRect.rect.y + marchingAntsRect.rect.height;
			warningIcon.x = marchingAntsRect.rect.x + marchingAntsRect.rect.width/2;
			warningIcon.y = marchingAntsRect.rect.y;
		}
		
		
		
		//
		protected function reset( e:MouseEvent = null ):void 
		{
			if ( !marchingAntsRect || !editableDesign) 
				return;
			
			drawRect(marchingAntsRect.rect);
			if(drag) 
				drag.exit();
		}
		
		
		
		//
		protected function mouseOverIcon(e:MouseEvent):void
		{	
			if(activeIcon != e.target)
			{
				setIconState(e.target as Sprite, ICON_ACTIVE_STATE);
			}
		}
		
		
		
		//
		protected function setIconState(icon:Sprite, activeState:Boolean):void
		{
			destroyToolTip();
			
			if(activeState)
			{
				icon.getChildAt(1).visible = false;			
				icon.getChildAt(0).visible = true;
				
				switch(icon)
				{
					case scaleIcon:
						toolTip = ToolTipManager.createToolTip(ResourceManager.getInstance().getString('Bundles', 'TRANSFORM.SCALE'), stage.mouseX + 10, stage.mouseY - 10);	
						break;
					case rotateIcon:
						toolTip = ToolTipManager.createToolTip(ResourceManager.getInstance().getString('Bundles', 'TRANSFORM.ROTATE'), stage.mouseX + 10, stage.mouseY - 10);	
						break;
					case removeIcon:
						toolTip = ToolTipManager.createToolTip(ResourceManager.getInstance().getString('Bundles', 'TRANSFORM.REMOVE'), stage.mouseX + 10, stage.mouseY - 10);	
						break;
					case translateIcon:
						toolTip = ToolTipManager.createToolTip(ResourceManager.getInstance().getString('Bundles', 'TRANSFORM.TRANSLATE'), stage.mouseX + 10, stage.mouseY - 10);	
						break;
				}
			}
			else
			{
				icon.getChildAt(1).visible = true;
				icon.getChildAt(0).visible = false;
			}
		}
		
		
		
		//
		protected function mouseOutIcon(e:MouseEvent):void
		{
			if(activeIcon != e.target)
			{
				setIconState(e.target as Sprite, ICON_INACTIVE_STATE);
			}
		}
		
		
		
		//
		protected function destroyToolTip():void
		{
			if(toolTip)
			{
				ToolTipManager.destroyToolTip(toolTip);
				toolTip = null;
			}
		}
		
		
		
		//Updates the over state of the icon after the user has applied a transformation.
		//After the transform, the mouse can be over the active icon or outside. If the
		//mouse is still over the active icon, apply the mouseOver state and reset the
		//activeIcon reference (the activeIcon is set in the next mouseDown event over an icon)
		protected function resetActiveIcon():void
		{
			var state:Boolean = (activeIcon.hitTestPoint(stage.mouseX, stage.mouseY) == true)?	ICON_ACTIVE_STATE:ICON_INACTIVE_STATE; 
			setIconState(activeIcon, state);
			fadeInactiveIcons(Constants.FADE_IN);
			activeIcon = null;
		}
		
		
		
		//
		protected function updateActiveIcon(event:MouseEvent):void
		{
			//stop the event so the ProductDesigner view does not process this event
			event.stopImmediatePropagation();
			activeIcon = event.target as Sprite;
			destroyToolTip();
			
			//hide all the iconse except the clicked one and the warning icon
			fadeInactiveIcons(Constants.FADE_OUT);
		}
		
		
		
		//
		protected function fadeInactiveIcons(fadeType:int):void
		{
			for each(var icon:Sprite in icons)
			{
				if(icon != activeIcon && icon != warningIcon)
				{
					TweenLite.to(icon, (fadeType == Constants.FADE_IN)?	0.25:0.1, {alpha:(fadeType == Constants.FADE_IN)? 1:0});
				}
			}
		}
		
		
		
		/**************************************************************************************
		 * EVENTS
		 *************************************************************************************/
		
		
		
		//
		protected function resize(event:MouseEvent ):void 
		{
			updateActiveIcon(event);
			
			//make the scale icon draggale, listen for the move and up mouse events
			//to scale and stop scaling the design
			new RemovableDragItem(scaleIcon);
			
			//get the current scale. If the new scaling is too big or too little
			//then reset the scale
			initialScale = new Point(editableDesign.content.scaleX, editableDesign.content.scaleY);
			scaleIcon.stage.addEventListener( MouseEvent.MOUSE_MOVE, resizeRect );
			scaleIcon.stage.addEventListener( MouseEvent.MOUSE_UP, resizeFinish );
		}
		
		
		
		//
		protected function resizeRect( e:MouseEvent ):void 
		{
			//get the rectange of the current bounding box.
			var newRect:Rectangle = marchingAntsRect.rect.clone();
			
			//the new height and width always in absolute values. If not, the
			//design is scaled with negative values (reflection of the design)
			newRect.width = Math.abs(scaleIcon.x - newRect.x);
			newRect.height = Math.abs(scaleIcon.y - newRect.y);

			//uniform scaling
			newRect.height = marchingAntsRect.rect.height * ( newRect.width / marchingAntsRect.rect.width );
			
			//scale the design by the increment. For texts the content is not scaled, but the 
			//font size and the text container is changed
			editableDesign.resizeBy( newRect.size.x / marchingAntsRect.rect.size.x, newRect.size.y / marchingAntsRect.rect.size.y  );
			drawRect();
			
			//notify that the editable item is changing its properties
			dispatcher(new ProductMessage(ProductMessage.EDITABLE_ITEM_CHANGING));
		}
		
		
		//
		protected function resizeFinish( e:MouseEvent ):void 
		{
			resetActiveIcon();
			
			e.currentTarget.removeEventListener( MouseEvent.MOUSE_MOVE, resizeRect );
			e.currentTarget.removeEventListener( MouseEvent.MOUSE_UP, resizeFinish );
			
			if( (editableDesign as EditableBase).getBounds(this).width < MIN_SIZE || 
				(editableDesign as EditableBase).getBounds(this).width > MAX_SIZE)
			{
				editableDesign.resizeTo(initialScale.x, initialScale.y);
				drawRect();
			}
			reset();
			
			//notify the end of the transformation for texts
			var message:ProductMessage = new ProductMessage(ProductMessage.EDITABLE_ITEM_TRANSFORMED);
			message.transformation = Constants.RESIZE;
			dispatcher(message);
		}
	
		
		//
		protected function rotate( event:MouseEvent ):void 
		{
			updateActiveIcon(event);
			
			var bounds:Rectangle = this.marchingAntsRect.getBounds( this.parent );
			//get the initial point before start rotation, so when moving the mouse
			//the angle can be calculated from this initial point
			rotatePoint = new Point( bounds.x + bounds.width / 2 , bounds.y + bounds.height / 2 );

			//listen for the move and up mouse events to rotate and stop rotating the design
			rotateIcon.stage.addEventListener( MouseEvent.MOUSE_MOVE, rotateItem );
			rotateIcon.stage.addEventListener( MouseEvent.MOUSE_UP, rotateFinish );
		}
		
		
		
		//
		protected function rotateItem( e:MouseEvent ):void 
		{
			//get angle between the current mouse position and the initial point
			var angle:Number = Math.atan2(this.parent.mouseY - rotatePoint.y, this.parent.mouseX - rotatePoint.x );
			var iconAngle:Number = Math.atan2(rotateIcon.y - rotatePoint.y, rotateIcon.x - rotatePoint.x );
			angle -= iconAngle;
			var degrees:Number = MathUtil.radian2angle(angle);

			//rotate this bounding box
			if(isNaN(currentDegrees))
			{
				currentDegrees = degrees;
			}
			
			this.rotation += degrees - currentDegrees;
			
			//rotate the icons of the bounding box in the reverse directions, 
			//so they always keep equal
			for each(var icon:Sprite in icons)
				icon.rotation -= degrees - currentDegrees;
			
			editableDesign.rotateBy(degrees - currentDegrees);
			
			//update current degrees
			currentDegrees = degrees;
			
			//notify that the editable item is changing its properties
			dispatcher(new ProductMessage(ProductMessage.EDITABLE_ITEM_CHANGING));
		}
		
		
		
		//
		protected function rotateFinish( e:MouseEvent ):void 
		{
			resetActiveIcon();			
			
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, rotateItem );
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, rotateFinish );
			reset();
			
			//notify the end of the transformation for texts
			var message:ProductMessage = new ProductMessage(ProductMessage.EDITABLE_ITEM_TRANSFORMED);
			message.transformation = Constants.ROTATION;
			dispatcher(message);
		}
		
		
		
		//
		protected function translate(event:MouseEvent):void 
		{
			updateActiveIcon(event);
			
			//make the translate icon draggale, listen for the move and up mouse events
			//to scale and stop scaling the design
			new RemovableDragItem(translateIcon);
			
			//NOTE: when translating, we want mouse coordinates without any rotation,
			//so take always the coords of the stage, so in case the item is rotated
			//we always have values of the mouse without any rotation applied to them
			translationPoint = new Point(stage.mouseX, stage.mouseY);
			translationInitPosition = new Point((editableDesign as EditableBase).x, (editableDesign as EditableBase).y);
			translationInitBoundingBoxPosition = new Point(x,y);
			translateIcon.stage.addEventListener( MouseEvent.MOUSE_MOVE, translateRect );
			translateIcon.stage.addEventListener( MouseEvent.MOUSE_UP, translateFinish );
		}
		
		
		
		//
		protected function translateRect(e:MouseEvent):void 
		{
			//NOTE: when translating, we want mouse coordinates without any rotation,
			//so take always the coords of the stage, so in case the item is rotated
			//we always have values of the mouse without any rotation applied to them
			editableDesign.translate(stage.mouseX - translationPoint.x, stage.mouseY - translationPoint.y);

			this.x += stage.mouseX - translationPoint.x;
			this.y += stage.mouseY - translationPoint.y;
			
			translationPoint = new Point(stage.mouseX, stage.mouseY);			

			//notify that the editable item is changing its properties
			dispatcher(new ProductMessage(ProductMessage.EDITABLE_ITEM_CHANGING));
		}
		
		
		
		//
		protected function translateFinish( e:MouseEvent ):void 
		{
			resetActiveIcon();
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, translateRect );
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, translateFinish );
			
			//notify the end of the transformation for texts
			var message:ProductMessage = new ProductMessage(ProductMessage.EDITABLE_ITEM_TRANSFORMED);
			message.transformation = Constants.TRANSLATION;
			dispatcher(message);
		}
		

		
		//
		protected function remove(event:MouseEvent):void
		{
			//stop the event so the ProductDesigner view does not process this event
			event.stopImmediatePropagation();
			
			//bounding box is added to the parsley context, so it can be dispatch messages
			removeIcon.removeEventListener(MouseEvent.MOUSE_DOWN, remove);
			dispatcher( new ProductMessage(ProductMessage.REMOVE_DESIGN));
		}
	}
}