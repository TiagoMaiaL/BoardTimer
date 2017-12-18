//
//  TimerConfiguration.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/24/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

enum TimerMode: Int, Codable {
  case none = 0, simple, fischer, bronstein
  
  func getDescription() -> String {
    return TimerMode.description[self] ?? ""
  }
  
  static let names = [
    simple: "Simple",
    fischer: "Fischer",
    bronstein: "Bronstein"
  ]
  
  static let description = [
    // TODO: Put the correct description.
    simple: "The clock expends the delay period before subtracting from the remaining time.",
    fischer: "A specified increment is added to the clock before the player move.",
    bronstein: "The increment is always added after the player move. ..."
  ]
  
  static func get(from modeName: String) -> TimerMode {
    switch modeName {
    case names[.simple]!:
      return .simple
    case names[.fischer]!:
      return .fischer
    case names[.bronstein]!:
      return .bronstein
    default:
      return .none
    }
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
