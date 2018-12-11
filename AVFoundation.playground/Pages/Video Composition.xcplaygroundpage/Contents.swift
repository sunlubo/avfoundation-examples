//
//  Video Composition.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Cocoa
import AVFoundation
import CoreMedia

// AVAsset
let videoAsset1 = AVAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)
let videoAsset2 = AVAsset(url: URL(string: "file:///Users/sun/AV/%E5%87%A1%E4%BA%BA%E4%BF%AE%E4%BB%99%E4%BC%A0.mp4")!)

// AVAssetTrack
let videoAssetTrack1 = videoAsset1.tracks(withMediaType: .video).first!
let videoAssetTrack2 = videoAsset2.tracks(withMediaType: .video).first!

// AVMutableComposition & AVMutableCompositionTrack
let composition = AVMutableComposition()
let videoTrack1 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)!
let videoTrack2 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)!

// AVCompositionTrackSegment
// |||||||||||    10    ||||||||||
//     8   ||||||||||||||||   8
let start = CMTime(value: 10, timescale: 1)
let duration = CMTime(value: 10, timescale: 1)
let transitionDuration = CMTime(value: 2, timescale: 1)
try videoTrack1.insertTimeRange(CMTimeRange(start: start, duration: duration), of: videoAssetTrack1, at: .zero)
try videoTrack1.insertTimeRange(CMTimeRange(start: start, duration: duration), of: videoAssetTrack1, at: duration * 2)
try videoTrack2.insertTimeRange(CMTimeRange(start: start, duration: duration + transitionDuration * 2), of: videoAssetTrack2, at: duration - transitionDuration)

// 非重叠区域
let passThroughTimeRanges = [
    CMTimeRange(start: .zero, duration: CMTime(value: 8, timescale: 1)), // 0 - 8
    CMTimeRange(start: duration, duration: duration), // 10 - 20
    CMTimeRange(start: duration + duration + transitionDuration, duration: CMTime(value: 8, timescale: 1)) // 22 - 30
]
// 重叠区域
let transitionTimeRanges = [
    CMTimeRange(start: CMTime(value: 8, timescale: 1), duration: transitionDuration), // 8 - 10
    CMTimeRange(start: duration + duration, duration: transitionDuration) // 20 - 22
]

// AVVideoCompositionInstruction & AVMutableVideoCompositionLayerInstruction
var compositionInstructions = [AVVideoCompositionInstruction]()
let tracks = composition.tracks(withMediaType: .video)
for i in 0..<passThroughTimeRanges.count {
    let trackIndex = i % 2
    let track = tracks[trackIndex]

    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = passThroughTimeRanges[i]
    compositionInstructions.append(instruction)

    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
    instruction.layerInstructions = [layerInstruction]

    if i < transitionTimeRanges.count {
        let foregroundTrack = tracks[trackIndex]
        let backgroundTrack = tracks[1 - trackIndex]

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = transitionTimeRanges[i]
        compositionInstructions.append(instruction)

        let fromLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: foregroundTrack)
        fromLayerInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: instruction.timeRange)
        let toLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: backgroundTrack)
        instruction.layerInstructions = [fromLayerInstruction, toLayerInstruction]
    }
}

// AVMutableVideoComposition
let videoComposition = AVMutableVideoComposition()
videoComposition.frameDuration = CMTime(value: 1, timescale: 25)
videoComposition.renderSize = CGSize(width: 1920, height: 1080)
videoComposition.renderScale = 1.0
videoComposition.instructions = compositionInstructions

play(asset: composition, videoComposition: videoComposition)

//: [Next](@next)
