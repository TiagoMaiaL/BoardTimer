//
//  Player.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import Foundation

enum PlayerColor {
  case white
  case black
}

struct Player {
  
  // MARK: Properties
  
  let uid = UUID().uuidString
  let color: PlayerColor
  var remainingTime: TimeInterval = 0

}
