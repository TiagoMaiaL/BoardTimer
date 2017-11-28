//
//  TimerConfiguration.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/24/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

enum TimerMode: Int {
  case simple = 0, fischer, bronstein, suddenDeath
  
  // TODO: Add the explanation.
  // TODO: Add the name.
}


class TimerConfiguration: NSObject {
 
  // MARK: Properties
  
  let time: TimeInterval
  let delay: TimeInterval
  let mode: TimerMode
  let name: String
  
  // MARK: Init
  
  init(name: String, time: TimeInterval, delay: TimeInterval, mode: TimerMode) {
    self.name = name
    self.time = time
    self.delay = delay
    self.mode = mode
  }
  
  // MARK: Common timer configurations
  
  static func getDefaultConfigurations() -> [TimerConfiguration] {
    return [
      TimerConfiguration(name: "Quick Play", time: 15, delay: 0, mode: .simple),
      TimerConfiguration(name: "Blitz", time: 5, delay: 0, mode: .simple),
      TimerConfiguration(name: "Bullet", time: 3, delay: 5, mode: .fischer),
      TimerConfiguration(name: "Lightning", time: 1, delay: 0, mode: .simple),
    ]
  }
}
