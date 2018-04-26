import UIKit


protocol CollapsibleTableViewHeaderDelegate {
	func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}


class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var button: SectionToggle!
	
	var delegate: CollapsibleTableViewHeaderDelegate?
	var section: Int = 0
//	let titleLabel = UILabel()
//	let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
//	let cell = UITableViewCell()
//	let countLabel = UILabel()
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	var aisle: Section? {
		didSet {
			guard let aisle = aisle else { return }
			countLabel.text = "\(aisle.masterListItem.count)"
			titleLabel.text = aisle.name
			//button.closed = aisle.isCollapsed
			setCollapsed(aisle.isCollapsed)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
	}

	/*
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		cell.frame = button.bounds
		cell.accessoryType = .disclosureIndicator
		cell.isUserInteractionEnabled = false
		button.addSubview(cell)
		
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
		
		contentView.backgroundColor = UIColor.groupTableViewBackground

		let marginGuide = contentView.layoutMarginsGuide


		// Count Label
		countLabel.translatesAutoresizingMaskIntoConstraints = false
		countLabel.textColor = HEADER_COLOR
		countLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		countLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		countLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		countLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true

		// Arrow
		button.translatesAutoresizingMaskIntoConstraints = false
		button.widthAnchor.constraint(equalToConstant: 12).isActive = true
		button.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		button.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true


		// Title label
		contentView.addSubview(titleLabel)
		titleLabel.textColor = UIColor.white
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(countLabel)
		contentView.addSubview(button)

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
*/
	
	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else { return }
		delegate?.toggleSection(self, section: cell.section)
	}
	
	func setCollapsed(_ collapsed: Bool) {
//		button.rotate(collapsed ? 0.0 : .pi / 2)
	}
	
}
