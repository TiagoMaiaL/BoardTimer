//
//  ViewController.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
  
  /// The possible notifications observable by this timer view controller.
  enum NotificationName {
    case restart
    case pause
    case new
    
    /// Returns the associated notification name object.
    func getName() -> Notification.Name {
      switch self {
      case .restart:
        return Notification.Name("restart_timer")
      case .pause:
        return Notification.Name("pause_timer")
      case .new:
        return Notification.Name("new_timer")
      }
    }
  }

  // MARK: Properties
  
  /// Segue ID to present the settings view controller.
  private let optionsSegueId = "show_options"
  
  /// Timer storage to retrieve and save the default timer configuration.
  private let timerStorage = TimerConfigurationStorage()

  /// The manager in charge of handling the pass between the two timer players.
  var playerManager: PlayerManager! {
    didSet {
//      timer.restart()
      playerManager.delegate = self
    
      timerStorage.storeDefaultConfiguration(playerManager.whitePlayer.configuration)
      
      updateTimerViews()
      
      [whiteTimerView, blackTimerView].forEach { timer in
        timer?.animateDefaultState()
      }
    }
  }
  
  /// The internal timer manager.
  private let timer = TimerManager()
  
  /// The internal sound manager.
  private let soundManager = SoundManager()
  
  // TODO: Remove the XIBView class.
  @IBOutlet private weak var blackWrapperView: XibView!
  @IBOutlet private weak var whiteWrapperView: XibView!
  
  /// The timer view associated with the black player.
  private weak var blackTimerView: SingleTimerView!
  
  /// The timer view associated with the white player.
  private weak var whiteTimerView: SingleTimerView!
  
  /// The timer view associated with the current player.
  private var currentPlayerView: SingleTimerView {
    get {
      if playerManager.currentPlayer.color == .white {
        return whiteTimerView
      } else {
        return blackTimerView
      }
    }
  }
  
  /// The default height constraint applied to the black timer view.
  /// - Note: This is a property used to animate the player views to indicate the timer states.
  @IBOutlet var blackTimerDefaultHeight: NSLayoutConstraint!
  
  /// The increased height constraint applied to the black timer view.
  /// - Note: This is a property used to animate the player views to indicate the timer states.
  var blackTimerIncreasedHeight: NSLayoutConstraint!
  
  /// The decreased height constraint applied to the black timer view.
  /// - Note: This is a property used to animate the player views to indicate the timer states.
  var blackTimerDecreasedHeight: NSLayoutConstraint!

  
  /// The pause control.
  @IBOutlet private weak var pauseButton: UIButton!
  
  /// The settings control.
  @IBOutlet private weak var settingsButton: UIButton!
  
  /// The restart control.
  @IBOutlet private weak var restartButton: UIButton!
  
  /// The overlay view.
  @IBOutlet private weak var darkOverlay: UIView!
  
  /// The tap gesture in charge of recognizing pass requests from each player.
  @IBOutlet private var passGesture: UITapGestureRecognizer!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTimerViews()
    setupObservers()
    
    timer.delegate = self
    playerManager = makePlayerManager(configuration: nil)
    
    pauseButton.alpha = 1;
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer.pause()
  }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == optionsSegueId {
      let runningConfig = playerManager.whitePlayer.configuration
      let settingsController = (segue.destination as! UINavigationController).viewControllers.first as! SettingsTableViewController
      settingsController.runningConfiguration = runningConfig
    }
  }
  
  // MARK: Setup
  
  /// Factory method in charge of creating a configured player manager.
  func makePlayerManager(configuration: TimerConfiguration?) -> PlayerManager {
    let configuration = timerStorage.getDefaultConfiguration() ?? TimerConfiguration.getDefaultConfigurations()[0]

    let whitePlayer = Player(color: .white,
                             configuration: configuration)
    let blackPlayer = Player(color: .black,
                             configuration: configuration)

    return PlayerManager(white: whitePlayer,
                         black: blackPlayer)
  }
  
  private func makeRestartDialog(usingHandler handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
    let alert = UIAlertController(title:  NSLocalizedString("Reset", comment: "Timer Controller: Title of the reset dialog"),
                                  message: NSLocalizedString("Are you sure you want to reset the current timer?", comment: "Timer Controller: Reset dialog message"),
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("reset", comment: "Timer Controller: dialog reset button title"),
                                  style: .destructive,
                                  handler: handler))
    alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Timer Controller: dialog cancel button title"),
                                  style: .cancel))
    return alert
  }
  
  /// Configures the notification observers for the controller.
  private func setupObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(newTimerRequested(notification:)),
                                           name: NotificationName.new.getName(),
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(pauseRequested(Notification:)),
                                           name: NotificationName.pause.getName(),
                                           object: nil)
  }
  
  /// Configures each timer view.
  private func setupTimerViews() {
    blackTimerView = blackWrapperView.contentView as! SingleTimerView
    whiteTimerView = whiteWrapperView.contentView as! SingleTimerView
    
    blackTimerView.theme = .dark
    whiteTimerView.theme = .white
    
    blackTimerView.rotate(angle: CGFloat.pi)
    
    blackTimerIncreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
    blackTimerDecreasedHeight = blackTimerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
    
    updateTimerViews()
    
    setupButtons()
  }
  
  /// Configures the initial controls state and attributes.
  private func setupButtons() {
    [settingsButton, restartButton, pauseButton].forEach { button in
      button?.layer.shadowColor = UIColor.black.cgColor
      button?.layer.shadowOpacity = 0.4
      button?.layer.shadowOffset = .zero
      button?.layer.shadowRadius = 15
    }
  }
  
  /// Configures the overlay view.
  private func setupOverlay() {
    darkOverlay.alpha = 0
  }
  
  // MARK: Imperatives
  
  /// Animates the timer views to indicate the previous player pass and change.
  private func animatePlayerChange() {
    let currentColor = playerManager.currentPlayer.color
    
    blackTimerDefaultHeight.isActive = false
    
    if currentColor == .black {
      blackTimerDecreasedHeight.isActive = false
      blackTimerIncreasedHeight.isActive = true
      
      whiteTimerView.animateOut()
      blackTimerView.animateIn()
      
    } else {
      blackTimerIncreasedHeight.isActive = false
      blackTimerDecreasedHeight.isActive = true
      
      blackTimerView.animateOut()
      whiteTimerView.animateIn()
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
  
  /// Animates the timer views and controls to present the paused timer state.
  private func animatePausedState() {
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
  
  /// Animates the restart and pause controls in.
  private func presentControls() {
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
  
  /// Animates the restart and pause controls out.
  private func hideControls() {
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
  
  /// Presents the settings view controller.
  private func presentSettings() {
    performSegue(withIdentifier: optionsSegueId, sender: self)
  }
  
  /// Updates the timer views to match the current state of each player.
  private func updateTimerViews() {
    guard whiteTimerView != nil,
          blackTimerView != nil,
          playerManager != nil else { return }
    
    [(whiteTimerView, playerManager.whitePlayer),
     (blackTimerView, playerManager.blackPlayer)].forEach { timerView, player in
      
      timerView.setProgress(player.progress)
      timerView.setText(player.formattedRemainingTime)
      timerView.movesLabel.text = player.formattedMovesText
    }
  }
  
}

extension TimerViewController {
 
  // MARK: Actions
  
  @IBAction private func didTap(_ sender: UITapGestureRecognizer) {
    if playerManager.isTimerOver {
      return
    }
    
    if !timer.isRunning {
      timer.start()
    } else {
      playerManager.toggleCurrentPlayer()
    }
  }
  
  @IBAction private func didTapRefresh(_ sender: UIButton? = nil) {
    present(makeRestartDialog { action in
      self.playerManager = self.makePlayerManager(configuration: nil)
    }, animated: true)
  }
  
  @IBAction private func didTapPause(sender: UIButton) {
    if timer.isRunning {
      timer.pause()
    } else {
      presentSettings()
    }
  }
  
  @IBAction private func didTapSettings(sender: UIButton) {
    presentSettings()
  }
  
  // MARK: Notification Actions
  
  @objc private func newTimerRequested(notification: Notification) {
    guard let configuration = notification.userInfo?["timer_config"] as? TimerConfiguration else { return }
    
    present(makeRestartDialog { action in
      self.playerManager = self.makePlayerManager(configuration: configuration)
    }, animated: true)
  }
  
  @objc private func pauseRequested(Notification: Notification) {
    if timer.isRunning {
      timer.pause()
    }
  }

}

// MARK: Timer manager delegate

extension TimerViewController: TimerManagerDelegate {

  func timerDidStart(timer: TimerManager) {
    animatePlayerChange()
    soundManager.play(.pass)
    pauseButton.setImage(UIImage(named: "ic_pause"), for: .normal)
  }

  func timerDidStop(timer: TimerManager) {
    animatePausedState()
  }

  func timerDidFire(timer: TimerManager) {
    playerManager.decreaseRemainingTime()
  }

}

// MARK: Player manager delegate

extension TimerViewController: PlayerManagerDelegate {
  
  func playerDidChange(_ currentPlayer: Player) {
    updateTimerViews()
    animatePlayerChange()
    soundManager.play(.pass)
    timer.restart()
  }
  
  func playerTimeDidEnd(_ player: Player) {
    timer.pause()
    soundManager.play(.over)
  }
  
  func playerTimeDidDecrease(_ player: Player) {
    updateTimerViews()
  }
  
  func playerTimeWillFinish(_ player: Player) {
    currentPlayerView.animateWarningState()
    soundManager.play(.warning)
  }
  
}

