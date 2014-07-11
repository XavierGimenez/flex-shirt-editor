package com.bykoko.util
{
	import com.bykoko.vo.ProductDisplayInfo;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	import com.bykoko.vo.xmlmapping.product.Color;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;

	public final class VOUtil
	{
		public static const POSITION_FRONT:String = "front";
		public static const POSITION_BACK:String = "back";
		public static const POSITION_RIGHT:String = "right";
		public static const POSITION_LEFT:String = "left";
		public static const PRODUCT_DISPLAYS:Array = [POSITION_FRONT, POSITION_RIGHT, POSITION_BACK, POSITION_LEFT];
		public static const IMAGE_THUMBNAIL_PREFIX:String = "th_";
		public static const IMAGE_SQUARE_PREFIX:String = "sc_";


		
		//returns the default image URL for a product. Returns the front image 
		//from the first available color of the product
		public static function getDefaultImageURLFromProduct(product:Articulo, imageTypePrefix:String = ""):String
		{
			if(product.colores)
			{
				var color:Color = product.colores.colores[0] as Color;
				return( color.path + POSITION_FRONT + "/" + imageTypePrefix + color.front);
			}
			return null;
		}
		
		
		//returns the URL of an images, based on the color and the display
		public static function getProductImageURLFromColorAndDisplay(color:Color, display:String, imageTypePrefix:String = ""):String
		{
			if(display == POSITION_FRONT)
				return String(color.path + VOUtil.POSITION_FRONT + "/" + imageTypePrefix + color.front);
			else if(display == POSITION_RIGHT)
				return String(color.path + VOUtil.POSITION_RIGHT+ "/" + imageTypePrefix + color.right);
			else if(display == POSITION_BACK)
				return String(color.path + VOUtil.POSITION_BACK + "/" + imageTypePrefix + color.back);
			else 
				return String(color.path + VOUtil.POSITION_LEFT + "/" + imageTypePrefix + color.left);			
		}
		
		
		
		//
		public static function hasProductMultipleDisplays(product:Articulo):Boolean
		{
			var counter:int = 0;
			
			if(product.posiciones.front)
				counter++;
			if(product.posiciones.right)
				counter++;
			if(product.posiciones.back)
				counter++;
			if(product.posiciones.left)
				counter++;
			
			return (counter > 1);
		}
		
		
		
		//
		public static function getProductDisplaysInfo(product:Articulo, color:Color):ArrayCollection
		{
			var productDisplayInfo:ProductDisplayInfo;
			var productDisplaysInfo:ArrayCollection = new ArrayCollection();

			if(product.posiciones.front)
			{
				productDisplayInfo = new ProductDisplayInfo();
				productDisplayInfo.id = POSITION_FRONT;
				productDisplayInfo.position = product.posiciones.front;
				productDisplayInfo.imageURL = getProductImageURLFromColorAndDisplay(color, POSITION_FRONT, IMAGE_SQUARE_PREFIX);
				productDisplaysInfo.addItem(productDisplayInfo);
			}
			if(product.posiciones.right)
			{
				productDisplayInfo = new ProductDisplayInfo();
				productDisplayInfo.id = POSITION_RIGHT;
				productDisplayInfo.position = product.posiciones.right;
				productDisplayInfo.imageURL = getProductImageURLFromColorAndDisplay(color, POSITION_RIGHT, IMAGE_SQUARE_PREFIX);
				productDisplaysInfo.addItem(productDisplayInfo);
			}
			if(product.posiciones.back)
			{
				productDisplayInfo = new ProductDisplayInfo();
				productDisplayInfo.id = POSITION_BACK;
				productDisplayInfo.position = product.posiciones.back;
				productDisplayInfo.imageURL = getProductImageURLFromColorAndDisplay(color, POSITION_BACK, IMAGE_SQUARE_PREFIX);
				productDisplaysInfo.addItem(productDisplayInfo);
			}
			if(product.posiciones.left)
			{
				productDisplayInfo = new ProductDisplayInfo();
				productDisplayInfo.id = POSITION_LEFT;
				productDisplayInfo.position = product.posiciones.left;
				productDisplayInfo.imageURL = getProductImageURLFromColorAndDisplay(color, POSITION_LEFT, IMAGE_SQUARE_PREFIX);
				productDisplaysInfo.addItem(productDisplayInfo);
			}
			
			return productDisplaysInfo;
		}
		
		
		
		//
		public static function getRectangleFromPosition(position:Posicion):Rectangle
		{
			return new Rectangle(position.x1, position.y1, position.x2 - position.x1, position.y2 - position.y1);
		}
	}
}