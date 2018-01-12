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
  
  func getName() -> String {
    return TimerMode.names[self] ?? ""
  }
  
  func getDescription() -> String {
    return TimerMode.description[self] ?? ""
  }
  
  static let names = [
    simple: "Simple",
    fischer: "Fischer",
    bronstein: "Bronstein"
  ]
  
  static let description = [
    simple: "The clock expends the delay period before subtracting from the remaining time. No time from the delay is accumulated.",
    fischer: "The specified increment is added to the clock before the player move.",
    bronstein: "The increment is always added after the player move. Only the amount of delay used by the player is accumulated."
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

struct TimerConfiguration: Codable, Equatable {
 
  // MARK: Properties
  
  let uid = NSUUID().uuidString
  let time: PlayerTime
  let delay: TimeInterval
  let mode: TimerMode
  let name: String?
  
  var description: String {
    get {
      var description = ""
      
      let hours = time.hours
      let minutes = time.minutes
      let seconds = time.seconds
      
      if hours > 0 {
        description += "\(hours) hrs"
      }
      
      if minutes > 0 {
        description += hours > 0 ? ", " : ""
        description += "\(minutes) mins"
      }
      
      if seconds > 0 {
        description += minutes > 0 ? ", " : ""
        description += "\(seconds) secs"
      }
      
      if mode != .none && delay > 0 {
        description += " | \(mode.getName()) \(Int(delay)) secs"
      }
      
      return description
    }
  }
  
  // MARK: Common timer configurations
  
  static func getDefaultConfigurations() -> [TimerConfiguration] {
    return [
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 15, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: "Quick Play"),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 5, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: "Blitz"),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 3, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: "Bullet"),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 1, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: "Lightning"),
    ]
  }
  
  public static func ==(lhs: TimerConfiguration, rhs: TimerConfiguration) -> Bool {
    return lhs.uid == rhs.uid ||
           lhs.name == rhs.name
  }
}
