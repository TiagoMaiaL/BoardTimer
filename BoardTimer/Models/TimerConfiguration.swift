//
//  TimerConfiguration.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/24/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class TimerConfiguration: NSObject {
 
  // MARK: Properties
  
  let time: TimeInterval
  let delay: TimeInterval
  // TODO: Add the types of delay to be added after the pass action.
  let name: String
  
  // MARK: Init
  
  init(name: String, time: TimeInterval, delay: TimeInterval) {
    self.name = name
    self.time = time
    self.delay = delay
  }
  
  // MARK: Common timer configurations
  
  static func getDefaultConfigurations() -> [TimerConfiguration] {
    return [
      TimerConfiguration(name: "Active", time: 30, delay: 0),
      TimerConfiguration(name: "Rapid", time: 15, delay: 0),
      TimerConfiguration(name: "Blitz", time: 5, delay: 0),
      TimerConfiguration(name: "Bullet", time: 3, delay: 0),
      TimerConfiguration(name: "Lightning", time: 1, delay: 0),
    ]
  }
}
