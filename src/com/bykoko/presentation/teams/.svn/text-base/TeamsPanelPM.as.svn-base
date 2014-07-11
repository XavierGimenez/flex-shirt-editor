package com.bykoko.presentation.teams
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.product.designer.EditableTextTeam;
	import com.bykoko.vo.TeamProductItemData;
	import com.bykoko.vo.xmlmapping.config.Color;
	import com.bykoko.vo.xmlmapping.product.Talla;
	
	import mx.collections.ArrayCollection;

	public class TeamsPanelPM
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function updateTeamProducts(amount:Number, talla:Talla):void
		{
			//check if the amount of orders for the indicated size has increased or decreased
			if(amount > getAmountOrdersBySize(talla))
			{
				//add a new team product
				addTeamProduct(talla);
			}
			else
			{
				//remove the last team product belonging to this size
				removeTeamProduct(getLastProductBySize(talla));
			}
		}
		
		
		
		public function addTeamProduct(talla:Talla):void
		{
			//get info about the size
			var teamProductItemData:TeamProductItemData = new TeamProductItemData();
			teamProductItemData.talla = talla;
			
			//notify that a text has to be added
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.INSERT_TEXT_TEAM);
			productMessage.teamProductItemData = teamProductItemData;
			dispatcher(productMessage);			
		}
		
		
		
		public function removeTeamProduct(editableTextTeam:EditableTextTeam):void
		{
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.REMOVE_TEXT_TEAM);
			productMessage.editableTextTeam = editableTextTeam;
			dispatcher(productMessage);
		}
		
		
		
		//notify that a text is being modified, so has to be shown in the designer
		public function showText(editableTextTeam:EditableTextTeam):void
		{
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.SHOW_TEXT_TEAM);
			productMessage.editableTextTeam = editableTextTeam;
			dispatcher(productMessage);
		}
		
		
		
		//changes the color in all the team texts exisiting in the designer view
		public function setTextColor(color:int):void
		{
			for each(var editableTextTeam:EditableTextTeam in appDomain.editableDesigns)
			{
				editableTextTeam.updateColor(color);
			}			
		}
		
		
		
		//changes the font in all the team texts exisiting in the designer view
		public function setTextFont(fontName:String):void
		{
			for each(var editableTextTeam:EditableTextTeam in appDomain.editableDesigns)
			{
				editableTextTeam.updateFont(fontName);
			}	
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function getAmountOrdersBySize(talla:Talla):Number
		{
			var amount:Number = 0;
			for each(var editableTextTeam:EditableTextTeam in appDomain.editableDesigns)
			{
				if(editableTextTeam.teamProductItemData.talla == talla)
					amount++;
			}
			return amount;
		}
		
		
		
		//Returns the last inserted product that belong to an specific size
		private function getLastProductBySize(talla:Talla):EditableTextTeam
		{
			var editable:EditableTextTeam;
			var filterBySize:Function = function(editableTextTeam:EditableTextTeam):Boolean
			{
				return (editableTextTeam.teamProductItemData.talla == talla);
			}

			appDomain.editableDesigns.filterFunction = filterBySize;
			appDomain.editableDesigns.refresh();
			editable = appDomain.editableDesigns.getItemAt(appDomain.editableDesigns.length -1) as EditableTextTeam;
			appDomain.editableDesigns.filterFunction = null
			appDomain.editableDesigns.refresh();
			return editable;
		}
	}
}