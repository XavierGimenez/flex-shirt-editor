package com.bykoko.domain
{
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.product.designer.EditableBase;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.presentation.product.designer.EditableTextBase;
	import com.bykoko.presentation.product.designer.EditableTextTeam;
	import com.bykoko.presentation.product.designer.IEditable;
	import com.bykoko.presentation.product.options.ProductDisplaysBrowser;
	import com.bykoko.util.DictionaryUtil;
	import com.bykoko.util.VOUtil;
	import com.bykoko.vo.ProductDisplaySnapshot;
	import com.bykoko.vo.SizeReferenceRendererData;
	import com.bykoko.vo.order.Order;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.xmlmapping.config.Config;
	import com.bykoko.vo.xmlmapping.design.Categoria;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	import com.bykoko.vo.xmlmapping.product.Categoria;
	import com.bykoko.vo.xmlmapping.product.Color;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	import com.bykoko.vo.xmlmapping.product.Subcategoria;
	import com.bykoko.vo.xmlmapping.product.Talla;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.spicefactory.lib.task.TaskGroup;
	import org.spicefactory.parsley.core.state.GlobalState;
	

	[Bindable]
	public class AppDomain
	{
		public var URL_ROOT:String;
		public var URL_SERVICE:String;
		public var URL_SEND_ORDER:String;
		public var URL_FILE_UPLOAD:String;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		public var viewDomain:ViewDomain;
		
		//configuration for the application
		public var config:Config;
		
		//profile mode of the designer
		public var profile:int;
		
		//default design to load when the profile of the app is Constants.PROFILE_USER_WITH_DESIGN
		public var defaultDesignId:int;
		
		//id of the catalogue (set of assets of the client using the designer)
		public var catalogueId:int;
		
		//selected category, subcategory(if exists) and product
		public var selectedCategory : com.bykoko.vo.xmlmapping.product.Categoria;
		public var selectedSubcategory:Subcategoria;
		public var selectedProduct:Articulo;

		//selected color of selected product 
		private var _selectedColorProduct:Color;
		
		//selected size of selected product
		private var _selectedSizeProduct:Talla;

		//gives the current display of a product (front view, back view, left view and right view)
		private var _currentProductDisplay:String;
		
		//default product display is "front"
		private var currentProductDisplayIndex:int = 0; 
		public var productDisplays:Array = [VOUtil.POSITION_FRONT, VOUtil.POSITION_RIGHT, VOUtil.POSITION_BACK, VOUtil.POSITION_LEFT];
		
		//array of categories
		private var _categories:ArrayCollection;

		//array of Articulo instances, from the selected category/subcategory
		public var products:ArrayCollection;
		
		//array of design categories
		public var designsCategories:ArrayCollection;
		
		//select design category
		public var selectedDesignCategory : com.bykoko.vo.xmlmapping.design.Categoria
		
		//designs of the selected design category
		public var designs:ArrayCollection;
				
		//collection of dynamic objects being inserted to the context (editableItems being added to a product)
		public var dynamicObjects:Dictionary = new Dictionary();
		
		//designs of the current display selected product edited by the user
		private var _editableDesigns:ArrayCollection;
		
		//collection of design inserted into the selected product, each position
		//of the collection is a vector with the designs for an specific product display
		private var _allEditableDesigns:Dictionary;

		//Editable item being selected and modified by the user
		private var _editableItem:IEditable;

		public var quantityProduct:int = 1;

		//timestamp generated on every order 
		private var _orderTimeStamp:Number;
		
		//uploaded files
		private var _uploadedBitmaps:ArrayCollection;
		
		//order to be loaded when updating / modifying an existing order
		public var orderXML:XML;
		public var order:Order;
		public var orderFlashvars:String;
		public var orderBase64BA:ByteArray;
		
		//object that handles all the task to be done in the bootstrap process
		public var bootstrapTaskGroup:TaskGroup;
		
		//fonts used to design products
		private var _designFonts:ArrayCollection;
		
		//ui configuration based on the client's type
		public var UIConfig:int;

		//collection of SizeReferenceRendererData objects. Data to representent form that
		//appears when the UIconfig enables the selection of several size for a product
		public var multiSizeOrderData:ArrayCollection;
		
		//collection of snapshots (as base64 string) of the product displays
		public var productDisplaysSnapshots:Vector.<ProductDisplaySnapshot>;

		//collection of EditableItems that are from an existing order that is being recreated
		private var _editableItemsFromExistingOrder:Vector.<IEditable>;
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		

		//
		public function getCategoryById(id:int):com.bykoko.vo.xmlmapping.product.Categoria
		{
			var filterFunction:Function = function(item : com.bykoko.vo.xmlmapping.product.Categoria):Boolean
			{
				return (item.id == id);
			}
			_categories.filterFunction = filterFunction;
			_categories.refresh();
			
			var categoria:com.bykoko.vo.xmlmapping.product.Categoria = (_categories.length == 0)? null : _categories.getItemAt(0) as com.bykoko.vo.xmlmapping.product.Categoria; 
			_categories.filterFunction = null;
			_categories.refresh();
			return categoria;
		}

		
		//
		public function getSubcategoryById(categoria:com.bykoko.vo.xmlmapping.product.Categoria, id:int):Subcategoria
		{
			var filterFunction:Function = function(item : com.bykoko.vo.xmlmapping.product.Subcategoria):Boolean
			{
				return (item.id == id);
			}
			categoria.subcategories.filterFunction = filterFunction;
			categoria.subcategories.refresh();
			var subCategoria:Subcategoria = categoria.subcategories.getItemAt(0) as Subcategoria;
			categoria.subcategories.filterFunction = null;
			categoria.subcategories.refresh();
			return subCategoria;
		}

		
		
		//sets the selected product. Automatically select as default color the first color available
		//and the default size as the first size available for that product.
		public function selectProduct(articulo:Articulo):void
		{
			selectedProduct = articulo;
			
			//when a product is selected, show the first color by default. Set also 
			//the first size of the first color by default
			selectedColorProduct = selectedProduct.colores.colores[0] as Color;
			selectedSizeProduct = _selectedColorProduct.tallas.tallas[0] as Talla;

			//dispatch a message so the other views can display the default info of the product
			dispatcher( new ProductMessage(ProductMessage.PRODUCT_SELECTED));
			
			//update the product display with the first display available in the product 
			//or the 'back' displayed if the current section of the application is 'teams'
			setFirstAvailableProductDisplay();
			
			//call to the javascript function that changes the footer below the flex app
			ExternalInterface.call("getProductDescription", selectedProduct.id);
		}
		
		
		
		//
		public function getProductById(id:int):Articulo
		{
			var filterFunction:Function = function(item : Articulo):Boolean
			{
				return (item.id == id);
			}
			
			products.filterFunction = filterFunction;
			products.refresh();
			var articulo:Articulo = products.getItemAt(0) as Articulo; 
			products.filterFunction = null;
			products.refresh();
			return articulo;
		}
		
		
		
		//update the product display with the first display available in the product
		public function setFirstAvailableProductDisplay():void
		{
			currentProductDisplay = (viewDomain.indexPanel == ViewDomain.SECTION_TEAMS)? VOUtil.POSITION_BACK : defaultProductDisplay;
		}
		
		
		
		//look for the next product display. The available displays depend on the valid
		//values into Articulo.Posiciones. Posiciones is mapped from the xml service response
		//Not all the products have always all the 4 positions (front, back, left, right) available
		public function nextProductDisplay(direction:int):String
		{
			var indexLimit:int = (direction == Constants.FORWARD)?	productDisplays.length-1 : 0;
			var indexOpposite:int = (direction == Constants.FORWARD)?	0:productDisplays.length-1;
			
			//circular loop (forward or backward into the array ['front', 'right', 'back', 'left']. For every step
			//inspect the property (p.ex., Articulo.Posiciones['front']) looking for a valid value
			do
			{
				currentProductDisplayIndex = (currentProductDisplayIndex == indexLimit)?	indexOpposite : currentProductDisplayIndex + direction;
			}while(selectedProduct.posiciones[productDisplays[currentProductDisplayIndex]] == null);
			
			currentProductDisplay = productDisplays[currentProductDisplayIndex];
			return currentProductDisplay;
		}

		
		
		//
		public function addEditableDesign(editableItem:IEditable):void
		{
			editableDesigns.addItem(editableItem);
			
			//add it to the context so it can send parsley messages. Save the dynamic
			//object so it can be deleted later from the context
			dynamicObjects[editableItem] = GlobalState.objects.getContext(this).addDynamicObject(editableItem);
		}
		
		
		
		//
		public function removeEditableDesign(editableDesign:IEditable):void
		{
			editableDesigns.removeItemAt(editableDesigns.getItemIndex(editableDesign));
			dispatcher(new ProductMessage(ProductMessage.DESIGN_REMOVED));
		}

		
		
		//
		public function resetEditableDesigns():void
		{
			//reset all the current editable items
			_allEditableDesigns = new Dictionary();
			
			//remove any posible selected editable item
			editableItem = null;
		}

		

		//
		public function get existsDesigns():Boolean
		{
			for each(var productDisplay:String in productDisplays)
			{
				if(allEditableDesigns[productDisplay] && (allEditableDesigns[productDisplay] as ArrayCollection).length > 0)
					return true;
			}
			return false;
		}
		
		
		
		//
		public function get selectedEditableItemIsText():Boolean
		{
			return (editableItem && editableItem is EditableTextBase);
		}
		
		
		
		public function clearOrderTimeStamp():void
		{
			_orderTimeStamp = NaN;
		}
		
		
		
		//
		public function resetMultiSizeOrderData():void
		{
			multiSizeOrderData = new ArrayCollection();
			for each(var talla:Talla in _selectedColorProduct.tallas.tallas)
			{
				multiSizeOrderData.addItem(new SizeReferenceRendererData(talla));
			}
		}
		
		
		
		/**************************************************************************************
		 * GETTER / SETTER
		 *************************************************************************************/
		
		
		

		public function get categories():ArrayCollection
		{
			if(_categories == null)
				_categories = new ArrayCollection();
			
			_categories.filterFunction = null;
			_categories.refresh();
			return _categories;
		}

		public function set categories(categorias:ArrayCollection):void
		{
			_categories = categorias;
		}

		


		public function set subcategories(subcategories:Array):void
		{
			//also place each subcategory into its category
			for each(var subcategory:Subcategoria in subcategories)
			{
				var category : com.bykoko.vo.xmlmapping.product.Categoria = getCategoryById(subcategory.cat);
				if(category)
				{
					category.subcategories.addItem(subcategory);
				}
			}
		}


		

		public function get currentProductDisplay():String
		{
			return _currentProductDisplay;
		}
		
		public function set currentProductDisplay(value:String):void
		{
			_currentProductDisplay = value;
			
			//update also the index of the product displays
			for(var i:int = 0; i<productDisplays.length; i++)
			{
				if(productDisplays[i] == value)
					currentProductDisplayIndex = i; 
			}
			
			dispatcher( new ProductMessage(ProductMessage.CHANGE_PRODUCT_DISPLAY));
		}
		
		

		
		public function get defaultProductDisplay():String
		{
			var defaultProductDisplay:String;
			
			for each(var productDisplay:String in productDisplays)
			{
				//evaluate the 'front', 'right', 'back' and 'left' properties
				//of the Articulo.posiciones attributes. The first property with
				//a value will be the current display
				if(selectedProduct.posiciones[productDisplay] != null)
				{
					defaultProductDisplay =  productDisplay;
					break;
				}
			}
			return defaultProductDisplay;
		}
		
			
			
		public function get editableDesigns():ArrayCollection
		{
			if(allEditableDesigns[currentProductDisplay] == null)
				allEditableDesigns[currentProductDisplay] = new ArrayCollection();
			
			return allEditableDesigns[currentProductDisplay] as ArrayCollection;			
		}
		
		public function set editableDesigns(value:ArrayCollection):void
		{
			_editableDesigns = value;
		}

		public function getEditableDesignsForProductDisplay(productDisplay:String):ArrayCollection
		{
			if(allEditableDesigns[productDisplay] != null)
				return allEditableDesigns[productDisplay] as ArrayCollection;
			else
				return new ArrayCollection();
		}
		
		public function removeEditableDesignsForProductDisplay(productDisplay:String):void
		{
			allEditableDesigns[productDisplay] = null;
		}
		
		public function addEditableItemOrderToProductDisplay(iEditable:IEditable, productDisplay:String):void
		{
			if(allEditableDesigns[productDisplay] == null)
				allEditableDesigns[productDisplay] = new ArrayCollection();
			
			if(profile == Constants.PROFILE_PRODUCT_MODIFIED_BY_OWNER)
			{
				//add the object to the context (p.e., texts need to send messages when its number of lines changes)
				_currentProductDisplay = productDisplay;
				addEditableDesign(iEditable);
			}
			else
			{
				//add the object without inserting them into the context (method appDomain.addEditable), as we do not
				//want that the object dispatch a parsley message COMPLETE, which is catched by the view ProductDesigner
				(allEditableDesigns[productDisplay] as ArrayCollection).addItem(iEditable);
			}
		}
		
		public function get allEditableDesigns():Dictionary
		{
			if(_allEditableDesigns == null)
				_allEditableDesigns = new Dictionary();
			return _allEditableDesigns;
		}

		public function set allEditableDesigns(value:Dictionary):void
		{
			_allEditableDesigns = value;
		}

		public function get designIsForTeams():Boolean
		{
			for each(var key:String in DictionaryUtil.keys(allEditableDesigns))
			{
				for each(var iEditable:IEditable in allEditableDesigns[key])
				{
					if(iEditable is EditableTextTeam)
						return true;
				}
			}
			return false;
		}
		
		
		
		
		public function get productDesignIsRight():Boolean
		{

			var editableDesigns:ArrayCollection = new ArrayCollection();
			for each(var productDisplay:String in productDisplays)
			{
				if(allEditableDesigns[productDisplay] && (allEditableDesigns[productDisplay] as ArrayCollection).length > 0)
				{
					for each(var editableItem:EditableBase in allEditableDesigns[productDisplay] as ArrayCollection)
					{
						//if an editableItem has a filter (the glow filter), is out
						//of the design valid area
						if(editableItem.filters && editableItem.filters.length > 0)
							return false;
					}
				}
			}
			//all the editableItems are within the valid design area
			return true;
		}

		
		
		
		//
		public function get editableItem():IEditable
		{
			return _editableItem;
		}

		public function set editableItem(value:IEditable):void
		{
			_editableItem = value;
			
			//notify that type of selected editable item
			if(_editableItem is EditableText)
				dispatcher(new ProductMessage(ProductMessage.EDITABLE_TEXT_SELECTED));
			else if(_editableItem is EditableDesign)
				dispatcher(new ProductMessage(ProductMessage.EDITABLE_DESIGN_SELECTED));
		}
		
		
		
		//get price of the product, based on the its final design
		public function getPrice(withTax:int, unitaryPrice:int = Constants.PRICE_ALL_UNITS):Number
		{
			var productDisplay:String
			var totalPrice:Number = 0;
			
			if(designIsForTeams)
			{
				//loop through all the product displays
				for each(productDisplay in productDisplays)
				{
					//if a product display contains designs, add the price of the designed product display
					//to the final price product
					if(allEditableDesigns[productDisplay] && (allEditableDesigns[productDisplay] as ArrayCollection).length > 0)
					{
						//the final price is the number of products ordered (nº of introduced players)
						//plus the number of existing texts
						totalPrice = Number(selectedProduct.getPrice(withTax)) * (allEditableDesigns[productDisplay] as ArrayCollection).length;
						totalPrice += Number((selectedProduct.posiciones[productDisplay] as Posicion).getPrice(withTax)) * (allEditableDesigns[productDisplay] as ArrayCollection).length;
					}
				}
				return totalPrice;
			}
			else
			{
				if(!selectedProduct)
					return totalPrice;
				
				totalPrice += Number(selectedProduct.getPrice(withTax));
				
				//if the app is recreating an existing order, check the additional cost that the owner adds to his product
				if(order)
				{
					totalPrice += (withTax == Constants.TAX_WITH)?	(order.products[0] as Product).uprrec+((order.products[0] as Product).uprrec * config.iva) : (order.products[0] as Product).uprrec;
				}
				
				for each(productDisplay in productDisplays)
				{
					//if a product display contains designs, add the price of the designed product display
					//to the final price product
					if(allEditableDesigns[productDisplay] && (allEditableDesigns[productDisplay] as ArrayCollection).length > 0)
					{
						totalPrice += Number((selectedProduct.posiciones[productDisplay] as Posicion).getPrice(withTax));
						
						//also, add the royalties of EditableDesigns, if exist in the display
						for each(var iEditable:IEditable in allEditableDesigns[productDisplay])
						{
							if(iEditable is EditableDesign)
							{
								totalPrice += Number((iEditable as EditableDesign).design.getPrice(withTax));
							}
						}
					}
				}
				
				return (unitaryPrice == Constants.PRICE_UNITARY)?	totalPrice : totalPrice * quantityProduct;
			}
		}
		
		
		
		//the price for the indicated display of the selected product
		public function getProductDisplayPrice(productDisplay:String, withTax:int):Number
		{
			return (allEditableDesigns[productDisplay] && (allEditableDesigns[productDisplay] as ArrayCollection).length > 0)?
				Number((selectedProduct.posiciones[productDisplay] as Posicion).getPrice(withTax)):0;
		}

		public function get orderTimeStamp():Number
		{
			if(isNaN(_orderTimeStamp))
				_orderTimeStamp = (new Date()).getTime();
			return _orderTimeStamp;
		}

		public function set orderTimeStamp(value:Number):void
		{
			_orderTimeStamp = value;
		}

		public function get uploadedBitmaps():ArrayCollection
		{
			if(_uploadedBitmaps == null)
				_uploadedBitmaps = new ArrayCollection();
			return _uploadedBitmaps;
		}

		public function set uploadedBitmaps(value:ArrayCollection):void
		{
			_uploadedBitmaps = value;
		}

		public function get designFonts():ArrayCollection
		{
			if(_designFonts == null)
				_designFonts = new ArrayCollection();
			return _designFonts;
		}

		public function set designFonts(value:ArrayCollection):void
		{
			_designFonts = value;
		}

		public function get selectedColorProduct():Color
		{
			return _selectedColorProduct;
		}

		public function set selectedColorProduct(value:Color):void
		{
			_selectedColorProduct = value;
			dispatcher( new ProductMessage(ProductMessage.CHANGE_PRODUCT_COLOR));
		}

		public function get selectedSizeProduct():Talla
		{
			return _selectedSizeProduct;
		}

		public function set selectedSizeProduct(value:Talla):void
		{
			_selectedSizeProduct = value;
			dispatcher( new ProductMessage(ProductMessage.CHANGE_PRODUCT_SIZE));
		}

		public function get editableItemsFromExistingOrder():Vector.<IEditable>
		{
			if(_editableItemsFromExistingOrder == null)
			{
				_editableItemsFromExistingOrder = new Vector.<IEditable>();
			}
			return _editableItemsFromExistingOrder;
		}

		public function set editableItemsFromExistingOrder(value:Vector.<IEditable>):void
		{
			_editableItemsFromExistingOrder = value;
		}

		public function isEditableItemUpdatable(editable:IEditable):Boolean
		{
			if(editable is EditableTextTeam)
			{
				return false;
			}
			else
			{
				if(editableItemsFromExistingOrder.indexOf(editable) == -1)
				{
					return true;
				}
				else
				{
					//if the item belongs to an existing order, check if we can modify it
					return (profile == Constants.PROFILE_PRODUCT_MODIFIED_BY_OWNER);
				}
			}
		}
		
		
		public function getProductDisplaysSnapshotsByProductDisplayId(productDisplayId:String):String
		{
			for each(var productDisplaySnapshot:ProductDisplaySnapshot in productDisplaysSnapshots)
			{
				if(productDisplaySnapshot.id == productDisplayId)
					return productDisplaySnapshot.base64StringImage;
			}
			return "";
		}
	}
}