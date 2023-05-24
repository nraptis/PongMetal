//
//  MetalPipeline.swift
//  Pong
//
//  Created by Tiger Nixon on 5/4/23.
//

import Foundation
import UIKit
import Metal

class MetalPipeline {
    
    static let shapeVertexIndexPosition = 0
    static let shapeVertexIndexUniforms = 1
    static let shapeFragmentIndexUniforms = 0
    
    private let engine: MetalEngine
    private let library: MTLLibrary
    private let layer: CAMetalLayer
    private let device: MTLDevice
    init(engine: MetalEngine) {
        self.engine = engine
        library = engine.library
        layer = engine.layer
        device = engine.device
    }
    
    private var shape2DVertexProgram: MTLFunction!
    private var shape2DFragmentProgram: MTLFunction!
    
    private(set) var pipelineStateShape2DNoBlending: MTLRenderPipelineState!
    
    func load() {
        buildFunctions()
        
        buildPipelineStatesShape2D()
    }
    
    private func buildFunctions() {
        shape2DVertexProgram = library.makeFunction(name: "shape_2d_vertex")
        shape2DFragmentProgram = library.makeFunction(name: "shape_2d_fragment")
    }
    
    private func buildPipelineStatesShape2D() {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[Self.shapeVertexIndexPosition].format = MTLVertexFormat.float2
        vertexDescriptor.attributes[Self.shapeVertexIndexPosition].bufferIndex = Self.shapeVertexIndexPosition
        vertexDescriptor.layouts[Self.shapeVertexIndexPosition].stride = MemoryLayout<Float>.size * 2
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        pipelineDescriptor.vertexFunction = shape2DVertexProgram
        pipelineDescriptor.fragmentFunction = shape2DFragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = layer.pixelFormat
        pipelineStateShape2DNoBlending = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
    }
}
