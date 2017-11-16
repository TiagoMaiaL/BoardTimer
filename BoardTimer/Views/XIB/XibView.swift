//
//  XibView.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/16/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

// TODO: Add Documentation

@IBDesignable
class XibView: UIView {

  // MARK: Properties
  
  var contentView: UIView?
  @IBInspectable var nibName: String?

  // MARK: Object life cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupXib()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setupXib()
    contentView?.prepareForInterfaceBuilder()
  }
  
  // Setup
  
  func setupXib() {
    guard let view = loadViewFromNib() else { return }
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, 
                             .flexibleHeight]
    addSubview(view)
    contentView = view
  }
  
  func loadViewFromNib() -> UIView? {
    guard let nibName = nibName else { return nil }
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName,
                    bundle: bundle)
    
    return nib.instantiate(withOwner: self, options: nil).first as? UIView
  }
  
}
