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
  case dark
}

@IBDesignable
class SingleTimerView: UIView {

  // MARK: Properties
  
  let whiteColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
  let darkColor = UIColor(red: 0/255.0, green: 31/255.0, blue: 43/255.0, alpha: 1)
  
  @IBOutlet weak var timeLabel: UILabel!
  
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
      let bgColor = theme == .white ? whiteColor : darkColor
      let labelColor = theme == .white ? darkColor : whiteColor
      
      backgroundColor = bgColor
      timeLabel.textColor = labelColor
    }
    
    setColors(for: theme)
  }
  
  func setText(_ time: String) {
    timeLabel.text = time
  }

}
