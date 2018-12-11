//
//  Util.swift
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import PlaygroundSupport

extension CMTime: CustomStringConvertible {

    public var description: String {
        return "{\(value)/\(timescale) = \(seconds)}"
    }

    public static func * (lhs: CMTime, rhs: Int32) -> CMTime {
        return CMTimeMultiply(lhs, multiplier: rhs)
    }
}

extension CMTimeRange: CustomStringConvertible {

    public var description: String {
        return "{\(start), \(end)}"
    }
}

public func play(asset: AVAsset, audioMix: AVAudioMix? = nil, videoComposition: AVVideoComposition? = nil) {
    let playerItem = AVPlayerItem(asset: asset)
    playerItem.audioMix = audioMix
    playerItem.videoComposition = videoComposition

    let player = AVPlayer(playerItem: playerItem)

    let playerView = AVPlayerView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
    playerView.player = player
    PlaygroundPage.current.liveView = playerView

    player.play()
}

public func export(asset: AVAsset, audioMix: AVAudioMix? = nil, videoComposition: AVVideoComposition? = nil, outputURL: URL) {
    let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1920x1080)!
    exportSession.outputURL = outputURL
    exportSession.outputFileType = .mov
    exportSession.audioMix = audioMix
    exportSession.videoComposition = videoComposition
    exportSession.exportAsynchronously {
        switch exportSession.status {
        case .unknown:
            print("unknown")
        case .waiting:
            print("waiting")
        case .exporting:
            print("exporting")
        case .completed:
            print("Export finished.")
        case .failed:
            print("error: \(exportSession.error!.localizedDescription)")
        case .cancelled:
            print("cancelled")
        }
    }
}
