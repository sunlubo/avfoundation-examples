//
//  Capture.playground
//
//  Copyright © 2018 sunlubo. All rights reserved.
//

//: [Previous](@previous)

import Foundation
import AVFoundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let captureSession = AVCaptureSession()
captureSession.sessionPreset
captureSession.inputs
captureSession.outputs

let captureDevice = AVCaptureDevice.default(for: .video)!
captureDevice.uniqueID
captureDevice.modelID
captureDevice.localizedName
captureDevice.transportType
captureDevice.isConnected
captureDevice.formats
captureDevice.activeFormat.mediaType.rawValue
captureDevice.activeFormat.videoSupportedFrameRateRanges
captureDevice.activeVideoMinFrameDuration
captureDevice.activeVideoMaxFrameDuration
captureDevice.inputSources
captureDevice.activeInputSource

let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
captureDeviceInput.ports

let captureDeviceOutput = AVCaptureStillImageOutput()
captureDeviceOutput.outputSettings
captureDeviceOutput.availableImageDataCVPixelFormatTypes
captureDeviceOutput.availableImageDataCodecTypes
captureDeviceOutput.isCapturingStillImage
captureDeviceOutput.connections

if captureSession.canAddInput(captureDeviceInput) {
    captureSession.addInput(captureDeviceInput)
}
if captureSession.canAddOutput(captureDeviceOutput) {
    captureSession.addOutput(captureDeviceOutput)
}

let connection = captureDeviceOutput.connection(with: .video)!
connection.isActive

captureDeviceOutput.captureStillImageAsynchronously(from: connection) { buffer, error in
    print("hahhhh")
}

//: [Next](@next)
