//
//  PlayerManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/12/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerManagerDelegate {
  
  /// Called when the player has changed
  func playerDidChange(_ currentPlayer: Player)
  
  /// Called when the player's remaining time has ran over
  func playerTimeDidEnd(_ player: Player)
  
  /// Called when the player's remaining time has been decreased.
  func playerTimeDidDecrease(_ player: Player)
  
  /// Called when the player's remainig time is now under 20 secs.
  func playerTimeWillFinish(_ player: Player)
}

class PlayerManager {
  
  // MARK: Properties
  
  /// The white player struct.
  private(set) var whitePlayer: Player
  
  /// The black player struct.
  private(set) var blackPlayer: Player
  
  /// The current player making the move
  /// and having the time decreased.
  private(set) var currentPlayer: Player
  
  /// The manager's delegate.
  var delegate: PlayerManagerDelegate?
  
  /// Property used to inform if the timer is over.
  var isTimerOver: Bool {
    get {
      return whitePlayer.isOver || blackPlayer.isOver
    }
  }
  
  /// Variable used to ensure the delegate's warning method
  /// is going to be called only once per player.
  private var didWarnPlayer = [
    PlayerColor.white : false,
    PlayerColor.black : false,
  ]
  
  // MARK: Initializers
  
  init(white: Player, black: Player) {
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
    delegate?.playerDidChange(currentPlayer)
  }
  
  /// Decreases by one the remaining time from the current player.
  /// If there's no time to decrease, we call the delegate's playerTimeHasRanOver
  /// method and return.
  func decreaseRemainingTime() {
    if currentPlayer.isOver {
      delegate?.playerTimeDidEnd(currentPlayer)
      return
    }
    
    if currentPlayer.isNearFinish && didWarnPlayer[currentPlayer.color]! == false {
      delegate?.playerTimeWillFinish(currentPlayer)
      didWarnPlayer[currentPlayer.color] = true
    }
    
    currentPlayer.decreaseTime()
    delegate?.playerTimeDidDecrease(currentPlayer)
  }
  
}
