//
//  TimerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

typealias TimerConfiguration = (amount: Int, increase: Int)

class TimerManager {
  
  // MARK: Properties
  
  private let configuration: TimerConfiguration
  
  private let whitePlayer: Player
  private let blackPlayer: Player
  
  private var currentPlayer: Player?
  
  private var timer: Timer?
  
  // MARK: Initializers
  
  init(first whitePlayer: Player, second blackPlayer: Player, configuration: TimerConfiguration) {
    self.whitePlayer = whitePlayer
    self.blackPlayer = blackPlayer
    self.configuration = configuration
  }
  
  // MARK: Imperatives
  
  func startTimer() {
    guard timer == nil else { return }
    
    currentPlayer = whitePlayer
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      
    }
  }
  
  func pauseTimer() {
    if let timer = timer {
      timer.invalidate()
      self.timer = nil
    }
  }
  
  func changePlayer() {
    
  }
  
}
