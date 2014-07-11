package com.bykoko.util
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import spark.core.SpriteVisualElement;

	public class SpriteVisualElementUtil
	{
		public static function removeChildren(spriteVisualElement:SpriteVisualElement):void
		{
			while(spriteVisualElement.numChildren > 0)
			{
				spriteVisualElement.removeChildAt(0);
			}
		}
		
		
		
		public static function matchSize(t:SpriteVisualElement, p:Sprite, fitWithin:Boolean = false, placeIn:Boolean = false, noHorizontal:String = "center", noVertical:String = "center", margin:uint = 0):void 
		{
			//get the boundaries of t and p relative to the coordinatesystem of the parent of t
			//since in this system the final size is being set
			var tB:Rectangle  = t.getBounds(t.parent);
			var pB:Rectangle  = p.getBounds(t.parent);
			
			//take the dimensions of t
			var tW:Number = tB.width + margin;
			var tH:Number = tB.height + margin;
			
			//take the dimensions of theParent
			var pW:Number = pB.width;
			var pH:Number = pB.height;
			
			//determine the scale factor
			var f:Number;
			
			//if t should fit within p
			if (fitWithin)
				f = Math.min(pW/tW, pH/tH);
			else
				f = Math.max(pW/tW, pH/tH);
			
			//Set the size
			t.scaleX  *= f;
			t.scaleY *= f;
			
			if(placeIn)
				placeWithin(t, p, noHorizontal, noVertical);
		}
		
		public static function placeWithin(t:Sprite, p:Sprite, horizontal:String = "center", vertical:String = "center"):void 
		{
			var tB:Rectangle = t.getBounds(t.parent);
			var pB:Rectangle = p.getBounds(t.parent);
			
			//take the dimensions of p
			var pW:Number = pB.width;
			var pH:Number = pB.height;
			
			var xOff:Number = (t.x - tB.x);
			var yOff:Number = (t.y - tB.y);
			
			var xMod:Number, yMod:Number;
			
			//Setting the position horizontally
			if (horizontal == "center") 
			{
				//centering
				xMod = pB.x + 0.5*(pW - (tB.width)) + xOff;
			} else if (horizontal == "left") {
				//left side
				xMod = pB.x + (t.x - tB.x);
			} else if (horizontal == "right") {
				//right side
				xMod = pB.x + pW - (tB.width);
			}
			//Setting the position vertically
			if (vertical == "center") 
			{
				//centering
				yMod = pB.y + (pH - tB.height)/2 + yOff;
			} else if (vertical == "top") {
				//at the top
				yMod = pB.y + (t.y - tB.y);
			} else if (vertical == "bottom") {
				//at the bottom
				yMod = pB.y + pH - (tB.height);
			}
			
			t.x = xMod;
			t.y = yMod;
		}
	}
}