//
//  SectionToggle.swift
//  Grocery List
//
//  Created by Thomas Foster on 10/24/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class SectionToggle: UIView {

	var closed: Bool = false
	
    override func draw(_ rect: CGRect) {

		let margin:CGFloat = 4.0
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: bounds.minX+margin, y: bounds.midY))
		path.addLine(to: CGPoint(x: bounds.maxX-margin, y: bounds.midY))

		if closed {
			path.move(to: CGPoint(x: bounds.midX, y: bounds.maxY-margin))
			path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY+margin))

		}
		
		let context = UIGraphicsGetCurrentContext()
		
		let shadow = UIColor.black.withAlphaComponent(0.3)
		let shadowOffset = CGSize(width: 0.5, height: 0.5)
		let shadowBlurRadius: CGFloat = 0.5

		context?.saveGState()
		context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
		
		path.lineWidth = 1.5
		let reallyLightGray = UIColor.lightGray.withAlphaComponent(0.5)
		reallyLightGray.setStroke()
		path.stroke()
		context?.restoreGState()
		
	}

}
