package com.bykoko.infrastructure.message
{
	import com.bykoko.presentation.product.designer.EditableTextTeam;
	import com.bykoko.vo.TeamProductItemData;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	
	import flash.display.Bitmap;
	
	import flashx.textLayout.formats.TextLayoutFormat;

	public class ProductMessage extends MessageBase
	{
		public static const PRODUCT_SELECTED:String = "productSelected";
		public static const CHANGE_PRODUCT_DISPLAY:String = "changeProductDisplay";
		public static const CHANGE_PRODUCT_COLOR:String = "changeProductColor";
		public static const CHANGE_PRODUCT_SIZE:String = "changeProductSize";
		public static const DESIGN_SELECTED:String = "designSelected";
		public static const REMOVE_DESIGN:String = "removeDesign";
		public static const REMOVE_ALL_DESIGNS:String = "removeAllDesigns";
		public static const DESIGN_REMOVED:String = "designRemoved";
		public static const ALL_DESIGNS_REMOVED:String = "allDesignsRemoved";
		public static const IMAGE_LOADED:String = "imageLoaded";
		public static const INSERT_TEXT:String = "insertText";
		public static const EDITABLE_TEXT_SELECTED:String = "editableTextSelected";
		public static const EDITABLE_DESIGN_SELECTED:String = "editableDesignSelected";
		public static const INSERT_TEXT_TEAM:String = "insertTextTeam";
		public static const SHOW_TEXT_TEAM:String = "showTextTeam";
		public static const REMOVE_TEXT_TEAM:String = "removeTextTeam";
		public static const INSERT_EDITABLE_ITEM:String = "insertEditableItem";
		
		//notification that an editable item is being translated, scaled or rotated
		public static const EDITABLE_ITEM_CHANGING:String = "editableItemChanging";
		
		//notification that an editable item has been transtated, scaled or rotated
		public static const EDITABLE_ITEM_TRANSFORMED:String = "editableItemTransformed";
		
		public static const ORDER_SENT:String = "orderSent";
		
		//notification when the data of the product has to sent
//		public static const SEND_DATA:String = "sendData";
		
		//notification to recalculate the price of the product with its designs
		public static const UPDATE_PRICE:String = "updatePrice";
		
		public static const SELECT_PRODUCTS_OPTIONS:String = "selectProductsOption";
		
		
		//variables populated depending on the type of message
		
		//selected design from the designs panel
		public var design:Diseno;
		
		//color to applied to a selected design
		public var designColor:int;
		
		//image loaded by the user
		public var image:Bitmap;
		
		//filename of the image uploaded by the user
		public var imageFilename:String;
		
		//option for removing the background of an image
		public var imageRemoveBackground:int;
		
		//texts sent when the user is editing a team product
		public var teamProductItemData:TeamProductItemData;
		
		//Editable text team being edited
		public var editableTextTeam:EditableTextTeam;
		
		//textLayoutFormat with the current settings of the text edition panel
		public var textLayoutFormat:TextLayoutFormat;
		
		//editableItem coming from an order
		public var editableItem:EditableItem;

		//type of transformation applied to the editableItem
		public var transformation:int;
		

		
		public function ProductMessage(type:String = '', callbackFunction:Function = null, callbackParameters:Array = null, interceptable:Boolean = true)
		{
			super(type, callbackFunction, callbackParameters, interceptable);
		}
	}
}