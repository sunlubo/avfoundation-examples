//
//  Media Composition.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Cocoa
import AVFoundation
import CoreMedia

// AVAsset
let audioAsset1 = AVAsset(url: URL(string: "file:///Users/sun/AV/%E6%81%8B%E4%BA%BA%E5%BF%83.mp3")!)
let videoAsset1 = AVAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)
let videoAsset2 = AVAsset(url: URL(string: "file:///Users/sun/AV/%E5%87%A1%E4%BA%BA%E4%BF%AE%E4%BB%99%E4%BC%A0.mp4")!)

// AVAssetTrack
let audioAssetTrack1 = audioAsset1.tracks(withMediaType: .audio).first!
let videoAssetTrack1 = videoAsset1.tracks(withMediaType: .video).first!
let videoAssetTrack2 = videoAsset2.tracks(withMediaType: .video).first!

// AVMutableComposition
let composition = AVMutableComposition()

// AVMutableCompositionTrack
let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)!

// AVCompositionTrackSegment
let duration = CMTime(seconds: 5, preferredTimescale: 1)
try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration * 2), of: audioAssetTrack1, at: .zero)
try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: videoAssetTrack1, at: .zero)
try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: videoAssetTrack2, at: .zero + duration)

for segment in composition.tracks.flatMap({ $0.segments! }) {
    print(segment)
}

export(asset: composition, outputURL: URL(string: "file:///Users/sun/AV/avf_test.mov")!)

//: [Next](@next)
