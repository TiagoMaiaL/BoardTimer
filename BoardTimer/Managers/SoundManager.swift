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
  case pass = "pass"
  
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
    guard let path = Bundle.main.path(forResource: sound.rawValue, ofType: sound.getExtension()) else { return }
    let url = URL(fileURLWithPath: path)
    
    AudioServicesCreateSystemSoundID(url as CFURL, &currentSoundId)
    AudioServicesPlaySystemSound(currentSoundId)
  }
  
}
