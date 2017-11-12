//
//  PlayerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/12/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

typealias PlayerConfiguration = (timeAmount: TimeInterval, playIncrease: TimeInterval)

protocol PlayerManagerDelegate {
  
  /// Called when the player has changed
  func playerHasChanged(currentPlayer: Player)
  
  /// Called when the player's remaining time has ran over
  func playerTimeHasRanOver(player: Player)
  
  /// Called when the player's remaining time has been decreased.
  func playerTimeHasDecreased(player: Player)
}

class PlayerManager {
  
  // MARK: Properties
  
  let configuration: PlayerConfiguration
  let timer: TimerManager
  private(set) var whitePlayer: Player
  private(set) var blackPlayer: Player
  
  private(set) var currentPlayer: Player
  
  var delegate: PlayerManagerDelegate?
  
  // MARK: Initializers
  
  init(configuration: PlayerConfiguration, timer: TimerManager, white: Player, black: Player) {
    self.configuration = configuration
    self.timer = timer
    whitePlayer = white
    blackPlayer = black
    
    currentPlayer = whitePlayer
    
    whitePlayer.remainingTime = configuration.timeAmount
    blackPlayer.remainingTime = configuration.timeAmount
  }
  
  // MARK: Imperatives
  
  /// Toggles the current player between the two handled players.
  func toggleCurrentPlayer() {
    switch currentPlayer.color {
    case .white:
      currentPlayer = blackPlayer
    case .black:
      currentPlayer = whitePlayer
    }
    
    delegate?.playerHasChanged(currentPlayer: currentPlayer)
  }
  
  /// Decreases by one the remaining time from the current player.
  /// If there's not time to decrease, we call the delegate's playerTimeHasRanOver
  /// method and return.
  func decreaseRemainingTime() {
    if currentPlayer.remainingTime <= 0 {
      delegate?.playerTimeHasRanOver(player: currentPlayer)
      return
    }
    
    currentPlayer.remainingTime -= 1
    delegate?.playerTimeHasDecreased(player: currentPlayer)
  }
  
  /// Increases the current player's remaning time by the configured
  /// amount passed in the configuration object.
  func playIncreaseRemainingTime() {
    currentPlayer.remainingTime += configuration.playIncrease
  }
  
}
