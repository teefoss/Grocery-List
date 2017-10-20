// Data Model

import Foundation

// Section = Supermarket aisle
class Section: NSObject, Codable {

	var name: String = ""
	var groceryItem: [Item] = []		// grocery list items
	var masterListItem: [Item] = []		// saved items list
	var isSelected: Bool = false		// for selecting which section an item is in while adding an item
	var isCollapsed: Bool = false
	
}



class Item: NSObject, Codable {
	
	var name: String = ""
	var isInCart: Bool = false
	var isOnGroceryList: Bool = false
	
	init(name: String, isInCart: Bool, isOnGroceryList: Bool) {
		self.name = name
		self.isInCart = isInCart
		self.isOnGroceryList = isOnGroceryList
	}
	
}





