package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.domain.ViewDomain;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.presentation.product.designer.EditableBase;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.presentation.product.designer.EditableTextBase;
	import com.bykoko.presentation.product.designer.EditableTextTeam;
	import com.bykoko.presentation.product.designer.IEditable;
	import com.bykoko.util.StringUtil;
	import com.bykoko.vo.SizeReferenceRendererData;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.order.Order;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.order.ProductDisplay;
	
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class SendOrderCommand extends BaseCommand
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		[Bindable]
		public var viewDomain:ViewDomain;

		//order to be sent to the service
		protected var order:Order
		
		[MessageDispatcher]
		public var dispatcher:Function;


		
		/**************************************************************************************
		 * PUBLIC METHDOS
		 *************************************************************************************/
		
		
		
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);
			return service.sendOrder(appDomain.config.url_post, 
									appDomain.config.id_pedido, 
									appDomain.orderTimeStamp,
									appDomain.profile,
									getProductDataXML()); 
		}


		
		override public function result(data:Object):void
		{
			//clear the id of the sent order
			appDomain.clearOrderTimeStamp();
			
			//send message so models / views can be updated
			dispatcher(new ProductMessage(ProductMessage.ORDER_SENT));
			
			super.result(data);
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHDOS
		 *************************************************************************************/
		
		
		
		private function getProductDataXML():XML
		{
			//create a new empty order
			order = new Order();
			
			//populate order's data
			if(viewDomain.isTeamsView)
			{
				createTeamOrder();
			}
			else
			{
				//check if the order is single size or multi-size
				if( (appDomain.profile == Constants.PROFILE_ANONYMOUS || appDomain.profile == Constants.PROFILE_BIG_ACCOUNT) && 
					appDomain.config.modulo_multitallas == Constants.SHOW)
				{
					createMultiSizeOrder();
				}	
				else
				{
					createSingleSizeOrder();
				}
			}
			
			//map the object to its xml representation
			mapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Order).
				mappedClasses(Order, Product, ProductDisplay, EditableItem).build();
			
			return mapper.mapToXml(order);
		}
		
		
		
		//
		protected function createTeamOrder():void
		{
			var product:Product;
			var productDisplay:ProductDisplay;
			var editableItem:EditableItem;
			
			//loop through all the product displays
			for each(var productDisplayId:String in appDomain.productDisplays)
			{
				//if the product has the display, add it to the order
				if(appDomain.selectedProduct.posiciones[productDisplayId])
				{
					//we will create as many products as players have been introduced in the team order
					//In each product, add the text for each player
					for (var i:uint = 0; i<appDomain.getEditableDesignsForProductDisplay(productDisplayId).length; i++)
					{
						var iEditable:IEditable = appDomain.getEditableDesignsForProductDisplay(productDisplayId).getItemAt(i) as IEditable;
							
						//add the selected product, indicating id, reference, price (quantity is 1 by default)
						product = new Product();
						product.productId = appDomain.selectedProduct.id;
						product.pvp = appDomain.selectedProduct.pvp;
						product.colorId = appDomain.selectedColorProduct.id.toString();
						product.sizeRef = (iEditable as EditableTextTeam).teamProductItemData.talla.ref;
						product.unitPrice = appDomain.getPrice(Constants.TAX_WITHOUT);
						product.quantity = 1;
						product.finalPrice = product.unitPrice * product.quantity;
						
						productDisplay = new ProductDisplay();
						productDisplay.position = productDisplayId;
						productDisplay.price = appDomain.getProductDisplayPrice(productDisplayId, Constants.TAX_WITHOUT);
						
						//get the snapshot image. For a Team order, all the snapshots are from the back product display so
						//there is no need to search by ProductDisplay.
						productDisplay.snapShot = appDomain.productDisplaysSnapshots[i].base64StringImage;
						
						//save the id of the asset being used, also the transformations
						editableItem = new EditableItem();
						editableItem.setItem(iEditable as EditableBase);
						
						//save the text (as svg). The TLF version is not needed here (the
						//configuration for a team text are not reproducible later)
						editableItem.svg = (iEditable as EditableTextBase).exportSVG();
						editableItem.tlf = "";
						
						//add the item to the product display
						productDisplay.editableItems.push(editableItem);
						
						//add the product display to the product
						product.productDisplays.push(productDisplay);
						
						//add the product to the order
						order.products.push(product);
					}
				}
			}
		}
		
		
		
		//
		protected function createSingleSizeOrder():void
		{
			var product:Product;
			var productDisplay:ProductDisplay;
			var editableItem:EditableItem;
			
			//add the selected product, indicating id, reference, price and quantity
			product = new Product();
			product.productId = appDomain.selectedProduct.id;
			product.pvp = appDomain.selectedProduct.pvp;
			product.colorId = appDomain.selectedColorProduct.id.toString(); 
			product.sizeRef = appDomain.selectedSizeProduct.ref;
			
			//when sending the order, the unit price is the price for 1 unit, without taxes.
			//the final price, is price for all the units without taxes
			product.unitPrice = appDomain.getPrice(Constants.TAX_WITHOUT, Constants.PRICE_UNITARY);
			product.quantity = appDomain.quantityProduct;
			product.finalPrice = product.unitPrice * product.quantity;
			
			//loop through all the product displays of the selected product
			for each(var productDisplayId:String in appDomain.productDisplays)
			{
				//if the product has the display, add it to the order
				if(appDomain.selectedProduct.posiciones[productDisplayId])
				{
					productDisplay = new ProductDisplay();
					productDisplay.position = productDisplayId;
					productDisplay.price = appDomain.getProductDisplayPrice(productDisplayId, Constants.TAX_WITHOUT);
					
					//get the snapshot image based on the product display
					productDisplay.snapShot = appDomain.getProductDisplaysSnapshotsByProductDisplayId(productDisplayId);
					
					//for this product display, look for the items used on it
					for each(var iEditable:IEditable in appDomain.getEditableDesignsForProductDisplay(productDisplayId))
					{
						//save the id of the asset being used, also the transformations
						editableItem = new EditableItem();
						editableItem.setItem(iEditable as EditableBase);
						
						//save the text (as tlf) if the element is an EditableText
						editableItem.tlf = (iEditable is EditableText)? (iEditable as EditableText).exportTextLayoutFormat():"";
						
						//save the text (as svg) if the element is an EditableText
						editableItem.svg = (iEditable is EditableText)? (iEditable as EditableText).exportSVG():"";
						
						//add the item to the product display
						productDisplay.editableItems.push(editableItem);
					}
					
					//add the product display to the order
					product.productDisplays.push(productDisplay);
				}
			}
			
			//add the product to the order
			order.products.push(product);
		}
		
		
		
		//
		protected function createMultiSizeOrder():void
		{
			createSingleSizeOrder();
			
			//get the product of the order and clone it to create so many products as sizes has been choosen
			var product:Product = order.products[0] as Product;
			order = new Order();
			
			var clonedProduct:Product;
			for each(var sizeReferenceRendererData:SizeReferenceRendererData in appDomain.multiSizeOrderData)
			{
				//send only those selections from the multisize selector that have an amount > 0
				if(sizeReferenceRendererData.amount > 0)
				{
					clonedProduct = product.clone();

					//get the internal reference introduced by the user 
					clonedProduct.sizeRefInternal = sizeReferenceRendererData.reference;
					
					//get the quantity and recalculate the price
					clonedProduct.quantity = sizeReferenceRendererData.amount;
					clonedProduct.finalPrice = clonedProduct.unitPrice * clonedProduct.quantity;
					
					//get the reference of the selected size
					clonedProduct.sizeRef = sizeReferenceRendererData.sizeReference;
					
					order.products.push(clonedProduct);
				}
			}
		}
	}
}