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
    simple: NSLocalizedString("Simple", comment: "Timer Configuration: Simple mode name"),
    fischer: NSLocalizedString("Fischer", comment: "Timer Configuration: Fischer mode name"),
    bronstein: NSLocalizedString("Bronstein", comment: "Timer Configuration: Bronstein mode name")
  ]
  
  static let description = [
    simple: NSLocalizedString("The clock expends the delay period before subtracting from the remaining time. No time from the delay is accumulated.", comment: "Timer Configuration: Simple mode description."),
    fischer: NSLocalizedString("The specified increment is added to the clock before the player move.", comment: "Timer Configuration: Fischer mode description."),
    bronstein: NSLocalizedString("The increment is always added after the player move. Only the amount of delay used by the player is accumulated.", comment: "Timer Configuration: Bronstein mode description.")
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
        description += String.localizedStringWithFormat(
          NSLocalizedString("%d hr(s)", comment: "Timer Configuration: Amount of hours in the timer configuration"),
          hours
        )
      }
      
      if minutes > 0 {
        description += hours > 0 ? ", " : ""
        description += String.localizedStringWithFormat(
          NSLocalizedString("%d min(s)", comment: "Timer Configuration: Amount of minutes in the timer configuration"),
          minutes
        )
      }
      
      if seconds > 0 {
        description += minutes > 0 ? ", " : ""
        description += String.localizedStringWithFormat(
          NSLocalizedString("%d sec(s)", comment: "Timer Configuration: Amount of seconds in the timer configuration"),
          seconds
        )
      }
      
      if mode != .none && delay > 0 {
        description += " | \(mode.getName()) " + String.localizedStringWithFormat(
          NSLocalizedString("%d sec(s)", comment: "Timer Configuration: Amount of seconds in the timer configuration"),
          Int(delay)
        )
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
                         name: NSLocalizedString("Quick Play", comment: "Timer Configuration: Quick Play configuration name.")),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 5, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: NSLocalizedString("Blitz", comment: "Timer Configuration: Blitz configuration name.")),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 3, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: NSLocalizedString("Bullet", comment: "Timer Configuration: Bullet configuration name.")),
      TimerConfiguration(time: PlayerTime(hours: 0, minutes: 1, seconds: 0),
                         delay: 0,
                         mode: .none,
                         name: NSLocalizedString("Lightning", comment: "Timer Configuration: Lightning configuration name.")),
    ]
  }
  
  public static func ==(lhs: TimerConfiguration, rhs: TimerConfiguration) -> Bool {
    return lhs.uid == rhs.uid ||
           lhs.name == rhs.name
  }
}
