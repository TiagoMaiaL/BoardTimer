//
//  AppDelegate.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/10/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Types
  
  enum ShortcutType: String {
    case Quick = "Quick"
    case Blitz = "Blitz"
    case Bullet = "Bullet"
    case Lightning = "Lightning"
  }
  
  // MARK: Properties
  
  var window: UIWindow?
  
  // MARK: Delegate methods
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    NotificationCenter.default.post(name: NotificationName.pauseTimer,
                                    object: self)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // MARK: Shortcuts
  
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) { 
    handleShortcut(shortcutItem)
    completionHandler(false)
  }
  
  private func handleShortcut(_ item: UIApplicationShortcutItem) {
    guard let rawType = item.type.components(separatedBy: ".").last else { return }
    guard let type = ShortcutType(rawValue: rawType) else { return }
    
    var selectedConfiguration: TimerConfiguration?
    
    switch type {
    case .Quick:
      selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[0]
    case .Blitz:
      selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[1]
    case .Bullet:
      selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[2]
    case .Lightning:
      selectedConfiguration = TimerConfiguration.getDefaultConfigurations()[3]
    }
    
    if let configuration = selectedConfiguration {
      if let timerController = window?.rootViewController as? ViewController {
        timerController.setupManagers(with: configuration)
      }
    }
    
  }

}

