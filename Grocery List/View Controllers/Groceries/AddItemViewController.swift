//
//  AddItemViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/26/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
	func didCancel(_ controller: AddItemViewController)
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section])
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

	var sections: [Section] = []
	var delegate: AddItemViewControllerDelegate?
	
	var setGL: Bool = false
	var setML: Bool = true
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var sectionCell: UITableViewCell!
	@IBOutlet weak var aisleTextLabel: UILabel!
	
	// Switches
	
	@IBOutlet weak var grocerySwitch: UISwitch!
	@IBOutlet weak var masterListSwitch: UISwitch!
	
	@IBAction func grocerySwitchPressed(_ sender: Any) {
		if !masterListSwitch.isOn {
			masterListSwitch.setOn(true, animated: true)
		}
	}
	
	@IBAction func masterListSwitchPressed(_ sender: Any) {
		if !grocerySwitch.isOn {
			grocerySwitch.setOn(true, animated: true)
		}
	}
	
	
	// Done Button
	
	@IBAction func done() {
		let addedItem = Item()
		addedItem.name = nameTextField.text!
		addedItem.isInCart = false
		for i in sections.indices {
			if sections[i].isSelected {
				if grocerySwitch.isOn {
					sections[i].addToGroceryList(item: addedItem)
				}
				if masterListSwitch.isOn {
					sections[i].addToMasterList(item: addedItem)
				}
			}
		}
		delegate?.didAddItem(self, didAddItem: sections)
	}
	
	@IBAction func cancel() {
		delegate?.didCancel(self)
	}
	
	
	
	
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		doneButton.isEnabled = true
		navigationController?.navigationBar.prefersLargeTitles = false
		grocerySwitch.isOn = setGL
		masterListSwitch.isOn = setML

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		nameTextField.becomeFirstResponder()
		for index in sections.indices {
			if sections[index].isSelected {
				aisleTextLabel.text = sections[index].name
				break
			} else {
				aisleTextLabel.text = "None Selected"
			}

		}
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText = nameTextField.text!
		let stringRange = Range(range, in: oldText)!
		let newText = oldText.replacingCharacters(in: stringRange, with: string)
		
		doneButton.isEnabled = !newText.isEmpty
		return true
	}
	
	
	
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if section == 2 {	// lists sections
			return 2
		} else {
			return 1		// name & aisle sections
		}
	}





    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "SectionListSegue" {
			let sectionListVC = segue.destination as! SectionsListViewController
			sectionListVC.sections = self.sections
		}
	}

}
