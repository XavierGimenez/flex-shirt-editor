package com.bykoko.presentation.product.designer
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.core.SpriteVisualElement;

	public interface IEditable
	{
		function resizeBy(scaleX:Number, scaleY:Number):void;
		function resizeTo(scaleX:Number, scaleY:Number):void;
		function rotate(angle:Number):void;
		function rotateTo(angle:Number):void;
		function rotateBy(degrees:Number):void;
		function translate(offsetX:Number, offsetY:Number):void;
		function get content():SpriteVisualElement;
		function set content(value:SpriteVisualElement):void;
		function get positionForSVG():Point;
		function get size():Rectangle;
	}
}