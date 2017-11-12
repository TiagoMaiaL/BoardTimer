//
//  ViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet weak var whitePlayerLabel: UILabel!
  
  private var timerManager: TimerManager!
  
  private var whitePlayer = Player(color: .white, remainingTime: 60 * 2)
  private var blackPlayer = Player(color: .black, remainingTime: 60 * 2)
  private var currentColor: PlayerColor?
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    configureTimer()
  }
  
  // MARK: Imperatives
  
  func configureTimer() {    
    let configuration = (amount: TimeInterval(60 * 2),
                         increase: TimeInterval(12))
    
    timerManager = TimerManager(configuration: configuration)
    timerManager.delegate = self
    
    currentColor = .white
  }
  
  func toggleColor() {
    guard let color = currentColor else { return }
    
    switch color {
    case .white:
      currentColor = .black
    case .black:
      currentColor = .white
    }
  }
  
  func getPlayer(with color: PlayerColor) -> Player? {
    let player: Player!
    
    switch color {
    case .white:
      player = whitePlayer
    case .black:
      player = blackPlayer
    }
    
    return player
  }
  
  func getFormattedRemainingTime(for player: Player) -> String {
    let remainingTime = player.remainingTime
    let minutes = Int(remainingTime / 60)
    let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
    
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }
}

// MARK: Actions

extension ViewController {
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    if !timerManager.isRunning() {
      timerManager.start()
    } else {
      toggleColor()
    }
  }

}

// MARK: TimerManagerDelegate

extension ViewController: TimerManagerDelegate {
  
  func timerHasStarted(manager: TimerManager) {
    
  }
  
  func timerHasStopped(manager: TimerManager) {
    
  }
  
  func timerHasFired(manager: TimerManager) {
    guard let color = currentColor else { return }
    
    switch color {
    case .white:
      whitePlayer.remainingTime -= 1
    case .black:
      blackPlayer.remainingTime -= 1
    }
    
    if let player = getPlayer(with: color) {
      whitePlayerLabel.text = getFormattedRemainingTime(for: player)
    }
  }
  
}

