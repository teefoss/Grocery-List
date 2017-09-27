import UIKit

//@IBDesignable
class CheckBox: UIButton {
	
	var isChecked: Bool = false
	
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	
	override func draw(_ rect: CGRect) {
		
		let circleThickness: CGFloat = 1.5

		let circlex = rect.origin.x + 0.5 * circleThickness
		let circley = rect.origin.y + 0.5 * circleThickness
		let circleWidth = rect.width - circleThickness
		let circleHeight = rect.height - circleThickness
		let circleRect = CGRect(x: circlex, y: circley, width: circleWidth, height: circleHeight)
		
		let dotx = rect.origin.x + 5.0
		let doty = rect.origin.y + 5.0
		let dotWidth = rect.size.width - 10.0
		let dotHeight = rect.size.height - 10.0
		let dotRect = CGRect(x: dotx, y: doty, width: dotWidth, height: dotHeight)
		
		let circle = UIBezierPath(ovalIn: circleRect)
		circle.lineWidth = circleThickness
		UIColor.gray.setStroke()
		circle.stroke()
		
		if isChecked {
			let dot = UIBezierPath(ovalIn: dotRect)
			UIColor.darkGray.setFill()
			dot.fill()
		}
		
		
	}
	
	private struct Constants {
		static let checkWidth: CGFloat = 3.0
		static let checkScale: CGFloat = 0.6
		static let halfPointShift: CGFloat = 0.5
	}
	
	private var halfWidth: CGFloat {
		return bounds.width / 2
	}
	
	private var halfHeight: CGFloat {
		return bounds.height / 2
	}
	
}
