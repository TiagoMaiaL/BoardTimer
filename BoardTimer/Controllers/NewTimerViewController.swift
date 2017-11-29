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
  @IBOutlet weak var modesSegmentedControl: UISegmentedControl!
  
  let timerStorage = TimerConfigurationStorage()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
  }

  // MARK: Actions
  
  @IBAction func doneTapped(_ sender: UIButton) {
    guard let timeAmount = TimeInterval(minutesTextField.text ?? "") else { return }
    guard let delay = TimeInterval(increaseTextField.text ?? "") else { return }
    guard let mode = TimerMode(rawValue: modesSegmentedControl.selectedSegmentIndex) else { return }

    let config = TimerConfiguration(time: timeAmount,
                                    delay: delay,
                                    mode: mode,
                                    name: "")
    timerStorage.store(config)

    dismiss(animated: true) {
      NotificationCenter.default.post(name: NotificationName.newTimer,
                                      object: self,
                                      userInfo: ["timer_config" : config])
    }
  }
  
}
