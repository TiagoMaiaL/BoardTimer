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
  case pass = "pass", over = "over"
  
  static let extensions = [
    pass: "wav"
  ]
  
  func getExtension() -> String {
    return Sound.extensions[self]!
  }
}

class SoundManager: NSObject {

  private var currentSoundId: SystemSoundID = 0
  
  func play(_ sound: Sound) {
    if let soundId = getSound(sound) {
      AudioServicesPlaySystemSound(soundId)
    }
  }
  
  private func getSound(_ sound: Sound) -> SystemSoundID? {
    switch sound {
    case .over:
      return kSystemSoundID_Vibrate
      
    default:
      guard let path = Bundle.main.path(forResource: sound.rawValue,
                                        ofType: sound.getExtension()) else { return nil }
      let url = URL(fileURLWithPath: path)
      AudioServicesCreateSystemSoundID(url as CFURL, &currentSoundId)
      
      return currentSoundId
    }
  }
  
}
