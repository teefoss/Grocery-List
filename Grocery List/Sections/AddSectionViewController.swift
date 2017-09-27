//
//  AddSectionViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/25/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

protocol AddSectionViewControllerDelegate: class {
	func AddSectionViewControllerDidCancel(_ controller: AddSectionViewController)
	func AddSectionViewController(_ controller: AddSectionViewController, didFinishAdding item: Section)
	func AddSectionViewController(_ controller: AddSectionViewController, didFinishEditing item: Section)
}

class AddSectionViewController: UITableViewController, UITextFieldDelegate {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	weak var delegate: AddSectionViewControllerDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		title = "Add an Aisle"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}


	
	
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

	// make row not selectable
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
	

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText = textField.text!
		let stringRange = Range(range, in: oldText)!
		let newText = oldText.replacingCharacters(in: stringRange, with: string)

		doneButton.isEnabled = !newText.isEmpty
		return true
	}

	
	
	@IBAction func cancel() {
		delegate?.AddSectionViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		let section = Section()
		section.name = textField.text!
		delegate?.AddSectionViewController(self, didFinishAdding: section)
	}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
