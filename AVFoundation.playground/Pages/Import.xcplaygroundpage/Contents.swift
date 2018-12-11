//
//  Import.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import AVFoundation
import CoreMedia
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let asset = AVURLAsset(url: URL(string: "file:///Users/sun/AV/BoML.mp4")!)
let videoTrack = asset.tracks(withMediaType: .video)[0]

let assetReader = try AVAssetReader(asset: asset)
let readerOutputSettings = [
    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
] as [String: Any]
let trackOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerOutputSettings)
assetReader.add(trackOutput)
assetReader.startReading()

let outputURL = URL(string: "file:///Users/sun/AV/avf_test.mp4")!
let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
let writerOutputSettings = [
    AVVideoCodecKey: AVVideoCodecType.h264,
    AVVideoWidthKey: 1920,
    AVVideoHeightKey: 1080,
    AVVideoCompressionPropertiesKey: [
        AVVideoMaxKeyFrameIntervalKey: 1,
        AVVideoAverageBitRateKey: 10500000,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264Main31
    ]
] as [String: Any]
let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: writerOutputSettings)
assetWriter.add(writerInput)
assetWriter.startWriting()

let queue = DispatchQueue(label: "writer_queue")

assetWriter.startSession(atSourceTime: .zero)
writerInput.requestMediaDataWhenReady(on: queue) {
    var complete = false
    while writerInput.isReadyForMoreMediaData && !complete {
        if let sampleBuffer = trackOutput.copyNextSampleBuffer() {
            complete = !writerInput.append(sampleBuffer)
        } else {
            writerInput.markAsFinished()
            complete = true
        }
    }

    if complete {
        assetWriter.finishWriting {
            switch assetWriter.status {
            case .unknown:
                print("unknown")
            case .writing:
                print("writing")
            case .completed:
                print("Write finished.")
            case .failed:
                print("error: \(assetWriter.error!.localizedDescription)")
            case .cancelled:
                print("cancelled")
            }
        }
    }
}

//: [Next](@next)
