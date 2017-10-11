import UIKit

class GroceriesViewController: UITableViewController, AddItemViewControllerDelegate, UITextFieldDelegate {
	
	
	var sections: [Section] = []
	var savedText: String = ""
	
	
	
	// MARK: - View Controller Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Grocery List"
		
		// Set Up Navigation Bar
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.tintColor = UIColor.white
		navigationController?.navigationBar.barTintColor = appColor
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.isOpaque = true

		// Set Up Navigation Items
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Saved Items", style: .plain, target: self, action: #selector(gotoSavedItems))

		// Set Up Toolbar
		navigationController?.toolbar.tintColor = appColor
		navigationController?.toolbar.barTintColor = buttonColor
		toolbarItems = addToolbarItems()
		
		hideKeyboard()
		
	}
	
	
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		
		loadSections()
		tableView.reloadData()
		
		setTableViewBackground(text: "No Groceries")
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

		// Set up Toolbar Buttons
		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed))
		let sectionsButtonItem = UIBarButtonItem(customView: sectionsButton)
		
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
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
		let label = UILabel(frame: CGRect(x: 16, y: 20, width: tableView.frame.size.width, height: 44))
		label.font = UIFont.boldSystemFont(ofSize: 15.0)
		label.textColor = appColor
		if sections[section].groceryItem.isEmpty {
			label.text = nil
		} else {
			label.text = sections[section].name
		}
		view.addSubview(label)
		view.backgroundColor = UIColor.groupTableViewBackground
		
		return view
	}

	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if sections[section].groceryItem.isEmpty {
			return nil
		}
		return "\(sections[section].name)"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].groceryItem.count
    }
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if sections[section].groceryItem.isEmpty {
			return CGFloat.leastNormalMagnitude
		}
		return 64
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath) as! GroceryItemCell		
		let item = sections[indexPath.section].groceryItem[indexPath.row]
		let attributeString = NSMutableAttributedString(string: item.name)
		attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))

		if item.isInCart {
			cell.textField.textColor = UIColor.gray
			cell.textField.attributedText = attributeString
		} else {
			cell.textField.textColor = UIColor.darkText
			cell.textField.attributedText = nil
			cell.textField?.text = item.name
		}
		if item.name == "" {
			item.name = savedText
		}
		cell.checkBox.isChecked = item.isInCart
		cell.checkBox.setNeedsDisplay()
		
		cell.check = {
			item.isInCart = !item.isInCart
			cell.checkBox.isChecked = item.isInCart
			if item.isInCart {
				cell.textField.textColor = UIColor.gray
				cell.textField.attributedText = attributeString
			} else {
				cell.textField.attributedText = nil
				cell.textField.textColor = UIColor.darkText
				cell.textField.text = item.name
			}
			cell.setNeedsDisplay()
			print("\(item.isInCart)")
			self.saveSections()
		}
        return cell
    }

	
	@objc func deletePressed() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { alert -> Void in self.deleteAll() }))
		alert.addAction(UIAlertAction(title: "Clear Selected", style: .destructive, handler: { alert -> Void in self.deleteSelected() }))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert -> Void in }))
		present(alert, animated: true, completion: nil)
	}
	

	func deleteSelected() {

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
		tableView.performBatchUpdates({	tableView.deleteRows(at: indicesOfSelected, with: .right) }, completion: { finished in self.tableView.reloadData() })
		setTableViewBackground(text: "No Groceries")
		isEditing = false
	}
	
	func deleteAll() {
		//var indices = [IndexPath]()
		for i in sections.indices {
			sections[i].groceryItem.removeAll()
		}
		saveSections()
		UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
		setTableViewBackground(text: "No Groceries")
		isEditing = false
	}
	
	
	
	// Editing
	
//	override func setEditing(_ editing: Bool, animated: Bool) {
//		super.setEditing(editing, animated: animated)
//
//	}

	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		savedText = textField.text!
	}
	
//	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//		let oldText = textField.text!
//		let stringRange = Range(range, in: oldText)!
//		let newText = oldText.replacingCharacters(in: stringRange, with: string)
//
//		if newText.isEmpty {
//			return false
//		}
//		return true
//
//	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
//		if textField.text == nil {
//			textField.text = savedText
//			textField.resignFirstResponder()
//		} else {
			textField.resignFirstResponder()
//		}
		return true
	}

	// update model
	func textFieldDidEndEditing(_ textField: UITextField) {
		let location = textField.convert(textField.bounds.origin, to: self.tableView)
		let textFieldIndexPath = self.tableView.indexPathForRow(at: location)
		
		
		if textField.text != nil {
			sections[(textFieldIndexPath?.section)!].groceryItem[(textFieldIndexPath?.row)!].name = textField.text!
		} else {
			sections[(textFieldIndexPath?.section)!].groceryItem[(textFieldIndexPath?.row)!].name = savedText
		}
		tableView.reloadData()
		saveSections()
		
	}

	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			
            // Delete the row from the data source
			sections[indexPath.section].groceryItem.remove(at: indexPath.row)
			saveSections()

			// Delete from the table
			tableView.performBatchUpdates({	tableView.deleteRows(at: [indexPath], with: .automatic)}, completion: { finished in tableView.reloadData() })
			setTableViewBackground(text: "No Groceries")

		}
    }

	
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true		// table is reorderable
    }

	
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.section].groceryItem[fromIndexPath.row]
		sections[fromIndexPath.section].groceryItem.remove(at: fromIndexPath.row)
		sections[to.section].groceryItem.insert(itemToMove, at: to.row)
		saveSections()
//		tableView.reloadData()
	}
	
//	func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//		if sourceIndexPath.section != proposedDestinationIndexPath.section {
//			var row = 0
//			if sourceIndexPath.section < proposedDestinationIndexPath.section {
//				row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
//			}
//			return IndexPath(row: row, section: sourceIndexPath.section)
//		}
//		return proposedDestinationIndexPath
//	}

	
	
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "AddItem" {
			let navigation = segue.destination as! UINavigationController
//			let addItemVC = segue.destination as! AddItemViewController
			var addItemVC = AddItemViewController()
			addItemVC = navigation.viewControllers[0] as! AddItemViewController
			addItemVC.setGL = true
			addItemVC.setML = false
			addItemVC.sections = self.sections
			addItemVC.delegate = self
		}
		
//		if segue.identifier == "AddAisle" {
//			let
//		}
		if segue.identifier == "EditItem" {
			let addItemVC = segue.destination as! AddItemViewController
			addItemVC.setGL = true
			addItemVC.setML = false
			addItemVC.sections = self.sections
			addItemVC.delegate = self

		}
	
	}
	
	
	@objc func addPressed() {
		performSegue(withIdentifier: "AddItem", sender: nil)
		
	}
	
	@objc func aislesPressed() {
		performSegue(withIdentifier: "AddAisle", sender: nil)
	}
	
	@objc func gotoSavedItems() {
		performSegue(withIdentifier: "SavedItemsSegue", sender: nil)
	}

	
	
	
	
	
	
	// MARK: - Add Item Delegate Methods
	
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section]) {
		sections = item
		saveSections()
		tableView.reloadData()
//		navigationController?.popViewController(animated: true)		
	}
	
	func didCancel(_ controller: AddItemViewController) {
//		navigationController?.popViewController(animated: true)
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
	
	// Call these methods in viewDidLoad(), commit EditingStyle, deleteSelected(), deleteAll()
	
	func setTableViewBackground(text: String) {
		
		var isEmpty = true
		
		for i in sections.indices {
			if !sections[i].groceryItem.isEmpty {
				isEmpty = false
			}
		}
		
		if isEmpty {
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






