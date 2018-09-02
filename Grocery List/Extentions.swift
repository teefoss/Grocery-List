
import UIKit

extension UIApplication {
	
	class func isFirstLaunch() -> Bool {
		if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
			return true
		}
		return false
	}
}

extension UIView {
	
	func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		
		animation.toValue = toValue
		animation.duration = duration
		animation.isRemovedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		
		self.layer.add(animation, forKey: nil)
	}
	
}

extension UIViewController {
	
	func presentInfoAlert(withTitle title: String, message: String, buttonText: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}


