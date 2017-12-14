//
//  TimerConfigurationStorageTests.swift
//  BoardTimerTests
//
//  Created by Tiago Maia Lopes on 12/6/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import XCTest
@testable import BoardTimer

class TimerConfigurationStorageTests: XCTestCase {
  
  // MARK: Factory methods
  
  func getTimerConfigurationStorage() -> TimerConfigurationStorage {
    return TimerConfigurationStorage()
  }
  
  // MARK: Setup/Teardown
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Tests
  
  func testStorageAndRetrieval() {
    let configuration = TimerConfiguration(time: 2, delay: 2, mode: .none, name: "testing")
    let storage = getTimerConfigurationStorage()
    
    storage.clear()
    storage.store(configuration)
    
    guard let storedConfiguration = storage.getSavedCustomTimers()?.first else {
      XCTFail("No timer configuration could be retrieved from the storage")
      return
    }
    
    // TODO: Use equatable in the timer configuration struct.
    XCTAssertEqual(configuration.name, storedConfiguration.name)
    XCTAssertEqual(configuration.time, storedConfiguration.time)
    XCTAssertEqual(configuration.mode, storedConfiguration.mode)
    XCTAssertEqual(configuration.delay, storedConfiguration.delay)
  }
  
  func testStorageLastUsed() {
    let configuration = TimerConfiguration(time: 2, delay: 2, mode: .none, name: "testing default config.")
    let storage = getTimerConfigurationStorage()
    
    storage.storeDefaultConfiguration(configuration)
    
    guard let defaultConfiguration = storage.getDefaultConfiguration() else {
      XCTFail("No default configuration could be retrieved from the storage")
      return
    }
    
    XCTAssertEqual(configuration.name, defaultConfiguration.name)
  }
}
