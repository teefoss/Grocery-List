//
//  SectionsListViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/27/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class SectionsListViewController: UITableViewController {

	var sections: [Section] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Aisles"
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionListCell", for: indexPath)
		cell.textLabel?.text = sections[indexPath.row].name
		if sections[indexPath.row].isSelected {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for i in sections.indices {
			if i == indexPath.row {
				sections[i].isSelected = true
			} else {
				sections[i].isSelected = false
			}
		}
		tableView.deselectRow(at: indexPath, animated: true)
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}


}
