//
//  MasterListViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/28/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class MasterListViewController: UITableViewController, AddItemViewControllerDelegate {
	

	var sections: [Section] = []
	
	
	
	// MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = editButtonItem
		title = "Saved Items"
		toolbarItems = addToolbarItems()
    }
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadSections()
		tableView.reloadData()
		setTableViewBackground(text: "No Items")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		saveSections()
	}
	
	func addToolbarItems() -> [UIBarButtonItem] {
		
		// Set up Aisles Button
		let sectionsButton = UIButton()
		sectionsButton.frame = CGRect.zero
		sectionsButton.setTitle("  Edit Aisles  ", for: .normal)
		sectionsButton.setTitle("  Edit Aisles  ", for: .highlighted)
		sectionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
		sectionsButton.backgroundColor = appColor
		sectionsButton.layer.cornerRadius = 5.0
		sectionsButton.sizeToFit()
		sectionsButton.addTarget(self, action: #selector(aislesPressed), for: .touchUpInside)

		// Set up Toolbar
		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let sectionsButtonItem = UIBarButtonItem(customView: sectionsButton)
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed))
		
		items.append(deleteButton)
		items.append(flexSpace)
		items.append(sectionsButtonItem)
		items.append(flexSpace)
		items.append(addButton)
		
		return items
	}

	
	
	
	
	
	
	
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].masterListItem.count
    }
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
		let label = UILabel(frame: CGRect(x: 16, y: 20, width: tableView.frame.size.width, height: 44))
		label.font = UIFont.boldSystemFont(ofSize: 15.0)
		label.textColor = appColor
		label.text = sections[section].name
		view.addSubview(label)
		view.backgroundColor = UIColor.groupTableViewBackground		
		return view
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 64
	}

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "\(sections[section].name)"
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("begin cellforrowat")
		let cell = tableView.dequeueReusableCell(withIdentifier: "MasterListCell", for: indexPath) as! MasterListCell
		let item = sections[indexPath.section].masterListItem[indexPath.row]
		var index: Int = 0
		cell.label?.text = item.name
		item.isOnGroceryList = false

		
		for i in sections[indexPath.section].groceryItem.indices {
			if item.name == sections[indexPath.section].groceryItem[i].name {
				index = i
				item.isOnGroceryList = true
				print("for loop 1")
				break
			} else {
				item.isOnGroceryList = false
				print("for loop 2")
			}
		}
		
		cell.plusButton.showPlus = !item.isOnGroceryList
		cell.plusButton.setNeedsDisplay()
		
		cell.plus = {
			if item.isOnGroceryList == false {
				item.isOnGroceryList = true
				self.sections[indexPath.section].addToGroceryList(item: item)
				print("added item: item.isOnGroceryList = \(item.isOnGroceryList)")
			} else {
				item.isOnGroceryList = false
				for i in self.sections[indexPath.section].groceryItem.indices {
					if item.name == self.sections[indexPath.section].groceryItem[i].name {
						index = i
					}
				}
				self.sections[indexPath.section].groceryItem.remove(at: index)

			}
			cell.plusButton.showPlus = !item.isOnGroceryList
			self.saveSections()
			print("\(item.isOnGroceryList)")
		}

        return cell
    }

	
	
	//
	// Editing
	//
	
	// Enable Reordering of Rows
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

    // Handle Deleting Rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			sections[indexPath.section].masterListItem.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveSections()
			setTableViewBackground(text: "No Items")

        }
    }

    // Handle Reordering Rows
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.section].masterListItem[fromIndexPath.row]

		sections[fromIndexPath.section].masterListItem.remove(at: fromIndexPath.row)
		sections[to.section].masterListItem.insert(itemToMove, at: to.row)
		saveSections()
		
		
    }
	
	
	
	@objc func deletePressed() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { alert -> Void in self.deleteAll() }))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert -> Void in }))
		present(alert, animated: true, completion: nil)
	}

	func deleteAll() {
		//var indices = [IndexPath]()
		for i in sections.indices {
			sections[i].masterListItem.removeAll()
		}
		saveSections()
		UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
		setTableViewBackground(text: "No Items")
		isEditing = false
	}


	
	
	
	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

		if segue.identifier == "AddToMasterList" {
			let addVC = segue.destination as! AddItemViewController
			addVC.setML = true
			addVC.setGL = false
			addVC.sections = self.sections
			addVC.delegate = self
		}
	}
	
	@objc func addPressed() {
		performSegue(withIdentifier: "AddToMasterList", sender: nil)
	}
	
	@objc func aislesPressed() {
		performSegue(withIdentifier: "AddSection", sender: nil)
	}
	

	
	
	
	
	
	// MARK: - Add Item Delegate Methods
	
	func didCancel(_ controller: AddItemViewController) {
		navigationController?.popViewController(animated: true)
	}
	
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section]) {
		sections = item
		saveSections()
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}

	
	
	
	
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

	
	
	
	// MARK: - Empty View Methods
	
	// Call these methods in viewDidLoad(), commit EditingStyle, deleteAll()
	
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
