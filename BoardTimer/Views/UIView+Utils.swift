//
//  UIView+Utils.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/26/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

extension UIView {
  
  /// Applies the CGAffineTransform rotation to the spcified angle.
  func rotate(angle: CGFloat) {
    transform = CGAffineTransform(rotationAngle: angle)
  }
  
}
