import Foundation
import Cocoa
import AVFoundation
import Metal
import MetalKit
import CoreVideo

extension MTLTexture {
    
    var threadsPerThreadgroup: MTLSize {
        return MTLSizeMake(8, 8, 1)
    }
    
    var threadgroupsPerGrid: MTLSize {
        return MTLSizeMake(Int(width) / threadsPerThreadgroup.width, Int(height) / threadsPerThreadgroup.height, 1)
    }
}

extension CVPixelBuffer {
    
    var width: Int {
        return CVPixelBufferGetWidth(self)
    }
    
    var height: Int {
        return CVPixelBufferGetHeight(self)
    }
}

public final class Render: NSObject, MTKViewDelegate {
    let context = MetalContext.shared
    let computePipelineState: MTLComputePipelineState
    var textureCache: CVMetalTextureCache!
    
    public var pixelBuffer: CVPixelBuffer?
    
    public init(mtkView: MTKView) {
        let function = context.makeFunction(name: "grayscale")
        computePipelineState = context.makeComputePipelineState(function: function)
        
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, context.device, nil, &textureCache) != kCVReturnSuccess {
            fatalError("Unable to allocate texture cache.")
        }
        
        super.init()
        
        mtkView.device = context.device
        mtkView.framebufferOnly = false
        mtkView.autoResizeDrawable = false
        mtkView.drawableSize = CGSize(width: 1920, height: 1080)
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        guard let pixelBuffer = pixelBuffer, let drawable = view.currentDrawable else {
            return
        }
        
        var cvTextureOut: CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, nil, .bgra8Unorm, pixelBuffer.width, pixelBuffer.height, 0, &cvTextureOut)
        guard let cvTexture = cvTextureOut, let inputTexture = CVMetalTextureGetTexture(cvTexture) else {
            print("Failed to create metal texture")
            return
        }
        
        let commandBuffer = context.makeCommandBuffer()
        
        let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder()!
        computeCommandEncoder.setComputePipelineState(computePipelineState)
        computeCommandEncoder.setTexture(inputTexture, index: 0)
        computeCommandEncoder.setTexture(drawable.texture, index: 1)
        computeCommandEncoder.dispatchThreadgroups(inputTexture.threadgroupsPerGrid, threadsPerThreadgroup: inputTexture.threadsPerThreadgroup)
        computeCommandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
