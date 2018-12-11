//
//  Image Generator.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import AVFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
let duration = asset.duration

var times = [NSValue]()
var increment = duration.value / 20
var current = CMTime.zero.value
while current <= duration.value {
    let time = CMTime(value: current, timescale: duration.timescale)
    times.append(NSValue(time: time))
    current += increment
}

let imageGenerator = AVAssetImageGenerator(asset: asset)
imageGenerator.maximumSize = CGSize(width: 200, height: 0)
imageGenerator.generateCGImagesAsynchronously(forTimes: times) { requestedTime, image, actualTime, result, error in
    print("requested: \(requestedTime), actual: \(actualTime) size: \(image!.width)x\(image!.height)")
}

//: [Next](@next)
