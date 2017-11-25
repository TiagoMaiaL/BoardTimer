//
//  PlayerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/12/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

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
  
  let timer: TimerManager
  private(set) var whitePlayer: Player
  private(set) var blackPlayer: Player
  
  private(set) var currentPlayer: Player
  
  var delegate: PlayerManagerDelegate?
  
  // MARK: Initializers
  
  init(timer: TimerManager, white: Player, black: Player) {
    self.timer = timer
    whitePlayer = white
    blackPlayer = black
    
    currentPlayer = whitePlayer
  }
  
  // MARK: Imperatives
  
  /// Toggles the current player between the two handled players.
  func toggleCurrentPlayer() {
    currentPlayer.passTurn()
    
    switch currentPlayer.color {
    case .white:
      currentPlayer = blackPlayer
    case .black:
      currentPlayer = whitePlayer
    }

    currentPlayer.startTurn()
    delegate?.playerHasChanged(currentPlayer: currentPlayer)
  }
  
  /// Decreases by one the remaining time from the current player.
  /// If there's no time to decrease, we call the delegate's playerTimeHasRanOver
  /// method and return.
  func decreaseRemainingTime() {
    if currentPlayer.isOver {
      delegate?.playerTimeHasRanOver(player: currentPlayer)
      return
    }
    
    currentPlayer.decreaseTime()
    delegate?.playerTimeHasDecreased(player: currentPlayer)
  }
  
}
