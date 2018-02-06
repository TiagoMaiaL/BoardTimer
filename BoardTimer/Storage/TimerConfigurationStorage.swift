//
//  TimerConfigurationStorage.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/29/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// Class in charge of storing the timer configurations.
class TimerConfigurationStorage: NSObject {
  
  // MARK: Constants
  
  /// Key for the custom timers storage.
  private let timersKey = "custom_timers"
  
  /// Key for the default timer storage.
  private let defaultTimerKey = "default_timer"
  
  // MARK: Properties
  
  /// The user defaults instance used to store the timers.
  private var defaults: UserDefaults {
    get {
      return UserDefaults.standard
    }
  }
  
  // MARK: Imperatives
  
  /// Clears the custom timers from the storage.
  func clear() {
    defaults.removeObject(forKey: timersKey)
  }
  
  /// Returns the stored custom timers.
  func getSavedCustomTimers() -> [TimerConfiguration]? {
    var timers: [TimerConfiguration]? = nil
    
    if let savedTimers = defaults.object(forKey: timersKey) as? Data {
      let decoder = JSONDecoder()
      timers = try? decoder.decode([TimerConfiguration].self, from: savedTimers)
    }
    
    return timers
  }
  
  /// Stores a single custom timer.
  /// - Parameter timer: the custom timer configuration to be stored.
  func store(_ timer: TimerConfiguration) {
    var timers = getSavedCustomTimers() ?? []
    
    timers.append(timer)
    
    store(timers)
  }
  
  /// Stores the passed timers.
  /// - Parameter timers: the custom timer configurations to be stored.
  private func store(_ timers: [TimerConfiguration]) {
    let encoder = JSONEncoder()
    if let encodedTimers = try? encoder.encode(timers) {
      defaults.set(encodedTimers, forKey: timersKey)
    }
  }
  
  /// Removes the passed timer, if it's stored.
  func remove(_ timer: TimerConfiguration) {
    guard var timers = getSavedCustomTimers() else { return }
    
    if let index = timers.index(of: timer) {
      timers.remove(at: index)
      store(timers)
    }
  }

  /// Stores the last used timer as the default timer.
  ///
  /// When a user selects a timer to be used, it is marked as the default timer.
  /// When a user opens the app, this default timer is presented.
  ///
  /// - Parameter configuration: The timer to be stored as the default.
  func storeDefaultConfiguration(_ configuration: TimerConfiguration) {
    let encoder = JSONEncoder()
    
    if let encodedTimer = try? encoder.encode(configuration) {
      defaults.set(encodedTimer, forKey: defaultTimerKey)
    }
  }

  /// Returns the last used timer.
  func getDefaultConfiguration() -> TimerConfiguration? {
    var defaultTimer: TimerConfiguration?
    
    if let defaultTimerData = defaults.object(forKey: defaultTimerKey) as? Data {
      let decoder = JSONDecoder()
      defaultTimer = try? decoder.decode(TimerConfiguration.self, from: defaultTimerData)
    }
    
    return defaultTimer
  }
}
