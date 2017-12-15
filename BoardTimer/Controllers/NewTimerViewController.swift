//
//  NewTimerViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/19/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import Eureka

class NewTimerViewController: FormViewController {

  // MARK: Properties
  
  let timerStorage = TimerConfigurationStorage()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    form +++ Section("Section1")
      <<< TextRow(){ row in
        row.title = "Text Row"
        row.placeholder = "Enter text here"
      }
      <<< PhoneRow(){
        $0.title = "Phone Row"
        $0.placeholder = "And numbers here"
      }
      +++ Section("Section2")
      <<< DateRow(){
        $0.title = "Date Row"
        $0.value = Date(timeIntervalSinceReferenceDate: 0)
    }
  }

  // MARK: Actions
  
//  @IBAction func doneTapped(_ sender: UIButton) {
//    guard let timeAmount = TimeInterval(minutesTextField.text ?? "") else { return }
//    guard let delay = TimeInterval(increaseTextField.text ?? "") else { return }
//    guard let mode = TimerMode(rawValue: modesSegmentedControl.selectedSegmentIndex) else { return }
//
//    let config = TimerConfiguration(time: timeAmount,
//                                    delay: delay,
//                                    mode: mode,
//                                    name: "")
//    timerStorage.store(config)
//
//    dismiss(animated: true) {
//      NotificationCenter.default.post(name: NotificationName.newTimer,
//                                      object: self,
//                                      userInfo: ["timer_config" : config])
//    }
//  }
  
}
