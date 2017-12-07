//
//  ViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

struct NotificationName {
  static let restartTimer = Notification.Name("restart_timer")
  static let newTimer = Notification.Name("new_timer")
}

class ViewController: UIViewController {

  // MARK: Properties
  
  let optionsSegueId = "show_options"
  
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
  @IBOutlet weak var pauseButton: UIButton!
  
  @IBOutlet private var blackTimerDefaultHeight: NSLayoutConstraint!
  private var blackTimerIncreasedHeight: NSLayoutConstraint!
  private var blackTimerDecreasedHeight: NSLayoutConstraint!
  
  @IBOutlet var passGesture: UITapGestureRecognizer!
  private var playerManager: PlayerManager!
  private var soundManager: SoundManager!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: Determine the default configuration.
    setupManagers(with: TimerConfiguration.getDefaultConfigurations()[3])
    setupObservers()
    setupTimerViews()
  }
  
  // MARK: Setup
  
  func setupManagers(with configuration: TimerConfiguration? = nil) {
    if let configuration = configuration {
      let timer = TimerManager()
      timer.delegate = self
      
      let whitePlayer = Player(color: .white,
                               configuration: configuration)
      let blackPlayer = Player(color: .black,
                               configuration: configuration)
      
      playerManager = PlayerManager(timer: timer,
                                    white: whitePlayer,
                                    black: blackPlayer)
      playerManager.delegate = self
      
      soundManager = SoundManager()
    }
  }
  
  func setupObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(newTimerRequested(notification:)),
                                           name: NotificationName.newTimer,
                                           object: nil)
  }
  
  func setupTimerViews() {
    blackTimerView = blackWrapperView.contentView as! SingleTimerView
    whiteTimerView = whiteWrapperView.contentView as! SingleTimerView
    
    blackTimerView.theme = .dark
    whiteTimerView.theme = .white
    
    blackTimerView.rotate(angle: CGFloat.pi)
    
    blackTimerIncreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
    blackTimerDecreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
    
    refreshTimerViews()
    
    pauseButton.layer.shadowColor = UIColor.black.cgColor
    pauseButton.layer.shadowOpacity = 0.4
    pauseButton.layer.shadowOffset = .zero
    pauseButton.layer.shadowRadius = 15
  }
  
  // MARK: Imperatives
  
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
    
    if currentColor == .black {
      self.whiteTimerView.animateOut()
      self.blackTimerView.animateIn()
    } else {
      self.blackTimerView.animateOut()
      self.whiteTimerView.animateIn()
    }
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut,
                   animations: { [unowned self] in
                    self.view.layoutIfNeeded()
    })
  }
  
  func animatePausedState() {
    [whiteTimerView, blackTimerView].forEach { timerView in
      timerView?.animateOut()
    }
    
    blackTimerIncreasedHeight.isActive = false
    blackTimerDecreasedHeight.isActive = false
    blackTimerDefaultHeight.isActive = true
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut,
                   animations: { [unowned self] in
                    self.view.layoutIfNeeded()
    })
  }
  
  func presentOptions() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "settings", style: .default) { [unowned self] _ in
      self.presentSettings()
    })
    actionSheet.addAction(UIAlertAction(title: "restart timer", style: .destructive) { [unowned self] _ in
      self.didTapRefresh(nil)
    })
    actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel))
    
    present(actionSheet, animated: true)
  }
  
  func presentSettings() {
    performSegue(withIdentifier: optionsSegueId, sender: self)
  }
  
  func getFormattedRemainingTime(for player: Player) -> String {
    let remainingTime = player.remainingTime
    let minutes = Int(remainingTime / 60)
    let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
    
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }
  
  func refreshTimerViews() {
    whiteTimerView.setText(getFormattedRemainingTime(for: playerManager.whitePlayer))
    blackTimerView.setText(getFormattedRemainingTime(for: playerManager.blackPlayer))
  }
  
  func restartTimer(with configuration: TimerConfiguration? = nil) {
    playerManager = nil
    setupManagers(with: configuration)
    refreshTimerViews()
  }
}

extension ViewController {
 
  // MARK: Actions
  
  @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    if !playerManager.timer.isRunning {
      playerManager.timer.start()
    } else {
      playerManager.toggleCurrentPlayer()
    }
  }
  
  @IBAction func didTapRefresh(_ sender: UIButton? = nil) {
    let alert = UIAlertController(title: "Reset",
                                  message: "Are you sure you want to reset the current timer?",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "reset", style: .destructive, handler: { [unowned self] _ in
      let configuration: TimerConfiguration!
      
      if self.playerManager != nil {
        configuration = self.playerManager.whitePlayer.configuration
      } else {
        // TODO: Determine the default configuration.
        configuration = TimerConfiguration.getDefaultConfigurations()[3]
      }
      
      self.restartTimer(with: configuration)
    }))
    alert.addAction(UIAlertAction(title: "cancel", style: .cancel))

    present(alert, animated: true)
  }
  
  @IBAction func didTapPause(sender: UIButton) {
    if (playerManager.timer.isRunning) {
      playerManager.timer.pause()
    }
    
    presentOptions()
  }
  
  // MARK: Notification Actions
  
  @objc func newTimerRequested(notification: Notification) {
    guard let configuration = notification.userInfo?["timer_config"] as? TimerConfiguration else { return }
    
    let alert = UIAlertController(title: "Reset",
                                  message: "Are you sure you want to reset the current timer?",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "reset", style: .destructive, handler: { [unowned self] _ in
      self.restartTimer(with: configuration)
    }))
    alert.addAction(UIAlertAction(title: "cancel", style: .cancel))

    present(alert, animated: true)
  }

}

// MARK: Timer manager delegate

extension ViewController: TimerManagerDelegate {

  func timerHasStarted(manager: TimerManager) {
    animatePlayerChange()
    soundManager.play(.pass)
  }

  func timerHasStopped(manager: TimerManager) {
    animatePausedState()
  }

  func timerHasFired(manager: TimerManager) {
    playerManager.decreaseRemainingTime()
  }

}

// MARK: Player manager delegate

extension ViewController: PlayerManagerDelegate {
  
  func playerHasChanged(currentPlayer: Player) {
    refreshTimerViews()
    animatePlayerChange()
    soundManager.play(.pass)
  }
  
  func playerTimeHasRanOver(player: Player) {
    playerManager.timer.pause()
    soundManager.play(.over)
  }
  
  func playerTimeHasDecreased(player: Player) {
    refreshTimerViews()
  }
  
}

