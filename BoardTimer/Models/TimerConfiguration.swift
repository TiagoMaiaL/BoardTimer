//
//  TimerConfiguration.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/24/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// A struct representing a timer configuration.
///
/// A timer configuration consists of:
/// * An identifier
/// * An optional name
/// * A time amount(for each player)
/// * An optional mode(fischer, simple, etc...)
/// * An associated delay to apply according to the chosen mode
struct TimerConfiguration: Codable, Equatable, CustomStringConvertible {
  
  /// The available timer modes.
  enum Mode: Int, Codable, CustomStringConvertible {
    case simple
    case fischer
    case bronstein
    
    /// Returns the name of the mode instance.
    func getName() -> String {
      return Mode.names[self] ?? ""
    }

    // MARK: Mode CustomStringConvertible implementation.
    
    /// The description for the current instance.
    var description: String {
      switch self {
      case .simple:
        return NSLocalizedString("The clock expends the delay period before subtracting from the remaining time. No time from the delay is accumulated.", comment: "Timer Configuration: Simple mode description.")
      case .fischer:
        return NSLocalizedString("The specified increment is added to the clock before the player move.", comment: "Timer Configuration: Fischer mode description.")
      case .bronstein:
        return NSLocalizedString("The increment is always added after the player move. Only the amount of delay used by the player is accumulated.", comment: "Timer Configuration: Bronstein mode description.")
      }
    }
    
    /// The name for each enum instance.
    static let names = [
      simple: NSLocalizedString("Simple", comment: "Timer Configuration: Simple mode name"),
      fischer: NSLocalizedString("Fischer", comment: "Timer Configuration: Fischer mode name"),
      bronstein: NSLocalizedString("Bronstein", comment: "Timer Configuration: Bronstein mode name")
    ]
    
    /// Returns an instance from the mode name.
    static func get(from modeName: String) -> Mode? {
      switch modeName {
      case names[.simple]!:
        return .simple
      case names[.fischer]!:
        return .fischer
      case names[.bronstein]!:
        return .bronstein
      default:
        return nil
      }
    }
  }
  
  // MARK: Properties
  
  /// The timer's identifier.
  let uid = NSUUID().uuidString
  
  /// The timer for each player.
  let time: PlayerTime
  
  /// The amount of delay, depending on the timer mode.
  let delay: TimeInterval
  
  /// The mode configured for the current timer.
  let mode: Mode?
  
  /// An optional name for the timer.
  let name: String?
  
  // MARK: Timer Configuration CustomStringConvertible implementation.
  
  /// Returns a description of the timer, indicating it's configured time.
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
      
      if let mode = mode {
        description += " | \(mode.getName()) " + String.localizedStringWithFormat(
          NSLocalizedString("%d sec(s)", comment: "Timer Configuration: Amount of seconds in the timer configuration"),
          Int(delay)
        )
      }
      
      return description
    }
  }
  
  // MARK: Common timer configurations
  
  /// Returns the default timers.
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
  
  // MARK: Equatable protocol implementation.
  public static func ==(lhs: TimerConfiguration, rhs: TimerConfiguration) -> Bool {
    return lhs.uid == rhs.uid ||
           lhs.name == rhs.name
  }
}
