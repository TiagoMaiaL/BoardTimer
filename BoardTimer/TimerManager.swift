//
//  TimerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

typealias TimerConfiguration = (amount: TimeInterval, increase: TimeInterval)

protocol TimerManagerDelegate {
  
  /// Called when the internal timer has started
  func timerHasStarted(manager: TimerManager)
  
  /// Called when the internal timer has stopped
  func timerHasStopped(manager: TimerManager)
  
  /// Called every time the internal timer fires
  func timerHasFired(manager: TimerManager)
}

class TimerManager {
  
  // MARK: Properties
  
  let configuration: TimerConfiguration
  private(set) var internalTimer: Timer?
  var delegate: TimerManagerDelegate?
  
  // MARK: Initializers
  
  init(configuration: TimerConfiguration) {
    self.configuration = configuration
  }
  
  // MARK: Imperatives
  
  /// Starts the internal timer.
  func start() {
    guard internalTimer == nil else { return }
    
    internalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
      self.delegate?.timerHasFired(manager: self)
    }
    
    delegate?.timerHasStarted(manager: self)
  }
  
  /// Pauses the internal timer.
  func pause() {
    if let timer = internalTimer {
      timer.invalidate()
      internalTimer = nil
      
      delegate?.timerHasStopped(manager: self)
    }
  }
  
  /// Returns whether the timer is running.
  func isRunning() -> Bool {
    return internalTimer != nil
  }
  
}
