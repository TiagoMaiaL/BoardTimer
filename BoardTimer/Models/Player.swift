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

// TODO: Put this as a internal type of the Player.
struct PlayerTime: Equatable, Codable {
  let hours: Int
  let minutes: Int
  let seconds: Int
  
  var timeInterval: TimeInterval {
    get {
      return TimeInterval((hours * 60 * 60) + (minutes * 60) + seconds)
    }
  }
  
  public static func ==(lhs: PlayerTime, rhs: PlayerTime) -> Bool {
    return lhs.hours == rhs.hours &&
           lhs.minutes == rhs.minutes &&
           lhs.seconds == rhs.seconds
  }
  
}

class Player {
  
  // MARK: Properties
  
  let uid = UUID().uuidString
  let color: PlayerColor
  let configuration: TimerConfiguration
  
  private(set) var lastIncreasedRemainingTime: TimeInterval = 0
  private(set) var remainingTime: TimeInterval = 0
  private(set) var delayTime: TimeInterval = 0
  private(set) var moves = 0
  
  var progress: Float {
    get {
      // TODO: Fix this.
      let configuredTime = configuration.time.timeInterval
      let baseTime = max(configuredTime, remainingTime, lastIncreasedRemainingTime)
      let progress = Float((baseTime - remainingTime) / baseTime)
      
      return progress
    }
  }
  
  var isOver: Bool {
    return remainingTime <= 0
  }
  
  var isNearFinish: Bool {
    return remainingTime <= 20
  }
  
  // MARK: Initializers
  
  init(color: PlayerColor, configuration: TimerConfiguration) {
    self.color = color
    self.configuration = configuration
    
    remainingTime = configuration.time.timeInterval
    delayTime = configuration.delay
  }
  
  // MARK: Imperatives
  
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
  
  func startTurn() {
    if configuration.mode == .fischer {
      remainingTime += delayTime
      lastIncreasedRemainingTime = remainingTime
    }
  }
  
  func passTurn() {
    moves += 1
    
    if configuration.mode == .bronstein {
      remainingTime += configuration.delay - delayTime
      lastIncreasedRemainingTime = remainingTime
    }
    
    delayTime = configuration.delay
  }
  
}
