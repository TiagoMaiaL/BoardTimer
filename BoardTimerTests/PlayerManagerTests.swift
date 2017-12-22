//
//  PlayerManagerTests.swift
//  BoardTimerTests
//
//  Created by Tiago Maia Lopes on 12/5/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import XCTest
@testable import BoardTimer

class PlayerManagerTests: XCTestCase, PlayerManagerDelegate {
  
  // MARK: Properties
  
  let defaultConfig = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 0, seconds: 2),
                                         delay: 2,
                                         mode: .none,
                                         name: nil)
  
  var changeExpectation: XCTestExpectation?
  var timeOutExpectation: XCTestExpectation?
  var decreaseExpectation: XCTestExpectation?
  var nearFinishExpectation: XCTestExpectation?
  
  // MARK: Factory methods
  
  func getManager(with config: TimerConfiguration) -> PlayerManager {
    let timerManager = TimerManager()
    let whitePlayer = Player(color: .white, configuration: config)
    let blackPlayer = Player(color: .black, configuration: config)
    
    let playerManager = PlayerManager(timer: timerManager,
                                      white: whitePlayer,
                                      black: blackPlayer)
    playerManager.delegate = self
    
    return playerManager
  }
  
  // MARK: Setup/Teardown
  
  override func setUp() {
    super.setUp()
    TimerManager.fireDelay = .test
  }
  
  override func tearDown() {
    changeExpectation = nil
    timeOutExpectation = nil
    decreaseExpectation = nil
    nearFinishExpectation = nil
    
    TimerManager.fireDelay = .normal
    
    super.tearDown()
  }
  
  // MARK: Tests
  
  func testTogglePlayer() {
    let manager = getManager(with: defaultConfig)
    
    XCTAssertEqual(manager.currentPlayer.color, .white)
    
    changeExpectation = expectation(description: "Player change delegate call")
    manager.toggleCurrentPlayer()
    
    waitForExpectations(timeout: 1)
    
    XCTAssertEqual(manager.currentPlayer.color, .black)
  }
  
  func testDecreaseFromCurrentPlayer() {
    let manager = getManager(with: defaultConfig)
    
    decreaseExpectation = expectation(description: "Decrease remaining time delegate call")
    manager.decreaseRemainingTime()
    
    waitForExpectations(timeout: 1)
    
    XCTAssertLessThan(manager.currentPlayer.remainingTime, defaultConfig.time.timeInterval)
  }
  
  func testPlayerTimeIsOver() {
    let config = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 0, seconds: 1),
                                    delay: 0,
                                    mode: .none,
                                    name: nil)
    
    let manager = getManager(with: config)
    
    timeOutExpectation = expectation(description: "Timer is over delegate call")
    
    manager.decreaseRemainingTime()
    manager.decreaseRemainingTime()
    
    waitForExpectations(timeout: 1)
  }
  
  // MARK: PlayerManager delegate methods
  
  func playerHasChanged(currentPlayer: Player) {
    changeExpectation?.fulfill()
  }
  
  func playerTimeHasRanOver(player: Player) {
    timeOutExpectation?.fulfill()
  }
  
  func playerTimeHasDecreased(player: Player) {
    decreaseExpectation?.fulfill()
  }
  
  func playerTimeIsNearFinish(player: Player) {
    nearFinishExpectation?.fulfill()
  }
  
}
