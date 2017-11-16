//
//  UIView+Rotation.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/15/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

@IBDesignable
class RotatableLabel: UILabel {
  
  // MARK: Properties
  
  @IBInspectable
  var rotationAngle: Double = 0 {
    didSet {
      transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * 2) + rotationAngle))
      layoutIfNeeded()
    }
  }
  
}
