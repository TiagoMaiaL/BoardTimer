//
//  SoundManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/27/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import UIKit
import AudioToolbox

enum Sound: String {
  case pass = "pass", over = "over", warning = "warning"
  
  static let extensions = [
    pass: "m4a",
    over: "m4a",
    warning: "m4a"
  ]
  
  func getExtension() -> String {
    return Sound.extensions[self]!
  }
}

class SoundManager: NSObject {

  private var currentSoundId: SystemSoundID = 0
  
  func play(_ sound: Sound) {
    if let soundId = getSoundId(sound) {
      switch (sound) {
      case .over:
        AudioServicesPlayAlertSound(soundId)
      default:
        AudioServicesPlaySystemSound(soundId)
      }
    }
  }
  
  private func getSoundId(_ sound: Sound) -> SystemSoundID? {
    guard let path = Bundle.main.path(forResource: sound.rawValue,
                                      ofType: sound.getExtension()) else { return nil }
    let url = URL(fileURLWithPath: path)
    AudioServicesCreateSystemSoundID(url as CFURL, &currentSoundId)
    
    return currentSoundId
  }
  
}
