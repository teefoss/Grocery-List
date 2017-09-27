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
	var addedItem: String = ""
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var sectionCell: UITableViewCell!
	
	@IBAction func done() {
		addedItem = nameTextField.text!
		for i in sections.indices {
			if sections[i].isSelected {
				sections[i].item.append(addedItem)
			}
		}
		delegate?.didAddItem(self, didAddItem: sections)
	}
	
	
	@IBAction func cancel() {
		delegate?.didCancel(self)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = false

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
				sectionCell.textLabel?.text = sections[index].name
				break
			} else {
				sectionCell.textLabel?.text = "No Aisle Selected"
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//			let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
//			sectionCell.textLabel?.text = "Test"
//			return sectionCell
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "SectionListSegue" {
			let sectionListVC = segue.destination as! SectionsListViewController
			sectionListVC.sections = self.sections
		}
	}

}
