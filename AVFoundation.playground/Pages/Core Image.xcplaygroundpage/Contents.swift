//
//  Core Image.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import AVFoundation
import CoreImage

let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)

let filter = CIFilter(name: "CIPhotoEffectProcess")!
let videoComposition = AVMutableVideoComposition(asset: asset) { request in
    filter.setValue(request.sourceImage, forKey: kCIInputImageKey)
    // Provide the filter output to the composition
    request.finish(with: filter.outputImage!, context: nil)
}
videoComposition.frameDuration
videoComposition.renderSize
videoComposition.renderScale
videoComposition.instructions.forEach { instruction in
    print(instruction.timeRange)
}

play(asset: asset, videoComposition: videoComposition)

//: [Next](@next)
