//
//  MetalEngine.swift
//  Pong
//
//  Created by Tiger Nixon on 5/4/23.
//

import Foundation
import UIKit
import Metal

class MetalEngine {
    
    let delegate: GraphicsDelegate
    let graphics: Graphics
    let layer: CAMetalLayer
    
    var scale: CGFloat
    var device: MTLDevice
    var library: MTLLibrary
    var commandQueue: MTLCommandQueue
    
    required init(delegate: GraphicsDelegate, graphics: Graphics, layer: CAMetalLayer) {
        self.delegate = delegate
        self.graphics = graphics
        self.layer = layer
        
        scale = UIScreen.main.scale
        device = MTLCreateSystemDefaultDevice()!
        library = device.makeDefaultLibrary()!
        commandQueue = device.makeCommandQueue()!
        
        layer.device = device
        layer.contentsScale = scale
    }
    
    func load() {
        
    }
    
    func draw() {
        
        guard let drawable = layer.nextDrawable() else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.075, green: 0.075, blue: 0.125, alpha: 1.0)
        
        if let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
            delegate.draw(renderEncoder: renderEncoder)
            renderEncoder.endEncoding()
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
