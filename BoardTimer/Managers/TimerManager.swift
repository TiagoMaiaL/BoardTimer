//
//  TimerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

protocol TimerManagerDelegate {
  
  /// Called when the internal timer has started
  func timerHasStarted(manager: TimerManager)
  
  /// Called when the internal timer has stopped
  func timerHasStopped(manager: TimerManager)
  
  /// Called every time the internal timer fires
  func timerHasFired(manager: TimerManager)
}

class TimerManager {
  
  // MARK: Constants
  
  static let fireDelay: TimeInterval = 0.1
  
  // MARK: Properties
  
  private(set) var internalTimer: Timer?
  var delegate: TimerManagerDelegate?
  
  /// Indicates the current state of the timer.
  var isRunning: Bool {
    return internalTimer != nil
  }
  
  // MARK: Imperatives
  
  /// Starts the internal timer.
  func start() {
    guard internalTimer == nil else { return }
    
    internalTimer = Timer.scheduledTimer(withTimeInterval: TimerManager.fireDelay, repeats: true) { [unowned self] _ in
      self.delegate?.timerHasFired(manager: self)
    }
    
    delegate?.timerHasStarted(manager: self)
  }
  
  /// Pauses the internal timer.
  func pause() {
    invalidateTimer()
    delegate?.timerHasStopped(manager: self)
  }
  
  /// Restarts the internal timer
  func restart() {
    if isRunning {
      invalidateTimer()
    }
    
    start()
  }
  
  private func invalidateTimer() {
    if let timer = internalTimer {
      timer.invalidate()
      internalTimer = nil
    }
  }
  
}
