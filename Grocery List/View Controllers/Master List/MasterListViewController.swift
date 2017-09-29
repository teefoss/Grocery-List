//
//  MasterListViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/28/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class MasterListViewController: UITableViewController {

	var sections: [Section] = []
	
	
	// MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.leftBarButtonItem = editButtonItem
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
		navigationItem.rightBarButtonItem = addButton
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadSections()
		tableView.reloadData()
	}
	
	// MARK: - Actions
	
	@objc func addButtonClicked(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "AddToMasterList", sender: nil)
	}
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterListCell", for: indexPath) as! MasterListCell

		let item = sections[indexPath.section].item[indexPath.row]
		if item.isOnMasterList {
			cell.textField.text = item.name
		}

        return cell
    }

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
	
	
	
	
	
	// MARK: - Data
	
	func saveSections() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(sections)
			try data.write(to: sectionsFile(), options: .atomic)
		} catch {
			print("Error encoding item array")
		}
	}
	
	func loadSections() {
		// 1
		let path = sectionsFile()
		// 2
		if let data = try? Data(contentsOf: path) {
			// 3
			let decoder = PropertyListDecoder()
			do {
				// 4
				sections = try decoder.decode([Section].self, from: data)
			} catch {
				print("Error decoding item array")
			}
		} }


}
