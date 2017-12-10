//
//  CircleProgressBar.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 12/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

// TODO: Make this IBDesignable
class CircleProgressBar: UIView {
  
  // MARK: Properties
  
  var tint: UIColor?
  var progress: Int = 0
  
  // MARK: Life cycle
  
  override func draw(_ rect: CGRect) {
    if let color = tint {
      let radius: CGFloat = (frame.size.width / 2) - 10
      let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
      let startAngle = CGFloat.pi * 1.5
      
      // Base circle
      let baseCirclePath = UIBezierPath()
      baseCirclePath.addArc(withCenter: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: CGFloat.pi * 4.5,
                            clockwise: true)
      baseCirclePath.lineWidth = 2
      color.faded(by: 50)!.setStroke()
      baseCirclePath.stroke()
      
      // Progress
      let progressCrclePath = UIBezierPath()
      progressCrclePath.addArc(withCenter: center,
                               radius: radius,
                               startAngle: startAngle,
                               endAngle: CGFloat(progress)/100 * (CGFloat.pi * 2) + startAngle,
                               clockwise: true)
      progressCrclePath.lineWidth = 6
      progressCrclePath.lineCapStyle = .round
      color.setStroke()
      progressCrclePath.stroke()
    }
  }
  
}
