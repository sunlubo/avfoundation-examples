//
//  Metal.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import Cocoa
import Dispatch
import AVFoundation
import MetalKit
import PlaygroundSupport

let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)
let playerItem = AVPlayerItem(asset: asset)

let attributes = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
let playerItemVideoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: attributes)
playerItem.add(playerItemVideoOutput)

let player = AVPlayer(playerItem: playerItem)

let mtkView = MTKView(frame: CGRect(x: 0, y: 0, width: 400, height: 300))
let render = Render(mtkView: mtkView)
mtkView.delegate = render
PlaygroundPage.current.liveView = mtkView

let interval = CMTime(value: 1, timescale: 60).seconds
var timestamp = CACurrentMediaTime()
let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
timer.setEventHandler {
    let nextVSync = timestamp + interval
    timestamp = nextVSync

    let currentTime = playerItemVideoOutput.itemTime(forHostTime: nextVSync)
    if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime),
        let pixelBuffer = playerItemVideoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) {
        render.pixelBuffer = pixelBuffer
    }
}
timer.schedule(deadline: .now(), repeating: interval)
timer.resume()

player.play()

//: [Next](@next)
