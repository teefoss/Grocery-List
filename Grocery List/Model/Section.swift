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
	var item: [Item] = []
	var isSelected: Bool = false
	
	func toggleSelected() {
		isSelected = !isSelected
	}
	
}



class Item: NSObject, Codable {
	var name: String = ""
	var isInCart: Bool = false
	var isOnGroceryList: Bool = false
	var isOnMasterList: Bool = false

	
	func toggleInCart() {
		isInCart = !isInCart
	}
}





