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
  
  @IBOutlet weak var blackWrapperView: XibView!
  @IBOutlet weak var whiteWrapperView: XibView!
  weak var blackTimerView: SingleTimerView!
  weak var whiteTimerView: SingleTimerView!
  var currentPlayerView: SingleTimerView {
    get {
      if playerManager.currentPlayer.color == .white {
        return whiteTimerView
      } else {
        return blackTimerView
      }
    }
  }
  
  @IBOutlet private var blackTimerDefaultHeight: NSLayoutConstraint!
  private var blackTimerIncreasedHeight: NSLayoutConstraint!
  private var blackTimerDecreasedHeight: NSLayoutConstraint!
  
  
  @IBOutlet var pauseGesture: UITapGestureRecognizer!
  @IBOutlet var passGesture: UITapGestureRecognizer!
  private var playerManager: PlayerManager!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    
    let timer = TimerManager()
    timer.delegate = self
    
    let configuration = (timeAmount: TimeInterval(60 * 0.5),
                         playIncrease: TimeInterval(12))
    
    playerManager = PlayerManager(configuration: configuration,
                                  timer: timer,
                                  white: Player(color: .white),
                                  black: Player(color: .black))
    playerManager.delegate = self
    
    setupTimerViews()
    setupGestures()
  }
  
  // MARK: Imperatives
  
  func setupGestures() {
    passGesture.require(toFail: pauseGesture)
  }
  
  func setupTimerViews() {
    blackTimerView = blackWrapperView.contentView as! SingleTimerView
    whiteTimerView = whiteWrapperView.contentView as! SingleTimerView
    
    blackTimerView.theme = .black
    whiteTimerView.theme = .white
    
    blackTimerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    
    blackTimerIncreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
    blackTimerDecreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
  }
  
  func getFormattedRemainingTime(for player: Player) -> String {
    let remainingTime = player.remainingTime
    let minutes = Int(remainingTime / 60)
    let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
    
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }
  
  func updateLabels(of timerView: SingleTimerView? = nil) {
    let timerView = timerView ?? currentPlayerView
    let remainingTime = getFormattedRemainingTime(for: playerManager.currentPlayer)
    timerView.setText(remainingTime)
  }
  
  func animatePlayerChange() {
    let currentColor = playerManager.currentPlayer.color
    
    blackTimerDefaultHeight.isActive = false
    
    if currentColor == .black {
      blackTimerDecreasedHeight.isActive = false
      blackTimerIncreasedHeight.isActive = true
    } else {
      blackTimerIncreasedHeight.isActive = false
      blackTimerDecreasedHeight.isActive = true
      
    }
    
    UIView.animate(withDuration: 0.5) { [unowned self] in
      self.view.layoutIfNeeded()
    }
  }
  
}

// MARK: Actions

extension ViewController {
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    if !playerManager.timer.isRunning() {
      playerManager.timer.start()
    } else {
      playerManager.toggleCurrentPlayer()
    }
  }
  
  @IBAction func didDoubleTap(_ sender: UITapGestureRecognizer) {
    if playerManager.timer.isRunning() {
      playerManager.timer.pause()
    } else {
      playerManager.timer.start()
    }
  }

}

// MARK: Timer manager delegate

extension ViewController: TimerManagerDelegate {

  func timerHasStarted(manager: TimerManager) {
    animatePlayerChange()
    print("Started")
  }

  func timerHasStopped(manager: TimerManager) {
    // TODO: Make the stop animation.
    // TODO: Implement the paused state.
    print("Paused")
  }

  func timerHasFired(manager: TimerManager) {
    playerManager.decreaseRemainingTime()
    updateLabels()
  }

}

// MARK: Player manager delegate

extension ViewController: PlayerManagerDelegate {
  
  func playerHasChanged(currentPlayer: Player) {
    updateLabels()
    animatePlayerChange()
  }
  
  func playerTimeHasRanOver(player: Player) {
    playerManager.timer.pause()
    // TODO: Show finished state.
    print("timer is over.")
  }
  
  func playerTimeHasDecreased(player: Player) {
    updateLabels()
  }
  
  func playerTimeHasIncreased(player: Player) {
    let timerView: SingleTimerView!
    
    if player.color == .white {
      timerView = whiteTimerView
    } else {
      timerView = blackTimerView
    }
    
    updateLabels(of: timerView)
  }
  
}

