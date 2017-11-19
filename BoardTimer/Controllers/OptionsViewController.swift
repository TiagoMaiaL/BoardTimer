//
//  OptionsViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/19/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
  }

  // MARK: Actions
  
  @IBAction func continueTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func restartTapped(_ sender: UIButton) {
    NotificationCenter.default.post(name: NotificationName.restartTimer,
                                    object: self)
    dismiss(animated: true, completion: nil)
  }
  
}
