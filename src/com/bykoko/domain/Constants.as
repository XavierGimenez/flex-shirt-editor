package com.bykoko.domain
{
	public final class Constants
	{
		public static var url_config:String;	//via flashvars
		public static var url_redirect:String;	//via flashvars
		public static var userURLFolder:String = "uploads/usuarios/";
		public static var userURLLibrary:String = "libreria/";

		public static const PROFILE_ANONYMOUS:int = 1;
		public static const PROFILE_USER_WITH_DESIGN:int = 2;
		public static const PROFILE_PRODUCT_MODIFIED_BY_OWNER:int = 3;
		public static const PROFILE_USER_CORNER:int = 4;
		public static const PROFILE_EXTERNAL_PROVIDER:int = 5;
		
		//when the owner of a product modifies it
		public static const PROFILE_BIG_ACCOUNT:int = 6;
		
		//when a user modifies a product that does not belong to him
		public static const PROFILE_PRODUCT_MODIFIED_BY_ANONYMOUS:int = 7;

		//ui configuration based on the client's type
		public static const UI_CONFIG_DEFAULT:int = 0;
		public static const UI_CONFIG_BIG_ACCOUNT:int = 1;

		public static const FORWARD:int = 1;
		public static const BACKWARD:int = -1;
		public static const NO_ID:int = -1;
		public static const CDATA_INIT:String = "<![CDATA[";
		public static const CDATA_END:String = "]]>";
		
		public static const SVG_ATTRIBUTE_ROTATE:String = "rotate";
		public static const SVG_ATTRIBUTE_TRANSLATE:String = "translate";
		public static const SVG_ATTRIBUTE_OPENING:String = "(";
		public static const SVG_ATTRIBUTE_ENCLOSING:String = ")";
		public static const SVG_SEPARATOR_VALUE:String = ",";
		public static const SVG_ANCHOR_START:String = "start";
		public static const SVG_ANCHOR_MIDDLE:String = "middle";
		public static const SVG_ANCHOR_END:String = "end";
		public static const SVG_PROPERTY_NORMAL:String = "normal";
		
		
		
		public static const ERROR_UPLOAD_FILE:String = "0";
		public static const MAX_UPLOADED_FILES:int = 10;
		
		//type of transformations applied to an IEditable object
		public static const TRANSLATION:int = 1;
		public static const ROTATION:int = 2;
		public static const RESIZE:int = 3;
		
		//default id of the bykoko catalogue
		public static const CATALOGUE_ID_BYKOKO:int = 0;
		
		public static const FADE_IN:int = 1;
		public static const FADE_OUT:int = 0;
		public static const ALPHA_DESIGN_AREA:Number = 0.7;
		
		public static const SHOW:int = 1;
		public static const HIDE:int = 0;
		
		public static const PRICE_UNITARY:int = 1;
		public static const PRICE_ALL_UNITS:int = 2;
		
		public static const TAX_WITH:int = 1;
		public static const TAX_WITHOUT:int = 2;
		
		public static const tempOrder:XML = <order>
  <product quantity="1" color-id="267" product-id="61" unit-price="30" size-ref="1006100900" pvp="20" final-price="30">
    <product-display price="10" position="front">
      <editable-item x="4" y="77" tip="txt" royalty="0" width="150" height="30" id="-1">
        <svg><text>
  <tspan font-family="arial" y="90" font-weight="bold" fill="#00cc00" x="15" font-size="14" font-style="normal"><![CDATA[Tu diseño empieza ]]></tspan>
  <tspan font-family="arial" y="106" font-weight="bold" fill="#00cc00" x="63" font-size="14" font-style="normal"><![CDATA[aquí]]></tspan>
</text></svg>
        <tlf><![CDATA[<TextFlow color="#00cc00" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">
  <p color="#00cc00" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center">
    <span color="#00cc00" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center">Tu diseño empieza aquí</span>
  </p>
</TextFlow>]]></tlf>
      </editable-item>
      <editable-item x="4" y="167" tip="txt" royalty="0" width="150" height="13.2" id="-1">
        <svg><text>
  <tspan font-family="arial" y="180" font-weight="bold" fill="#990000" x="29" font-size="14" font-style="normal"><![CDATA[y acaba aquí...]]></tspan>
</text></svg>
        <tlf><![CDATA[<TextFlow color="#990000" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center" whiteSpaceCollapse="preserve" xmlns="http://ns.adobe.com/textLayout/2008">
  <p color="#990000" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center">
    <span color="#990000" fontFamily="arial" fontSize="14" fontStyle="normal" fontWeight="bold" textAlign="center">y acaba aquí...</span>
  </p>
</TextFlow>]]></tlf>
      </editable-item>
    </product-display>
    <product-display price="0" position="back"/>
  </product>
</order>;
	}
}