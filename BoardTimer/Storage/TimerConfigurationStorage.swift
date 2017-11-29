//
//  TimerConfigurationStorage.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/29/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class TimerConfigurationStorage: NSObject {
  
  // MARK: Constants
  
  let timersKey = "custom_timers"
  
  // MARK: Imperatives
  
  func getSavedCustomTimers() -> [TimerConfiguration]? {
    let defaults = UserDefaults.standard
    
    var timers: [TimerConfiguration]? = nil
    
    if let savedTimers = defaults.object(forKey: timersKey) as? Data {
      let decoder = JSONDecoder()
      timers = try? decoder.decode([TimerConfiguration].self, from: savedTimers)
    }
    
    return timers
  }
  
  func store(_ timer: TimerConfiguration) {
    var timers = getSavedCustomTimers() ?? []
    
    let defaults = UserDefaults.standard
    timers.append(timer)
    
    let encoder = JSONEncoder()
    if let encodedTimers = try? encoder.encode(timers) {
      defaults.set(encodedTimers, forKey: "custom_timers")
    }
  }
}
