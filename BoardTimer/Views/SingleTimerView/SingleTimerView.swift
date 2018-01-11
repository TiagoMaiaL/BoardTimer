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
  
  static let whiteBgColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1)
  static let whiteLabelColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
  
  static let darkBgColor = UIColor(red: 52.0/255.0, green: 73.0/255.0, blue: 94.0/255.0, alpha: 1)
  static let darkLabelColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
  
  static let warningColor = UIColor(red:208.0/255.0, green: 2.0/255.0, blue: 27.0/255.0, alpha: 1)
  
  static let colors = [
    white: (bg: Theme.whiteBgColor,
            labels: Theme.whiteLabelColor),
    dark: (bg: Theme.darkBgColor,
           labels: Theme.darkLabelColor),
  ]
  
  func getColors() -> (bg: UIColor, labels: UIColor) {
    return Theme.colors[self]!
  }
}

@IBDesignable
class SingleTimerView: UIView {

  // MARK: Properties
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var progressView: CircleProgressBar!
  @IBOutlet weak var movesLabel: UILabel!
  
  var theme: Theme! {
    didSet {
      if oldValue != theme {
        apply(theme: theme)
      }
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
    let colors = theme.getColors()
    
    backgroundColor = colors.bg
    timeLabel.textColor = colors.labels
    progressView.tint = colors.labels
    movesLabel.textColor = colors.labels.faded(by: 0.3)
  }
  
  func setText(_ time: String) {
    timeLabel.text = time
  }
  
  func setProgress(_ progress: Float) {
    progressView.progress = progress
    progressView.setNeedsDisplay()
  }
  
  func animateWarningState() {
    guard timeLabel.textColor != Theme.warningColor else { return }
    
    progressView.tint = Theme.warningColor
    
    UIView.transition(with: timeLabel, duration: 0.3, options: .transitionCrossDissolve, animations: { [unowned self] in
      self.timeLabel.textColor = Theme.warningColor
    }, completion: nil)
  }
  
  func animateDefaultState() {
    guard timeLabel.textColor != theme.getColors().labels else { return }
    
    UIView.animate(withDuration: 0.3) { [unowned self] in
      self.apply(theme: self.theme)
    }
  }
  
  func animateIn() {
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseIn,
                   animations: { [unowned self] in
                    self.timeLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.progressView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.timeLabel.alpha = 1
                    self.movesLabel.alpha = 1
    })
  }
  
  func animateOut() {
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseIn,
                   animations: { [unowned self] in
                    self.timeLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.progressView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.timeLabel.alpha = 0.5
                    self.movesLabel.alpha = 0.5
    })
  }
  
  func animateInitial() {
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseIn,
                   animations: { [unowned self] in
                    self.timeLabel.transform = .identity
                    self.progressView.transform = .identity
                    self.timeLabel.alpha = 1
                    self.movesLabel.alpha = 1
    })
  }

}
