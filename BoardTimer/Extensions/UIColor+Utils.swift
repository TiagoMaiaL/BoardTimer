//
//  UIColor+Utils.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 12/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

extension UIColor {
  
  // MARK: Added Methods
  
  /// Returns the same color with the requested amount of fade.
  func faded(by percentage: CGFloat = 30.0) -> UIColor? {
    var red: CGFloat = 0,
        green: CGFloat = 0,
        blue: CGFloat = 0,
        alpha: CGFloat = 0
    
    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(red: red,
                     green: green,
                     blue: blue,
                     alpha: alpha - (percentage / 100))
    } else {
      return nil
    }
  }
}
