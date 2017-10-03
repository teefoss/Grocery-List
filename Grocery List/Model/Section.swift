//
//  Aisle.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/25/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import Foundation

class Section: NSObject, Codable {

	var name: String = ""
	var groceryItem: [Item] = []
	var masterListItem: [Item] = []
	var isSelected: Bool = false
	
	func addToMasterList(item: Item) {
		masterListItem.append(item)
	}
	
	func addToGroceryList(item: Item) {
		groceryItem.append(item)
	}
	
	func removeFromGroceryList(item: Item) {
		if let index = groceryItem.index(of: item) {
			groceryItem.remove(at: index)
		} else {
			print("Error: Could not remove item from Grocery List!")
		}
	}
	
	// sets isOnGroceryList property for all items in a list
	func setTags(for list: [Item]) {
		for i in list.indices {
			setIsOnGroceryList(for: list[i])
		}
	}
	
	// sets Item class variable "isOnGroceryList"
	func setIsOnGroceryList(for item: Item) {
		for i in groceryItem.indices {
			if item.name == groceryItem[i].name {
				item.isOnGroceryList = true
			}
		}
	}
	
	
}



class Item: NSObject, Codable {
	var name: String = ""
	var isInCart: Bool = false
	var isOnGroceryList: Bool = false

	
	func toggleInCart() {
		isInCart = !isInCart
	}
}





