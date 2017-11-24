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
  
  let remainingTime: TimeInterval
  let delay: TimeInterval
  // TODO: Add the types of delay to be added after the pass action.
  let name: String
  
  // MARK: Init
  
  init(name: String, remainingTime: TimeInterval, delay: TimeInterval) {
    self.name = name
    self.remainingTime = remainingTime
    self.delay = delay
  }
  
  // MARK: Common timer configurations
  
  static func getDefaultConfigurations() -> [TimerConfiguration] {
    return [
      TimerConfiguration(name: "Active", remainingTime: 30, delay: 0),
      TimerConfiguration(name: "Rapid", remainingTime: 15, delay: 0),
      TimerConfiguration(name: "Blitz", remainingTime: 5, delay: 0),
      TimerConfiguration(name: "Bullet", remainingTime: 3, delay: 0),
      TimerConfiguration(name: "Lightning", remainingTime: 1, delay: 0),
    ]
  }
}
