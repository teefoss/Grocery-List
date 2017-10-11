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
		title = "Aisles & Sections"
		navigationItem.rightBarButtonItem = editButtonItem

		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		
		items.append(flexSpace)
		items.append(addButton)
		toolbarItems = items


		// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadSections()
		tableView.reloadData()
		setTableViewBackground(text: "No Aisles")
		
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

	
	//
	// MARK: - Editing
	//
	
	
	
	// Enable moveing rows
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	

    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			if !sections[indexPath.row].groceryItem.isEmpty || !sections[indexPath.row].masterListItem.isEmpty {
				let alert = UIAlertController(title: "Warning", message: "This section contains items. Are you sure you want to delete it?", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
					self.sections.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .fade)
					self.saveSections()
				}))
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				setTableViewBackground(text: "No Aisles")
			} else {
				sections.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
				saveSections()
				setTableViewBackground(text: "No Aisles")
			}
        }
    }
	

    // Move Rows
	
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.row]
		print("itemToMove.groceryItem.count = \(itemToMove.groceryItem.count)")
		sections.remove(at: fromIndexPath.row)
		sections.insert(itemToMove, at: to.row)
		saveSections()
    }


	
	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddSection" {
			let addSectionVC = segue.destination as! AddSectionViewController
			addSectionVC.delegate = self
		}
	}
	
	
	@objc func addPressed(sender: UIBarButtonItem) {
		performSegue(withIdentifier: "AddSection", sender: nil)
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

	
	
	
	// MARK: - Empty View Methods
	
	// Call these methods in viewDidLoad(), commit EditingStyle
	
	func setTableViewBackground(text: String) {
		
		if sections.isEmpty {
			tableView.backgroundView = setupEmptyView(text: text)
		} else {
			tableView.backgroundView = nil
		}
		
	}
	
	
	func setupEmptyView(text: String) -> UIView {
		let emptyView = UIView()
		let label = UILabel()
		emptyView.frame = tableView.frame
		emptyView.backgroundColor = UIColor.groupTableViewBackground
		label.frame = CGRect.zero
		label.text = text
		label.font = UIFont.boldSystemFont(ofSize: 36.0)
		label.textColor = UIColor.lightGray
		//		label.shadowColor = UIColor.lightGray
		//		label.shadowOffset = CGSize(width: 1.0, height: 1.0)
		label.sizeToFit()
		label.center = emptyView.center
		emptyView.addSubview(label)
		return emptyView
	}



}
