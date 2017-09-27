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
	var item: [String] = []
	var isSelected: Bool = false
	
	func toggleSelected() {
		isSelected = !isSelected
	}
	
}
