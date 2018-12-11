//
//  Play.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import AVFoundation
import AVKit
import PlaygroundSupport

let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)

let playerItem = AVPlayerItem(asset: asset)
playerItem.status
playerItem.duration.seconds
playerItem.timebase
playerItem.loadedTimeRanges
playerItem.presentationSize

// 滑动条可以通过该 API 进行优化
// playerItem.cancelPendingSeeks()

let observation = playerItem.observe(\.tracks) { playerItem, change in
    for track in playerItem.tracks {
        print("AVPlayerItemTrack type: \(track.assetTrack!.mediaType.rawValue) enabled: \(track.isEnabled) frameRate: \(track.currentVideoFrameRate)")
    }
}

let player = AVPlayer(playerItem: playerItem)

// let queuePlayer = AVQueuePlayer(playerItem: playerItem)

let playerView = AVPlayerView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
playerView.player = player
PlaygroundPage.current.liveView = playerView

player.play()

//: [Next](@next)
