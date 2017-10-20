import UIKit


protocol CollapsibleTableViewHeaderDelegate {
	func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}


class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

	var delegate: CollapsibleTableViewHeaderDelegate?
	var section: Int = 0
	let titleLabel = UILabel()
	let arrowLabel = UILabel()
	
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(arrowLabel)
		
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
		
		contentView.backgroundColor = UIColor.groupTableViewBackground

		let marginGuide = contentView.layoutMarginsGuide

		// Arrow label
		contentView.addSubview(arrowLabel)
		arrowLabel.textColor = appColor
		arrowLabel.translatesAutoresizingMaskIntoConstraints = false
		arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
		arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		
		// Title label
		contentView.addSubview(titleLabel)
		titleLabel.textColor = UIColor.white
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
			return
		}
		delegate?.toggleSection(self, section: cell.section)
	}
	
	func setCollapsed(_ collapsed: Bool) {
		arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
	}
	
}
