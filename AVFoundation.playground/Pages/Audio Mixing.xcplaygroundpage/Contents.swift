//
//  Audio Mixing.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Cocoa
import AVFoundation
import CoreMedia

// AVAsset
let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])

// AVAssetTrack
let audioAssetTrack = asset.tracks(withMediaType: .audio).first!

// AVMutableAudioMixInputParameters
let inputParams = AVMutableAudioMixInputParameters(track: audioAssetTrack)
inputParams.setVolumeRamp(fromStartVolume: 0.1, toEndVolume: 1.0, timeRange: audioAssetTrack.timeRange)
// AVMutableAudioMix
let audioMix = AVMutableAudioMix()
audioMix.inputParameters = [inputParams]

play(asset: asset, audioMix: audioMix)

//: [Next](@next)
