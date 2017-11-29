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
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
//    navigationItem.title = "New timer"
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
    store(config)
    
    dismiss(animated: true) {
      NotificationCenter.default.post(name: NotificationName.newTimer,
                                      object: self,
                                      userInfo: ["timer_config" : config])
    }
  }
  
}

// MARK: Timer configuration storage

extension NewTimerViewController {
  
  func store(_ timer: TimerConfiguration) {
    // TODO: save config into the user defaults
    var timers: [TimerConfiguration]!
    
    let defaults = UserDefaults.standard
    
    if let storedData = defaults.object(forKey: "custom_timers") as? Data {
      let decoder = JSONDecoder()
      timers = try? decoder.decode([TimerConfiguration].self, from: storedData)
    }
    
    if timers == nil {
      timers = []
    }
    
    timers.append(timer)
    
    let encoder = JSONEncoder()
    if let encodedTimers = try? encoder.encode(timers) {
      defaults.set(encodedTimers, forKey: "custom_timers")
    }
  }
  
}
