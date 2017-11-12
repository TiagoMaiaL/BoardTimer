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
  
  @IBOutlet weak var whiteLabelVertical: NSLayoutConstraint!
  @IBOutlet weak var whiteLabelHorizontal: NSLayoutConstraint!
  
  private var playerManager: PlayerManager!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    let timer = TimerManager()
    timer.delegate = self
    
    let configuration = (timeAmount: TimeInterval(60 * 2),
                         playIncrease: TimeInterval(12))
    
    playerManager = PlayerManager(configuration: configuration,
                                  timer: timer,
                                  white: Player(color: .white),
                                  black: Player(color: .black))
    playerManager.delegate = self
  }
  
  // MARK: Imperatives
  
  func getFormattedRemainingTime(for player: Player) -> String {
    let remainingTime = player.remainingTime
    let minutes = Int(remainingTime / 60)
    let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
    
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }
  
  func animate() {
    
  }
  
}

// MARK: Actions

extension ViewController {
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    
//    whitePlayerLabel.translatesAutoresizingMaskIntoConstraints = false
//
//    whiteLabelVertical.isActive = false
//    whiteLabelHorizontal.isActive = false
//    
//    whitePlayerLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,
//                                             constant: -5).isActive = true
//    whitePlayerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor,
//                                              constant: 5).isActive = true
//    
//    UIView.animate(withDuration: 1) { [unowned self] in
//      self.whitePlayerLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//      self.view.layoutIfNeeded()
//    }
    
    if !playerManager.timer.isRunning() {
      playerManager.timer.start()
    } else {
      playerManager.toggleCurrentPlayer()
    }
  }

}

// MARK: Timer manager delegate

extension ViewController: TimerManagerDelegate {

  func timerHasStarted(manager: TimerManager) {
    // TODO:
  }

  func timerHasStopped(manager: TimerManager) {
    // TODO: Make the stop animation
  }

  func timerHasFired(manager: TimerManager) {
    playerManager.decreaseRemainingTime()
    whitePlayerLabel.text = getFormattedRemainingTime(for: playerManager.currentPlayer)
  }

}

// MARK: Player manager delegate

extension ViewController: PlayerManagerDelegate {
  
  func playerHasChanged(currentPlayer: Player) {
    // TODO: Make the change animation
  }
  
  func playerTimeHasRanOver(player: Player) {
    // TODO: End the timer
  }
  
  func playerTimeHasDecreased(player: Player) {
    whitePlayerLabel.text = getFormattedRemainingTime(for: player)
  }
  
}
