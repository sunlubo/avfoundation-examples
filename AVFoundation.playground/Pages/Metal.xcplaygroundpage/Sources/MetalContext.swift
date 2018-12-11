import Foundation
import Metal

public final class MetalContext {
    public static let shared = MetalContext()
    
    public let device: MTLDevice
    public let library: MTLLibrary
    public let commandQueue: MTLCommandQueue
    
    public init() {
        let resource = Bundle.main.url(forResource: "Kernels", withExtension: "metal")!
        self.device = MTLCreateSystemDefaultDevice()!
        do {
            self.library = try device.makeLibrary(source: String(contentsOf: resource), options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        self.commandQueue = device.makeCommandQueue()!
    }
    
    public func makeFunction(name: String) -> MTLFunction {
        return library.makeFunction(name: name)!
    }
    
    public func makeRenderPipelineState(descriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState {
        do {
            return try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func makeComputePipelineState(function: MTLFunction) -> MTLComputePipelineState {
        do {
            return try device.makeComputePipelineState(function: function)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func makeCommandBuffer() -> MTLCommandBuffer {
        return commandQueue.makeCommandBuffer()!
    }
    
    public func makeTexture(descriptor: MTLTextureDescriptor) -> MTLTexture {
        return device.makeTexture(descriptor: descriptor)!
    }
}
