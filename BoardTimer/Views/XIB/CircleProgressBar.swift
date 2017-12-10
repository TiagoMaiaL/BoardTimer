//
//  CircleProgressBar.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 12/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class CircleProgressBar: UIView {
  
  // MARK: Properties
  
  var tint: UIColor?
  var progress: Int = 0
  
  // TODO: Correct the radius property
  // TODO: Add the drawing function.
  
  // MARK: Life cycle
  
  override func draw(_ rect: CGRect) {
    if let color = tint {
      drawCircle(ofProgress: 100, andColor: color)
      drawCircle(ofProgress: CGFloat(progress), andColor: color)
    }
  }
  
  // MARK: Imperatives
  
  private func drawCircle(ofProgress progress: CGFloat = 100, andColor color: UIColor = .clear) {
    let radius: CGFloat = (frame.size.width / 2) - 10
    let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    
    let startAngle = CGFloat.pi * 1.5
    let endAngle = progress/100 * (CGFloat.pi * 2) + startAngle
    
    let circlePath = UIBezierPath()
    
    circlePath.addArc(withCenter: center,
                      radius: radius,
                      startAngle: endAngle,
                      endAngle: CGFloat.pi * 4.5,
                      clockwise: true)
    circlePath.lineWidth = 2
    color.setStroke()
    circlePath.stroke()
  }
  
}
