import UIKit

class GroceriesViewController: UITableViewController, AddItemViewControllerDelegate {
	
	
	var sections: [Section] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.leftBarButtonItem = editButtonItem
		title = "Grocery List"

		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadSections()
		tableView.reloadData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		saveSections()
	}


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
			return "\(sections[section].name)   \(sections[section].groceryItem.count)"
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].groceryItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath) as! GroceryItemCell		
		let item = sections[indexPath.section].groceryItem[indexPath.row]
		cell.label?.text = item.name

		cell.checkBox.isChecked = item.isInCart
		cell.checkBox.setNeedsDisplay()
		
		cell.check = {
			item.isInCart = !item.isInCart
			cell.checkBox.isChecked = item.isInCart
			print("\(item.isInCart)")
			self.saveSections()
		}
        return cell
    }

//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let cell = tableView.cellForRow(at: indexPath) as! GroceryItemCell
//		let item = sections[indexPath.section].item[indexPath.row]
//		item.isInCart = !item.isInCart
//		print("\(item.isInCart)")
//		cell.checkBox.isChecked = !cell.checkBox.isChecked
//		tableView.deselectRow(at: indexPath, animated: true)
//		saveSections()
//	}
	

	@objc func deleteChecked(sender: UIBarButtonItem) {

		var indicesOfSelected: [IndexPath] = []
		var newItems: [Item] = []

		for i in sections.indices {
			newItems.removeAll()
			for j in sections[i].groceryItem.indices {
				if sections[i].groceryItem[j].isInCart {
					indicesOfSelected.append(IndexPath(row: j, section: i))
				} else {
					let item = sections[i].groceryItem[j]
					newItems.append(item)
				}
			}
			sections[i].groceryItem.removeAll()
			sections[i].groceryItem = newItems
		}
		saveSections()
		tableView.deleteRows(at: indicesOfSelected, with: .fade)
		tableView.reloadData()
		isEditing = false
		}
	
	@objc func addPressed(sender: UIBarButtonItem) {
		performSegue(withIdentifier: "AddItem", sender: nil)
		
	}
	
	
	// Editing
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		if isEditing {
			title = ""
			let deleteItem = UIBarButtonItem(title: "Delete Selected", style: .plain, target: self, action: #selector(self.deleteChecked))
			//navigationItem.setRightBarButton(deleteItem, animated: true)
			navigationItem.rightBarButtonItem = deleteItem
		} else {
			title = "Grocery List"
			let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPressed))
			//navigationItem.setRightBarButton(addButton , animated: true)
			navigationItem.rightBarButtonItem = addButton
		}
	}

	// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			sections[indexPath.section].groceryItem.remove(at: indexPath.row)
			// Delete from the table
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveSections()
			tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.section].groceryItem[fromIndexPath.row]
		sections[fromIndexPath.section].groceryItem.remove(at: fromIndexPath.row)
		sections[to.section].groceryItem.insert(itemToMove, at: to.row)
		saveSections()
		tableView.reloadData()
	}
	
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

	
	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "AddItem" {
			let addItemVC = segue.destination as! AddItemViewController
			addItemVC.setGL = true
			addItemVC.setML = false
			addItemVC.sections = self.sections
			addItemVC.delegate = self
		}
		if segue.identifier == "EditItem" {
			let addItemVC = segue.destination as! AddItemViewController
			addItemVC.setGL = true
			addItemVC.setML = false
			addItemVC.sections = self.sections
			addItemVC.delegate = self

		}
	
	}
	
	// MARK: - Add Item Delegate Methods
	
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section]) {
		sections = item
		saveSections()
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}
	
	func didCancel(_ controller: AddItemViewController) {
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
