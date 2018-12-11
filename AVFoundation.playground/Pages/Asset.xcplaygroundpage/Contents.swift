//
//  Asset.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import Cocoa
import AVFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "file:///Users/sun/AV/BoML.mp4")!
let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])

asset.duration.seconds
// video
asset.preferredRate
asset.preferredTransform
// audio
asset.preferredVolume

// A Boolean value that indicates whether the asset, or its URL, can be used to initialize an instance of AVPlayerItem.
asset.isPlayable
// A Boolean value that indicates whether the asset can be exported using AVAssetExportSession.
asset.isExportable
// A Boolean value that indicates whether the asset’s media data can be extracted using AVAssetReader.
asset.isReadable
// A Boolean value that indicates whether the asset can be used within a segment of an AVCompositionTrack object.
asset.isComposable

// MARK: - Metadata

asset.creationDate
asset.commonMetadata
asset.metadata

AVMetadataIdentifier.commonIdentifierAlbumName.rawValue
AVMetadataIdentifier.iTunesMetadataEncodingTool.rawValue
AVMetadataIdentifier.iTunesMetadataDescription.rawValue
AVMetadataIdentifier.icyMetadataStreamTitle.rawValue
AVMetadataIdentifier.id3MetadataAlbumTitle.rawValue
AVMetadataIdentifier.isoUserDataCopyright.rawValue
AVMetadataIdentifier.quickTimeMetadataAlbum.rawValue
AVMetadataIdentifier.quickTimeUserDataAlbum.rawValue
AVMetadataIdentifier.identifier3GPUserDataTitle.rawValue

for metadataFormat in asset.availableMetadataFormats {
    for metadata in asset.metadata(forFormat: metadataFormat) {
        print("identifier: \(metadata.identifier!.rawValue) value: \(metadata.stringValue ?? "nil")")
    }
}

// MARK: - Track

asset.tracks
asset.tracks(withMediaType: .audio)

for segment in asset.tracks.flatMap({ $0.segments }) {
    CMTimeMappingShow(segment.timeMapping)
}

// MARK: - Async

asset.loadValuesAsynchronously(forKeys: ["duration"]) {
    var error: NSError?
    switch asset.statusOfValue(forKey: "duration", error: &error) {
    case .unknown:
        print("unknown")
    case .loading:
        print("loading")
    case .loaded:
        print("duration: \(asset.duration.seconds)s")
    case .failed:
        print("failed: \(error!.localizedDescription)")
    case .cancelled:
        print("cancelled")
    }
}

// MARK: - Media Characteristics

asset.availableMediaCharacteristicsWithMediaSelectionOptions

//: [Next](@next)
