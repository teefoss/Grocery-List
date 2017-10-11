//
//  Extentions.swift
//  Grocery List
//
//  Created by Thomas Foster on 10/11/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

extension UITableViewController
{
	func hideKeyboard()
	{
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(UITableViewController.dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard()
	{
		view.endEditing(true)
	}
}
