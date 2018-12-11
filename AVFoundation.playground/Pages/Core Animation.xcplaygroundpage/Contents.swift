//
//  Core Animation.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import Cocoa
import AVFoundation
import AVKit
import QuartzCore
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let image = NSImage(named: "girl")!.cgImage(forProposedRect: nil, context: nil, hints: nil)!

// AVAsset
let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)
let videoAssetTrack = asset.tracks(withMediaType: .video).first!

// CALayer & CAAnimation
let imageLayer = CALayer()
imageLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
imageLayer.backgroundColor = NSColor.blue.cgColor
imageLayer.contentsGravity = .resizeAspect
imageLayer.contents = image
imageLayer.opacity = 0.0

let fadeInFadeOutAnim = CAKeyframeAnimation(keyPath: "opacity")
fadeInFadeOutAnim.values = [0.0, 1.0, 1.0, 0.0]
fadeInFadeOutAnim.keyTimes = [0.0, 0.4, 0.6, 1.0]
fadeInFadeOutAnim.beginTime = CMTime(value: 10, timescale: 1).seconds
fadeInFadeOutAnim.duration = CMTimeRange(start: .zero, end: CMTime(value: 3, timescale: 1)).duration.seconds
fadeInFadeOutAnim.isRemovedOnCompletion = false
imageLayer.add(fadeInFadeOutAnim, forKey: nil)

// MARK: - Export

let animationLayer = CALayer()
animationLayer.frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
animationLayer.isGeometryFlipped = true

let videoLayer = CALayer()
videoLayer.frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
animationLayer.addSublayer(videoLayer)

imageLayer.frame = CGRect(x: (1920 - 200) / 2, y: (1080 - 200) / 2, width: 200, height: 200)
animationLayer.addSublayer(imageLayer)

// AVVideoCompositionCoreAnimationTool
let animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: animationLayer)

// AVMutableVideoCompositionInstruction
let instruction = AVMutableVideoCompositionInstruction()
instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)

// AVMutableVideoCompositionLayerInstruction
let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoAssetTrack)
instruction.layerInstructions = [layerInstruction]

// AVMutableVideoComposition
let videoComposition = AVMutableVideoComposition()
videoComposition.frameDuration = CMTime(value: 1, timescale: 25)
videoComposition.renderSize = CGSize(width: 1920, height: 1080)
videoComposition.renderScale = 1.0
videoComposition.instructions = [instruction]
videoComposition.animationTool = animationTool

export(asset: asset, videoComposition: videoComposition, outputURL: URL(string: "file:///Users/sun/AV/avf_test.mov")!)

// MARK: - Play

// let playerItem = AVPlayerItem(asset: asset)
// let player = AVPlayer(playerItem: playerItem)
// let syncLayer = AVSynchronizedLayer(playerItem: playerItem)
// syncLayer.frame = imageLayer.bounds
// syncLayer.addSublayer(imageLayer)
//
// let animView = NSView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
// animView.wantsLayer = true
// animView.layer!.addSublayer(syncLayer)
//
// let playerView = AVPlayerView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
// playerView.player = player
// playerView.addSubview(animView)
//
// PlaygroundPage.current.liveView = playerView
//
// player.play()

//: [Next](@next)
