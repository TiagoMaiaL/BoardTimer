//
//  NewTimerViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/19/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class NewTimerViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet weak var minutesTextField: UITextField!
  @IBOutlet weak var increaseTextField: UITextField!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  // MARK: Actions
  
  @IBAction func doneTapped(_ sender: UIButton) {
    guard let timeAmount = Int(minutesTextField.text ?? "") else { return }
    guard let increaseAmount = Int(increaseTextField.text ?? "") else { return }

    let config = (timeAmount: TimeInterval(timeAmount * 60),
                  playIncrease: TimeInterval(increaseAmount))
    
    NotificationCenter.default.post(name: NotificationName.newTimer,
                                    object: self,
                                    userInfo: ["player_configuration" : config])
    dismiss(animated: true, completion: nil)
  }
  
}
