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
  let defaultTimerKey = "default_timer"
  
  // MARK: Properties
  
  var defaults: UserDefaults {
    get {
      return UserDefaults.standard
    }
  }
  
  // MARK: Imperatives
  
  func clear() {
    defaults.removeObject(forKey: timersKey)
  }
  
  func getSavedCustomTimers() -> [TimerConfiguration]? {
    var timers: [TimerConfiguration]? = nil
    
    if let savedTimers = defaults.object(forKey: timersKey) as? Data {
      let decoder = JSONDecoder()
      timers = try? decoder.decode([TimerConfiguration].self, from: savedTimers)
    }
    
    return timers
  }
  
  func store(_ timer: TimerConfiguration) {
    var timers = getSavedCustomTimers() ?? []
    
    timers.append(timer)
    
    store(timers)
  }
  
  private func store(_ timers: [TimerConfiguration]) {
    let encoder = JSONEncoder()
    if let encodedTimers = try? encoder.encode(timers) {
      defaults.set(encodedTimers, forKey: timersKey)
    }
  }
  
  func remove(_ timer: TimerConfiguration) {
    guard var timers = getSavedCustomTimers() else { return }
    
    if let index = timers.index(of: timer) {
      timers.remove(at: index)
      store(timers)
    }
  }

  func storeDefaultConfiguration(_ configuration: TimerConfiguration) {
    let encoder = JSONEncoder()
    
    if let encodedTimer = try? encoder.encode(configuration) {
      defaults.set(encodedTimer, forKey: defaultTimerKey)
    }
  }

  func getDefaultConfiguration() -> TimerConfiguration? {
    var defaultTimer: TimerConfiguration?
    
    if let defaultTimerData = defaults.object(forKey: defaultTimerKey) as? Data {
      let decoder = JSONDecoder()
      defaultTimer = try? decoder.decode(TimerConfiguration.self, from: defaultTimerData)
    }
    
    return defaultTimer
  }
}
