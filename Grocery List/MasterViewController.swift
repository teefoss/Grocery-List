//
//  MasterViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 10/3/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

protocol ToolbarDelegate {
	func addPressed()
	func editPressed()
	func aislesPressed()
}


class MasterViewController: UIViewController {


	@IBOutlet var segmentedControl: UISegmentedControl!
	
	var delegate: ToolbarDelegate?
	
	
	
	private lazy var groceryViewController: GroceriesViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		var viewController = storyboard.instantiateViewController(withIdentifier: "GroceryListVC") as! GroceriesViewController
		self.add(asChildViewController: viewController)
		return viewController
	}()
	
	private lazy var masterListViewController: MasterListViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		var viewController = storyboard.instantiateViewController(withIdentifier: "MasterListVC") as! MasterListViewController
		self.add(asChildViewController: viewController)
		return viewController
	}()

	
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		toolbarItems = addToolbarItems()
		setupView()
    }
	


	
	@objc func addPressed(_ sender: UIBarButtonItem) {
		delegate?.addPressed()
	}

	@objc func aislesPressed(_ sender: UIBarButtonItem) {
		delegate?.aislesPressed()
	}

	
	private func setupView() {
		setupSegmentedControl()
		updateView()
	}
	
	private func setupSegmentedControl() {
		// configure segmented control
		segmentedControl.removeAllSegments()
		segmentedControl.insertSegment(withTitle: "Grocery List", at: 0, animated: false)
		segmentedControl.insertSegment(withTitle: "Saved Items", at: 1, animated: false)
		segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
		
		segmentedControl.selectedSegmentIndex = 0
	}
	
	@objc func selectionDidChange(_ sender: UISegmentedControl) {
		updateView()
	}
	
	func add(asChildViewController viewController: UIViewController) {
		addChildViewController(viewController)
		view.addSubview(viewController.view)
		viewController.view.frame = view.bounds
		viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		viewController.didMove(toParentViewController: self)
	}
	
	func remove(asChildViewController viewController: UIViewController) {
		viewController.willMove(toParentViewController: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	private func updateView() {
		if segmentedControl.selectedSegmentIndex == 0 {
			add(asChildViewController: groceryViewController)
//			delegate = groceryViewController
			remove(asChildViewController: masterListViewController)
		} else {
			add(asChildViewController: masterListViewController)
//			delegate = masterListViewController
			remove(asChildViewController: groceryViewController)
		}
	}
	


}
