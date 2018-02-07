//
//  Player.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

// TODO: Remove this enum from here, put this in the controller.
enum PlayerColor {
  case white
  case black
}

// TODO: this class should be a struct.
/// A model class representing a player.
///
/// - Note: This class is responsible for the following business logic:
/// * Decreasing the player's remaining time
/// * Applying the configured delay according to the timer mode.
class Player {

  /// A player time struct associated with a given configuration.
  struct Time: Equatable, Codable {
    /// Amount of hours.
    let hours: Int
    
    /// Amount of minutes.
    let minutes: Int
    
    /// Amount of seconds.
    let seconds: Int
    
    // TODO: Properly name this property.
    /// The time in seconds.
    var timeInterval: TimeInterval {
      get {
        return TimeInterval((hours * 60 * 60) + (minutes * 60) + seconds)
      }
    }
    
    // MARK: Time Equatable implementation
    
    public static func ==(lhs: Time, rhs: Time) -> Bool {
      return lhs.hours == rhs.hours &&
        lhs.minutes == rhs.minutes &&
        lhs.seconds == rhs.seconds
    }
  }
  
  // MARK: Properties
  
  /// The player's identifier.
  let uid = UUID().uuidString
  
  // TODO: Remove this color.
  let color: PlayerColor
  
  /// The player's associated timer configuration.
  let configuration: TimerConfiguration
  
  /// TODO: ?? Name isn't good enough.
  private(set) var lastIncreasedRemainingTime: TimeInterval = 0
  
  /// The player's remaining time.
  private(set) var remainingTime: TimeInterval = 0
  
  /// The amount of delay being used in a particular move.
  private var delayTime: TimeInterval = 0
  
  /// The amount of moves made by the player.
  private(set) var moves = 0
  
  /// The amount of time used by the player as a progress percentage factor.
  var progress: Float {
    get {
      // TODO: Fix this.
      let configuredTime = configuration.time.timeInterval
      let baseTime = max(configuredTime, remainingTime, lastIncreasedRemainingTime)
      let progress = Float((baseTime - remainingTime) / baseTime)
      
      return progress
    }
  }
  
  /// The formatted remaining time.
  public var formattedRemainingTime: String {
    var formattedText = ""
    
    let hours = Int(remainingTime / (60 * 60))
    let minutes = Int(remainingTime.truncatingRemainder(dividingBy: 60 * 60) / 60)
    let seconds = remainingTime.truncatingRemainder(dividingBy: 60)
    
    if hours > 0 {
      formattedText += "\(String(format: "%02d", hours)):"
    }
    
    if minutes > 0 {
      formattedText += "\(String(format: "%02d", minutes)):"
    }
    
    if isNearFinish {
      if remainingTime <= 0 {
        formattedText += "0.0"
      } else {
        formattedText += "\(String(format: "%.1f", abs(seconds)))"
      }
    } else {
      formattedText += "\(String(format: "%02d", Int(seconds)))"
    }
    
    return formattedText
  }
  
  /// The formatted moves text.
  public var formattedMovesText: String {
    return String.localizedStringWithFormat(NSLocalizedString("%d move(s)",
                                                              comment: "Timer Controller: Moves label text"),
                                            moves)
  }
  
  /// Property indicating if the player's remaining time has ended or not.
  var isOver: Bool {
    return remainingTime <= 0
  }
  
  /// Property indicating if the player's remaining time is now less than 20 secs.
  var isNearFinish: Bool {
    return remainingTime <= 20
  }
  
  // MARK: Initializers
  
  // TODO: Remove the player color.
  init(color: PlayerColor, configuration: TimerConfiguration) {
    self.color = color
    self.configuration = configuration
    
    remainingTime = configuration.time.timeInterval
    delayTime = configuration.delay
  }
  
  // MARK: Imperatives
  
  /// Decreases the remaining time of the player, according
  /// to the timer configured values for the mode
  /// and a delay to be decreased.
  public func decreaseTime() {
    if isOver {
      return
    }
    
    if delayTime > 0 &&
       configuration.mode == .simple ||
       configuration.mode == .bronstein {
      delayTime -= TimerManager.fireDelay.rawValue
    } else {
      remainingTime -= TimerManager.fireDelay.rawValue
    }
  }
  
  /// Starts player's turn.
  ///
  /// - Note: This method should be always called before
  ///         decreasing the player's remaning time.
  func startTurn() {
    if configuration.mode == .fischer {
      remainingTime += delayTime
      lastIncreasedRemainingTime = remainingTime
    }
  }
  
  /// Passes the player's turn.
  func passTurn() {
    moves += 1
    
    if configuration.mode == .bronstein {
      remainingTime += configuration.delay - delayTime
      lastIncreasedRemainingTime = remainingTime
    }
    
    delayTime = configuration.delay
  }
  
}
