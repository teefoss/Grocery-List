//
//  SectionsViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/24/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit




class SectionsViewController: UITableViewController, AddSectionViewControllerDelegate {
	
	
	var sections: [Section] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.leftBarButtonItem = self.editButtonItem
		title = "Aisles & Sections"
		loadSections()


		// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source
	
	// Table Setup

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionsID", for: indexPath)

		let section = sections[indexPath.row]
		cell.textLabel?.text = section.name

        return cell
    }

	
	
	// Editing
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
	}
	
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			sections.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveSections()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.row]
		sections.remove(at: fromIndexPath.row)
		sections.insert(itemToMove, at: to.row)
		saveSections()
    }


	
	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "addSection" {
			let addSectionVC = segue.destination as! AddSectionViewController
			addSectionVC.delegate = self
		}
	}
	
	
	
	
	
	
	
	
	// MARK: - Add Section Delegate Methods

	// Cancel
	func AddSectionViewControllerDidCancel(_ controller: AddSectionViewController) {
		navigationController?.popViewController(animated: true)
	}
	
	// Add a section
	func AddSectionViewController(_ controller: AddSectionViewController, didFinishAdding section: Section) {

//		let indexPath = IndexPath(row: 0, section: 0)
		sections.append(section)
//		tableView.insertSections(indexSet, with: .automatic)
		
//		let indexPath = IndexPath(row: newRowIndex, section: 0)
//		let indexPaths = [indexPath]
//		tableView.insertRows(at: indexPaths, with: .automatic)
		saveSections()
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}
	
	// Edit
	func AddSectionViewController(_ controller: AddSectionViewController, didFinishEditing section: Section) {
		saveSections()
	}
	
	
	
	
	
	
	
	
	// MARK: - Data Methods
	
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
