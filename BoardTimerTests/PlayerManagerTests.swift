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
  
  let config = TimerConfiguration(time: 2, delay: 2, mode: .none, name: nil)
  var delegateExpectation: XCTestExpectation?
  
  // MARK: Factory methods
  
  func getManager() -> PlayerManager {
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
  }
  
  override func tearDown() {
    delegateExpectation = nil
    super.tearDown()
  }
  
  // MARK: Tests
  
  func testTogglePlayer() {
    let manager = getManager()
    
    XCTAssertEqual(manager.currentPlayer.color, .white)
    
    delegateExpectation = expectation(description: "Player change delegate call")
    manager.toggleCurrentPlayer()
    
    waitForExpectations(timeout: 1)
    
    XCTAssertEqual(manager.currentPlayer.color, .black)
  }
  
  func testDecreaseFromCurrentPlayer() {
    let manager = getManager()
    
    delegateExpectation = expectation(description: "Decrease remaining time delegate call")
    manager.decreaseRemainingTime()
    
    waitForExpectations(timeout: 1)
    
    XCTAssertLessThan(manager.currentPlayer.remainingTime, config.time * 60)
  }
  
  func testPlayerTimeIsOver() {
    // TODO: Refactor timerConfiguration to receive number of seconds instead of number of minutes
//    let timerManager = timerManager()
//    let configuration = TimerConfiguration(
//    let whitePlayer = Player(color: .white, configuration: config)
//    let blackPlayer = Player(color: .black, configuration: config)
//
//    let manager = PlayerManager(timer: timerManager,
//                                white: whitePlayer,
//                                black: blackPlayer)
//
//    delegateExpectation = expectation(description: "Timer is over delegate call")
//    manager.decreaseRemainingTime()
  }
  
  // MARK: PlayerManager delegate methods
  
  func playerHasChanged(currentPlayer: Player) {
    delegateExpectation?.fulfill()
  }
  
  func playerTimeHasRanOver(player: Player) {
    delegateExpectation?.fulfill()
  }
  
  func playerTimeHasDecreased(player: Player) {
    delegateExpectation?.fulfill()
  }
  
}
