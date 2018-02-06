//
//  SoundManager.swift
//  BoardTimer
//
//  Created by Tiago Maia Lopes on 11/27/17.
//  Copyright © 2017 Tiago Maia Lopes. All rights reserved.
//

import AudioToolbox

/// Class responsible for playing sounds.
class SoundManager: NSObject {
  
  /// The possible sounds.
  enum Sound: String {
    case pass = "pass"
    case over = "over"
    case warning = "warning"
    
    /// The extensions for each sound resource.
    static let extensions = [
      pass: "m4a",
      over: "m4a",
      warning: "m4a"
    ]
    
    /// Returns the extension related to the instance.
    func getExtension() -> String {
      return Sound.extensions[self]!
    }
  }

  /// Plays the sound resource.
  ///
  /// - Parameter sound: The sound resource as an enum.
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
  
  /// Returns the soundID for the given sound resource.
  ///
  /// - Parameter sound: The sound resource as an enum.
  private func getSoundId(_ sound: Sound) -> SystemSoundID? {
    var soundId: SystemSoundID = 0
    
    guard let path = Bundle.main.path(forResource: sound.rawValue,
                                      ofType: sound.getExtension()) else { return nil }
    let url = URL(fileURLWithPath: path)
    AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
    
    return soundId
  }
}
