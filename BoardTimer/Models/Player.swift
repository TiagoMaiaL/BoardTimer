//
//  Player.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

enum PlayerColor {
  case white
  case black
}

class Player {
  
  // MARK: Properties
  
  let uid = UUID().uuidString
  let color: PlayerColor
  let configuration: TimerConfiguration
  
  private(set) var remainingTime: TimeInterval = 0
  private(set) var delayTime: TimeInterval = 0
  
  var isOver: Bool {
    return remainingTime == 0
  }
  
  // MARK: Initializers
  
  init(color: PlayerColor, configuration: TimerConfiguration) {
    self.color = color
    self.configuration = configuration
    
    remainingTime = configuration.time * 60
    delayTime = configuration.delay
  }
  
  // MARK: Imperatives
  
  func decreaseTime() {
    if isOver {
      return
    }
    
    if configuration.mode == .simple && delayTime > 0 {
      delayTime -= 1
    } else {
      remainingTime -= 1
    }
  }
  
  func pass() {
    delayTime = configuration.delay
    
//    remainingTime += delayTime
  }
  
}
