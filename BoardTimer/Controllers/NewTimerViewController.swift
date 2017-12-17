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
    
    form +++ Section("General")
      <<< NameRow() {
        $0.title = "Name"
        $0.placeholder = "Enter the timer name"
        $0.add(rule: RuleRequired())
      }
      <<< CountDownRow() {
        $0.title = "Time for each player"
        $0.add(rule: RuleRequired())
        $0.minuteInterval = 60
      }
      +++ Section("Delays")
      <<< SwitchRow(){
        $0.title = "Use delays"
        $0.value = false
      }
      <<< SegmentedRow() {
        $0.options = ["Fischer", "test", "test"]
      }
      // TODO: Add the details row here.
      <<< StepperRow() {
        $0.title = "Delay amount in seconds"
        $0.value = 0
        $0.displayValueFor = { value in
          "\(Int(value ?? 0))"
        }
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
