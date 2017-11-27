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
  
  static let colors = [
    white: UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1),
    dark: UIColor(red: 0/255.0, green: 31/255.0, blue: 43/255.0, alpha: 1)
  ]
  
  func getColor() -> UIColor {
    return Theme.colors[self]!
  }
}

@IBDesignable
class SingleTimerView: UIView {

  // MARK: Properties
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  
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
      let bgColor = theme.getColor()
      // Inverse color for contrast
      let labelColor = theme == .white ? Theme.colors[.dark] : Theme.colors[.white]
      
      backgroundColor = bgColor
      timeLabel.textColor = labelColor
    }
    
    setColors(for: theme)
  }
  
  func setText(_ time: String) {
    timeLabel.text = time
  }
  
  func animateIn() {
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseIn,
                   animations: { [unowned self] in
                    self.timeLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.timeLabel.alpha = 1
    })
  }
  
  func animateOut() {
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseIn,
                   animations: { [unowned self] in
                    self.timeLabel.transform = .identity
                    self.timeLabel.alpha = 0.5
    })
  }

}
