//
//  SingleTimerView.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/15/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

enum Theme {
  case white
  case black
}

@IBDesignable
class SingleTimerView: UIView {

  // MARK: Properties
  
  let whiteColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
  let blackColor = UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1)
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var rotatedLabel: UILabel!
  
  var theme: Theme! {
    didSet {
      apply(theme: theme)
    }
  }
  
  // MARK: Object life cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if theme == nil {
      theme = .white
    }
  }
  
  // MARK: Imperatives
  
  private func apply(theme: Theme = .white) {
    
    func setColors(for theme: Theme) {
      let bgColor = theme == .white ? whiteColor : blackColor
      let labelColor = theme == .white ? blackColor : whiteColor
      
      backgroundColor = bgColor
      timeLabel.textColor = labelColor
      rotatedLabel.textColor = labelColor
    }
    
    switch theme {
    case .white:
      setColors(for: .white)
    case .black:
      setColors(for: .black)
    }
  }

}
