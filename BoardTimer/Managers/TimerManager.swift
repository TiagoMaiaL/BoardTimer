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
  func timerDidStart(timer: TimerManager)
  
  /// Called when the internal timer has stopped
  func timerDidStop(timer: TimerManager)
  
  /// Called every time the internal timer fires
  func timerDidFire(timer: TimerManager)
}

class TimerManager {
  
  /// Enum indicating the two possible fire
  /// delays used by the internal timer.
  enum FireDelay: TimeInterval {
    case normal = 0.1
    case test = 1
  }
 
  // MARK: Properties
  
  /// The interval between each fire event.
  static var fireDelay = FireDelay.normal
  
  /// The internal timer responsible for the fire events.
  private(set) var internalTimer: Timer?
  
  /// The object acting as the delegate.
  var delegate: TimerManagerDelegate?
  
  /// Indicates the current state of the timer.
  var isRunning: Bool {
    return internalTimer != nil
  }
  
  // MARK: Imperatives
  
  /// Starts the internal timer.
  func start() {
    guard internalTimer == nil else { return }
    
    internalTimer = Timer.scheduledTimer(withTimeInterval: TimerManager.fireDelay.rawValue, repeats: true) { [unowned self] _ in
      self.delegate?.timerDidFire(timer: self)
    }
    
    delegate?.timerDidStart(timer: self)
  }
  
  /// Pauses the internal timer.
  func pause() {
    invalidateTimer()
    delegate?.timerDidStop(timer: self)
  }
  
  /// Restarts the internal timer
  func restart() {
    if isRunning {
      invalidateTimer()
    }
    
    start()
  }
  
  /// Invalidates the internal timer.
  private func invalidateTimer() {
    if let timer = internalTimer {
      timer.invalidate()
      internalTimer = nil
    }
  }
  
}
