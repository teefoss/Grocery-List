//
//  MasterListViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/28/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class MasterListViewController: UITableViewController, AddItemViewControllerDelegate, ToolbarDelegate {
	

	var sections: [Section] = []
	
	
	
	
	
	
	// MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.largeTitleDisplayMode = .never
		title = "Master List"
		
    }
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadSections()
		tableView.reloadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		saveSections()
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
	
//	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
//		let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
//		label.font = UIFont.systemFont(ofSize: 14.0)
//		label.textColor = UIColor.darkText
//		label.textAlignment = NSTextAlignment.center
//		label.text = sections[section].name
//		view.addSubview(label)
//		view.backgroundColor = UIColor.groupTableViewBackground
//
//		return view
//	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "\(sections[section].name)   \(sections[section].masterListItem.count)"
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

	
	
	
	// Editing
	
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			sections[indexPath.section].masterListItem.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveSections()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

		let itemToMove = sections[fromIndexPath.section].masterListItem[fromIndexPath.row]
		sections[fromIndexPath.section].masterListItem.remove(at: fromIndexPath.row)
		sections[to.section].groceryItem.insert(itemToMove, at: to.row)
		saveSections()
		tableView.reloadData()
    }

	// Limit moving rows to current section
	override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if sourceIndexPath.section != proposedDestinationIndexPath.section {
			var row = 0
			if sourceIndexPath.section < proposedDestinationIndexPath.section {
				row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
			}
			return IndexPath(row: row, section: sourceIndexPath.section)
		}
		return proposedDestinationIndexPath
	}

	
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
	
	@objc func editPressed() {
		
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


}
