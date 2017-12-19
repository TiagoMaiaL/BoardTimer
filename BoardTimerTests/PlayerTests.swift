//
//  PlayerTests.swift
//  BoardTimerTests
//
//  Created by Tiago Maia Lopes on 12/5/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import XCTest
@testable import BoardTimer

class PlayerTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testPlayerDescreaseTime() {
    let config = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 2, seconds: 0),
                                    delay: 3,
                                    mode: .none,
                                    name: nil)
    let player = Player(color: .white, configuration: config)
    
    player.startTurn()
    player.decreaseTime()
    XCTAssertEqual(player.remainingTime, (2 * 60) - 1)
  }
  
  func testPlayerDescreaseTimeWithSimpleMode() {
    let config = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 2, seconds: 0),
                                    delay: 3,
                                    mode: .simple,
                                    name: nil)
    let player = Player(color: .white, configuration: config)
    
    // Checking the delay amount. Simple mode.
    player.startTurn()

    for _ in 0...2 {
      player.decreaseTime()
    }
    
    XCTAssertEqual(player.delayTime, 0)
    
    // Checking the remaing time after the delay amount become 0.
    player.decreaseTime()
    
    XCTAssertEqual(player.remainingTime, (2 * 60) - 1)
  }
  
  func testPlayerTurnWithBronsteinMode() {
    let delayAmount: Double = 3
    
    let config = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 2, seconds: 0),
                                    delay: delayAmount,
                                    mode: .bronstein,
                                    name: nil)
    let player = Player(color: .white, configuration: config)
    
    player.startTurn()
    player.decreaseTime()
    player.passTurn()
    
    // Checking the remaing time after the bronstrein increment is applied.
    XCTAssertEqual(player.remainingTime, (2 * 60) + (delayAmount - (delayAmount - 1)))
  }
  
  func testPlayerTurnWithFiscerMode() {
    let delayAmount: Double = 4
    
    let config = TimerConfiguration(time: PlayerTime(hours: 0, minutes: 2, seconds: 0),
                                    delay: delayAmount,
                                    mode: .fischer,
                                    name: nil)
    let player = Player(color: .white, configuration: config)
    
    player.startTurn()
    
    // Checking the remaing time after the fischer increment is applied.
    XCTAssertEqual(player.remainingTime, (2 * 60) + delayAmount)
  }
  
}
