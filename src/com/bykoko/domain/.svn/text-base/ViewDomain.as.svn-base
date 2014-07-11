package com.bykoko.domain
{
	[Bindable]
	public class ViewDomain
	{
		//navigation targets
		public static const SECTION_PRODUCT:int = 0;
		public static const SECTION_DESIGN:int = 1;
		public static const SECTION_TEXT:int = 2;
		public static const SECTION_PHOTO:int = 3;
		public static const SECTION_TEAMS:int = 4;

		//indexes for the viewstack of the panels
		public static const PANEL_PRODUCTS_BROWSER:int = 0;
		public static const PANEL_DESIGNS_BROWSER:int = 1;
		public static const PANEL_PHOTOS_BROWSER:int = 2;
		public static const PANEL_TEXT_BROWSER:int = 3;
		public var indexPanel:int;
		
		
		public function get isTeamsView():Boolean
		{
			return (indexPanel == SECTION_TEAMS);
		}
	}
}