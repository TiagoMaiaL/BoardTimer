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
  private let timerStorage = TimerConfigurationStorage()

  
  private var playerManager: PlayerManager!
  private var soundManager: SoundManager!
  
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
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var restartButton: UIButton!
  @IBOutlet weak var darkOverlay: UIView!
  
  @IBOutlet private var blackTimerDefaultHeight: NSLayoutConstraint!
  private var blackTimerIncreasedHeight: NSLayoutConstraint!
  private var blackTimerDecreasedHeight: NSLayoutConstraint!
  
  @IBOutlet var passGesture: UITapGestureRecognizer!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let defaultConfiguration = timerStorage.getDefaultConfiguration() ?? TimerConfiguration.getDefaultConfigurations()[0]
    setupManagers(with: defaultConfiguration)
    setupObservers()
    
    self.pauseButton.alpha = 0;
  }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == optionsSegueId {
      let runningConfig = self.playerManager.whitePlayer.configuration
      let settingsController = (segue.destination as! UINavigationController).viewControllers.first as! SettingsTableViewController
      settingsController.runningConfiguration = runningConfig
    }
  }
  
  // MARK: Setup
  
  func setupManagers(with configuration: TimerConfiguration? = nil) {
    if let configuration = configuration {
      timerStorage.storeDefaultConfiguration(configuration)
      
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
      
      setupTimerViews()
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
    
    setupButtons()
  }
  
  func setupButtons() {
    [settingsButton, restartButton, pauseButton].forEach { button in
      button?.layer.shadowColor = UIColor.black.cgColor
      button?.layer.shadowOpacity = 0.4
      button?.layer.shadowOffset = .zero
      button?.layer.shadowRadius = 15
    }
  }
  
  func setupOverlay() {
    darkOverlay.alpha = 0
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
                    self.darkOverlay.alpha = 0
    })
    
    hideControls()
  }
  
  func animatePausedState() {
    [whiteTimerView, blackTimerView].forEach { timerView in
      timerView?.animateInitial()
    }
    
    blackTimerIncreasedHeight.isActive = false
    blackTimerDecreasedHeight.isActive = false
    blackTimerDefaultHeight.isActive = true
    
    darkOverlay.isHidden = false
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut,
                   animations: { [unowned self] in
                    self.view.layoutIfNeeded()
                    self.darkOverlay.alpha = 0.3
    })
    
    presentControls()
  }
  
  func presentControls() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut,
                   animations: { [unowned self] in
                    [self.settingsButton, self.restartButton].forEach { button in
                      button?.alpha = 1
                      button?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                    self.pauseButton.alpha = 0
    })
  }
  
  func hideControls() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut,
                   animations: { [unowned self] in
                    [self.settingsButton, self.restartButton].forEach { button in
                      button?.alpha = 0
                      button?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }
                    self.pauseButton.alpha = 1
    })
  }
  
  func presentSettings() {
    performSegue(withIdentifier: optionsSegueId, sender: self)
  }
  
  func getFormattedRemainingTime(for player: Player) -> String {
    var formattedText = ""
    
    let remainingTime = player.remainingTime
    
    let hours = Int(remainingTime / (60 * 60))
    let minutes = Int(remainingTime.truncatingRemainder(dividingBy: 60 * 60) / 60)
    let seconds = remainingTime.truncatingRemainder(dividingBy: 60)
    
    if hours > 0 {
      formattedText += "\(String(format: "%02d", hours)):"
    }
    
    if minutes > 0 {
      formattedText += "\(String(format: "%02d", minutes)):"
    }
    
    if player.isNearFinish {
      if player.remainingTime <= 0 {
        formattedText += "0.0"
      } else {
        formattedText += "\(String(format: "%.1f", abs(seconds)))"
      }
    } else {
      formattedText += "\(String(format: "%02d", Int(seconds)))"
    }
    
    return formattedText
  }
  
  func getMovesText(for player: Player) -> String {
    if (player.moves == 0) {
      return ""
    } else {
      return "\(player.moves) \(player.moves > 1 ? "moves" : "move")"
    }
  }
  
  func refreshTimerViews() {
    [(whiteTimerView, playerManager.whitePlayer),
     (blackTimerView, playerManager.blackPlayer)].forEach { [unowned self] timerView, player in
      
      timerView.setProgress(player.progress)
      timerView.setText(self.getFormattedRemainingTime(for: player))
      timerView.movesLabel.text = self.getMovesText(for: player)
      
      if player.isNearFinish {
        timerView.animateWarningState()
      } else {
        timerView.animateDefaultState()
      }
    }
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
    if playerManager.isTimerOver {
      return
    }
    
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
  }
  
  @IBAction func didTapSettings(sender: UIButton) {
    presentSettings()
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
    
    // If in initial state.
    if pauseButton.isHidden {
      pauseButton.isHidden = false
      UIView.animate(withDuration: 0.3) { [unowned self] in
        self.pauseButton.alpha = 1
      }
    }
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

