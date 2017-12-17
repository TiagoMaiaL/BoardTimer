//
//  TimerConfiguration.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/24/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

enum TimerMode: Int, Codable {
  case none = 0, simple, fischer, bronstein, suddenDeath
  
  // TODO: Add the explanation.
  // TODO: Add the name.
  
  static func get(from modeName: String) -> TimerMode {
    return TimerMode(rawValue: 0)!
  }
}

struct TimerConfiguration: Codable {
 
  // MARK: Properties
  
  let time: TimeInterval
  let delay: TimeInterval
  let mode: TimerMode
  let name: String?
  
  // MARK: Common timer configurations
  
  static func getDefaultConfigurations() -> [TimerConfiguration] {
    return [
      TimerConfiguration(time: 15, delay: 0, mode: .simple, name: "Quick Play"),
      TimerConfiguration(time: 5, delay: 0, mode: .simple, name: "Blitz"),
      TimerConfiguration(time: 3, delay: 5, mode: .fischer, name: "Bullet"),
      TimerConfiguration(time: 1, delay: 0, mode: .simple, name: "Lightning"),
    ]
  }
}
